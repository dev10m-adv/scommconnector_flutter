import 'dart:async';

import '../../../../core/errors/errors.dart';
import '../../../../core/logging/log.dart';
import '../../../../core/resilience/online_aware_resilience.dart';
import '../../domain/entities/signaling_entities.dart';
import '../../domain/services/connection_health_monitor.dart';
import '../../domain/services/request_matcher.dart';
import '../../domain/services/signaling_error_classifier.dart';
import '../../domain/usecases/connect_signaling_usecase.dart';
import '../../domain/usecases/disconnect_signaling_usecase.dart';
import '../../domain/usecases/send_signal_envelope_usecase.dart';
import '../../domain/usecases/watch_presence_usecase.dart';
import '../state/signaling_state.dart';

/// Orchestrates signaling lifecycle, connection management, and message routing.
///
/// Follows Clean Architecture:
/// - Delegates transport concerns to SignalingRepository
/// - Delegates heartbeat to IConnectionHealthMonitor
/// - Delegates error classification to ISignalingErrorClassifier
/// - Delegates internet monitoring to IOnlineAwareResilience
/// - Delegates request matching to IRequestMatcher
///
/// Single Responsibility: Orchestrate signaling operations and manage state.
class SignalingController {
  final ConnectSignalingUseCase connectSignalingUseCase;
  final DisconnectSignalingUseCase disconnectSignalingUseCase;
  final SendSignalEnvelopeUseCase sendSignalEnvelopeUseCase;
  final WatchPresenceUseCase watchPresenceUseCase;
  final IConnectionHealthMonitor healthMonitor;
  final ISignalingErrorClassifier errorClassifier;
  final IOnlineAwareResilience onlineAwareness;
  final IRequestMatcher requestMatcher;

  SignalingState _state = const SignalingState();
  StreamSubscription<SignalEnvelope>? _inboundSubscription;
  StreamSubscription<SignalingPresenceEvent>? _presenceSubscription;

  String? _deviceId;
  bool _stoppedManually = false;
  bool _autoReconnectEnabled = true;
  bool _reconnectInProgress = false;

  final _incomingController = StreamController<SignalEnvelope>.broadcast();
  final _presenceController =
      StreamController<SignalingPresenceEvent>.broadcast();

  SignalingController({
    required this.connectSignalingUseCase,
    required this.disconnectSignalingUseCase,
    required this.sendSignalEnvelopeUseCase,
    required this.watchPresenceUseCase,
    required this.healthMonitor,
    required this.errorClassifier,
    required this.onlineAwareness,
    required this.requestMatcher,
  });

  SignalingState get state => _state;
  Stream<SignalEnvelope> get incomingMessages => _incomingController.stream;
  Stream<SignalingPresenceEvent> get presenceEvents =>
      _presenceController.stream;

  Future<void> start({required String deviceId}) async {
    infoLog('Signaling start requested for deviceId=$deviceId.');
    _deviceId = deviceId;
    _stoppedManually = false;
    _autoReconnectEnabled = true;

    await _connectWithRetries(isReconnect: false);
    await _startOnlineAwareness();
  }

  Future<void> stop() async {
    infoLog('Signaling stop requested.');
    _stoppedManually = true;
    _autoReconnectEnabled = false;
    await onlineAwareness.stopMonitoring();
    await healthMonitor.stopHeartbeat();
    await _disposeStreamBindings();
    await disconnectSignalingUseCase();
    requestMatcher.clearAllRequests();

    _state = _state.copyWith(
      status: SignalingStatus.disconnected,
      message: 'Disconnected.',
      clearError: true,
    );
    infoLog('Signaling disconnected and cleaned up.');
  }

  Future<void> sendConnectionRequest({
    required String requestId,
    required String fromUri,
    required String toUri,
    required String serviceName,
    String note = '',
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final completer = requestMatcher.registerRequest(requestId);

    await sendEnvelope(
      SignalEnvelope(
        messageId: _buildMessageId(),
        from: SignalingDeviceRef(uri: fromUri),
        to: SignalingDeviceRef(uri: toUri),
        connectionRequest: SignalingConnectionRequest(
          requestId: requestId,
          serviceName: serviceName,
          note: note,
        ),
      ),
    );

    try {
      final response = await completer.future.timeout(timeout);
      _ensureConnectionAccepted(response);
    } on TimeoutException {
      throw const ServerException(
        message: 'Connection timed out. Target may be offline or unreachable.',
      );
    } finally {
      requestMatcher.failRequest(requestId, 'Request cancelled.');
    }
  }

  Future<void> sendEnvelope(SignalEnvelope envelope) async {
    try {
      debugLog(
        'Sending signaling envelope type=${envelope.payloadType} messageId=${envelope.messageId}.',
      );
      await sendSignalEnvelopeUseCase(envelope);
    } catch (error) {
      final appError = errorClassifier.toAppError(error);
      _state = _state.copyWith(
        status: SignalingStatus.failure,
        error: appError.message,
      );
      errorLog('Failed to send signaling envelope.', error);
      rethrow;
    }
  }

  Future<void> watchPresence({required List<String> targetUris}) async {
    try {
      infoLog('Starting presence watch for ${targetUris.length} targets.');
      await _presenceSubscription?.cancel();
      _presenceSubscription = watchPresenceUseCase(targetUris: targetUris)
          .listen(
            _presenceController.add,
            onError: (Object error, StackTrace stackTrace) {
              warningLog('Presence stream emitted error.', error, stackTrace);
              _presenceController.addError(
                errorClassifier.toAppError(error),
                stackTrace,
              );
            },
          );
    } catch (error) {
      _state = _state.copyWith(
        status: SignalingStatus.failure,
        error: errorClassifier.toAppError(error).message,
      );
      errorLog('Failed to start presence watch.', error);
      rethrow;
    }
  }

  Future<void> dispose() async {
    await stop();
    await _incomingController.close();
    await _presenceController.close();
  }

  Future<void> _connectWithRetries({required bool isReconnect}) async {
    final deviceId = _deviceId;
    if (deviceId == null || deviceId.isEmpty) {
      throw const ServerException(message: 'Missing device id for signaling.');
    }

    for (var attempt = 0; attempt <= 3; attempt++) {
      if (_stoppedManually) {
        return;
      }

      final isFinalAttempt = attempt == 3;
      final shouldShowReconnect = isReconnect && attempt > 0;

      _state = _state.copyWith(
        status: shouldShowReconnect
            ? SignalingStatus.reconnecting
            : SignalingStatus.connecting,
        message: shouldShowReconnect
            ? 'Reconnecting (attempt ${attempt + 1})...'
            : null,
        clearError: true,
      );

      try {
        await _disposeStreamBindings();
        infoLog(
          'Opening signaling stream. isReconnect=$isReconnect attempt=${attempt + 1}.',
        );
        final stream = connectSignalingUseCase(deviceId: deviceId);
        _bindIncoming(stream);
        healthMonitor.startHeartbeat(
          interval: const Duration(minutes: 15),
          onSendHeartbeat: (envelope) => sendEnvelope(envelope),
        );

        _state = _state.copyWith(
          status: SignalingStatus.connected,
          message: 'Connected.',
          clearError: true,
        );
        infoLog('Signaling connected successfully.');
        return;
      } catch (error) {
        final appError = errorClassifier.toAppError(error);
        warningLog(
          'Signaling connection attempt failed on attempt ${attempt + 1}.',
          appError,
        );
        if (!errorClassifier.shouldAutoReconnect(appError)) {
          _autoReconnectEnabled = false;
          _state = _state.copyWith(
            status: SignalingStatus.failure,
            error: appError.message,
          );
          throw appError;
        }

        if (isFinalAttempt) {
          _state = _state.copyWith(
            status: SignalingStatus.failure,
            error: appError.message,
          );
          throw appError;
        }

        const retrySchedule = <Duration>[
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ];
        if (attempt < retrySchedule.length) {
          await Future<void>.delayed(retrySchedule[attempt]);
        }
      }
    }
  }

  void _bindIncoming(Stream<SignalEnvelope> stream) {
    debugLog('Binding incoming signaling stream.');
    _inboundSubscription = stream.listen(
      (envelope) {
        debugLog(
          'Incoming signaling envelope type=${envelope.payloadType} messageId=${envelope.messageId}.',
        );
        _incomingController.add(envelope);
        _handleEnvelope(envelope);
      },
      onError: (Object error, StackTrace stackTrace) {
        warningLog('Signaling stream emitted error.', error, stackTrace);
        _incomingController.addError(error, stackTrace);
        _handleDisconnect(errorClassifier.toAppError(error));
      },
      onDone: () {
        warningLog('Signaling stream completed unexpectedly.');
        _handleDisconnect(
          const UnknownAppException(
            message: 'Signaling stream ended unexpectedly.',
          ),
        );
      },
      cancelOnError: false,
    );
  }

  void _handleEnvelope(SignalEnvelope envelope) {
    switch (envelope.payloadType) {
      case SignalingPayloadType.connectionResponse:
        final response = envelope.connectionResponse!;
        final matched = requestMatcher.completeRequest(
          response.requestId,
          response,
        );
        if (!matched) {
          warningLog(
            'Received response for unknown requestId=${response.requestId}. '
            'status=${response.status}. Pending requests=${requestMatcher.getPendingRequestIds()}',
          );
        } else {
          debugLog(
            'Matched connection response for requestId=${response.requestId} status=${response.status}.',
          );
        }
        break;

      case SignalingPayloadType.ping:
        // Respond to ping with pong
        _respondToPing(envelope);
        break;

      case SignalingPayloadType.pong:
        // Pong received; heartbeat system will handle timing
        break;

      case SignalingPayloadType.connectionRequest:
      case SignalingPayloadType.offer:
      case SignalingPayloadType.answer:
      case SignalingPayloadType.iceCandidate:
        // Pass through to incomingMessages stream for ConnectController to handle
        break;

      case SignalingPayloadType.hello:
      case SignalingPayloadType.unknown:
        // Ignore hello/unknown payload types at controller level
        break;
    }
  }

  Future<void> _respondToPing(SignalEnvelope pingEnvelope) async {
    try {
      debugLog(
        'Responding to ping messageId=${pingEnvelope.messageId} from=${pingEnvelope.from?.uri}.',
      );
      final pongEnvelope = SignalEnvelope(
        messageId: _buildMessageId(),
        from: pingEnvelope.to,
        to: pingEnvelope.from,
        pongTimestampMs: DateTime.now().millisecondsSinceEpoch,
      );
      await sendEnvelope(pongEnvelope);
    } catch (error) {
      warningLog('Error responding to ping.', error);
    }
  }

  void _ensureConnectionAccepted(SignalingConnectionResponse response) {
    if (response.status == SignalingConnectionResponseStatus.accepted) {
      return;
    }

    final reason = response.reason.isNotEmpty ? response.reason : null;
    switch (response.status) {
      case SignalingConnectionResponseStatus.rejected:
        throw ServerException(
          message: reason ?? 'Connection request was rejected.',
        );
      case SignalingConnectionResponseStatus.busy:
        throw ServerException(message: reason ?? 'Target device is busy.');
      case SignalingConnectionResponseStatus.blocked:
        throw UnauthorizedException(
          message: reason ?? 'Connection blocked by target device.',
        );
      case SignalingConnectionResponseStatus.unspecified:
      default:
        throw ServerException(message: reason ?? 'Connection request failed.');
    }
  }

  Future<void> _startOnlineAwareness() async {
    await onlineAwareness.startMonitoring(
      onRecoveryNeeded: _handleInternetRecovery,
      shouldAutoRecover: () => !_stoppedManually && _autoReconnectEnabled,
    );
  }

  Future<void> _handleInternetRecovery() async {
    if (_reconnectInProgress) {
      debugLog('Skipping internet recovery; reconnect is already in progress.');
      return;
    }

    _state = _state.copyWith(
      status: SignalingStatus.reconnecting,
      message: 'Internet recovered. Reconnecting...',
    );

    _reconnectInProgress = true;
    try {
      infoLog('Internet recovered. Attempting signaling reconnect.');
      await _connectWithRetries(isReconnect: true);
    } finally {
      _reconnectInProgress = false;
    }
  }

  void _handleDisconnect(AppException error) {
    if (_stoppedManually) {
      debugLog('Ignoring disconnect because signaling was stopped manually.');
      return;
    }

    warningLog('Handling signaling disconnect: ${error.message}', error);

    if (!errorClassifier.shouldAutoReconnect(error)) {
      _autoReconnectEnabled = false;
      _state = _state.copyWith(
        status: SignalingStatus.failure,
        error: error.message,
        clearMessage: true,
      );
      return;
    }

    if (!_autoReconnectEnabled || _reconnectInProgress) {
      return;
    }

    _state = _state.copyWith(
      status: SignalingStatus.reconnecting,
      message: 'Connection lost. Reconnecting...',
      error: error.message,
    );

    _reconnectInProgress = true;
    _connectWithRetries(isReconnect: true).whenComplete(() {
      _reconnectInProgress = false;
    });
  }

  Future<void> _disposeStreamBindings() async {
    await _inboundSubscription?.cancel();
    _inboundSubscription = null;
    debugLog('Disposed signaling stream bindings.');
  }

  String _buildMessageId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return 'sig-$timestamp';
  }
}
