import 'dart:async';

import 'package:scommconnector/features/webrtc/domain/usecases/connection_state_usecase.dart';

import '../../../../core/errors/errors.dart';
import '../../../../core/logging/log.dart';
import '../../../../core/resilience/online_aware_resilience.dart';
import '../../domain/entities/webrtc_connection_state.dart';
import '../../domain/entities/webrtc_data_message.dart';
import '../../domain/entities/webrtc_ice_candidate.dart';
import '../../domain/entities/webrtc_ice_server_config.dart';
import '../../domain/entities/webrtc_session_description.dart';
import '../../domain/usecases/add_data_channel_usecase.dart';
import '../../domain/usecases/add_remote_ice_candidate_usecase.dart';
import '../../domain/usecases/close_webrtc_usecase.dart';
import '../../domain/usecases/create_webrtc_answer_usecase.dart';
import '../../domain/usecases/create_webrtc_offer_usecase.dart';
import '../../domain/usecases/initialize_webrtc_usecase.dart';
import '../../domain/usecases/remove_data_channel_usecase.dart';
import '../../domain/usecases/send_webrtc_data_usecase.dart';
import '../../domain/usecases/set_remote_answer_usecase.dart';
import '../../domain/repositories/webrtc_repository.dart';
import '../../domain/services/connection_recovery_strategy.dart';
import '../state/webrtc_state.dart';

/// Orchestrates WebRTC lifecycle, negotiation, and recovery.
///
/// Follows Clean Architecture:
/// - Delegates transport concerns to WebRtcRepository
/// - Delegates recovery strategy to IConnectionRecoveryStrategy
/// - Delegates internet monitoring to IOnlineAwareResilience
///
/// Single Responsibility: Orchestrate WebRTC operations and manage state.
///
/// SOLID Principles Applied:
/// - SRP: Only handles state and orchestration, not retry/recovery details
/// - OCP: Recovery behavior can be swapped via IConnectionRecoveryStrategy
/// - LSP: Dependencies are interfaces, not concrete implementations
/// - ISP: Services expose only needed methods
/// - DIP: Depends on abstractions, not concrete services
class WebRtcController {
  final WebRtcRepository repository;
  final InitializeWebRtcUseCase initializeWebRtcUseCase;
  final CreateWebRtcOfferUseCase createWebRtcOfferUseCase;
  final CreateWebRtcAnswerUseCase createWebRtcAnswerUseCase;
  final SetRemoteAnswerUseCase setRemoteAnswerUseCase;
  final AddRemoteIceCandidateUseCase addRemoteIceCandidateUseCase;
  final AddDataChannelUseCase addDataChannelUseCase;
  final RemoveDataChannelUseCase removeDataChannelUseCase;
  final SendWebRtcDataUseCase sendWebRtcDataUseCase;
  final CloseWebRtcUseCase closeWebRtcUseCase;
  final IConnectionRecoveryStrategy recoveryStrategy;
  final ConnectionStateUseCase connectionStateUseCase;
  final IOnlineAwareResilience onlineAwareness;

  WebRtcState _state = const WebRtcState();
  StreamSubscription<WebRtcConnectionState>? _connectionStateSubscription;
  bool _closingInProgress = false;

  WebRtcController({
    required this.repository,
    required this.initializeWebRtcUseCase,
    required this.createWebRtcOfferUseCase,
    required this.createWebRtcAnswerUseCase,
    required this.setRemoteAnswerUseCase,
    required this.addRemoteIceCandidateUseCase,
    required this.addDataChannelUseCase,
    required this.removeDataChannelUseCase,
    required this.sendWebRtcDataUseCase,
    required this.closeWebRtcUseCase,
    required this.recoveryStrategy,
    required this.onlineAwareness,
    required this.connectionStateUseCase,
  });

  WebRtcState get state => _state;
  Stream<WebRtcIceCandidate> get localIceCandidates =>
      repository.localIceCandidates;
      
  Future<void> initialize({
    required List<String> dataChannels,
    List<WebRtcIceServerConfig>? iceServers,
  }) async {
    infoLog(
      'WebRTC controller initialize requested channels=${dataChannels.length}.',
    );
    _state = _state.copyWith(
      status: WebRtcStatus.initializing,
      clearError: true,
      clearMessage: true,
      retryCount: 0,
    );

    try {
      await initializeWebRtcUseCase(
        dataChannelLabels: dataChannels,
        iceServers: iceServers,
      );
      await _bindObservers();
      _state = _state.copyWith(
        status: WebRtcStatus.negotiating,
        message: 'Peer connection initialized.',
      );
      infoLog('WebRTC peer initialized and observers bound.');
    } catch (error) {
      _state = _state.copyWith(
        status: WebRtcStatus.failed,
        error: _toAppError(error).message,
      );
      errorLog('WebRTC initialization failed.', error);
      rethrow;
    }
  }

  Future<WebRtcSessionDescription> createOffer({
    bool iceRestart = false,
  }) async {
    try {
      debugLog('WebRTC createOffer called. iceRestart=$iceRestart.');
      _state = _state.copyWith(
        status: WebRtcStatus.negotiating,
        message: iceRestart ? 'Restarting ICE...' : 'Creating offer...',
        clearError: true,
      );
      return await createWebRtcOfferUseCase(iceRestart: iceRestart);
    } catch (error) {
      _state = _state.copyWith(
        status: WebRtcStatus.failed,
        error: _toAppError(error).message,
      );
      errorLog('WebRTC createOffer failed.', error);
      rethrow;
    }
  }

  Future<WebRtcSessionDescription> createAnswerForOffer(
    WebRtcSessionDescription offer,
  ) async {
    try {
      debugLog('WebRTC createAnswerForOffer called for type=${offer.type}.');
      _state = _state.copyWith(
        status: WebRtcStatus.negotiating,
        message: 'Creating answer...',
        clearError: true,
      );
      return await createWebRtcAnswerUseCase(offer);
    } catch (error) {
      _state = _state.copyWith(
        status: WebRtcStatus.failed,
        error: _toAppError(error).message,
      );
      errorLog('WebRTC createAnswerForOffer failed.', error);
      rethrow;
    }
  }

  Future<void> setRemoteAnswer(WebRtcSessionDescription answer) async {
    debugLog('Setting remote WebRTC answer type=${answer.type}.');
    await setRemoteAnswerUseCase(answer);
  }

  Future<void> addRemoteIceCandidate(WebRtcIceCandidate candidate) {
    return addRemoteIceCandidateUseCase(candidate);
  }

  Future<void> addDataChannel(String label) {
    return addDataChannelUseCase(label);
  }

  Future<void> removeDataChannel(String label) {
    return removeDataChannelUseCase(label);
  }

  Stream<WebRtcConnectionState> get connectionStates => connectionStateUseCase();
  Stream<WebRtcDataMessage> get receivedDataMessages => repository.dataMessages;
  Future<void> sendData({
    required String channelLabel,
    required String message,
  }) {
    return sendWebRtcDataUseCase(channelLabel: channelLabel, message: message);
  }

  Future<void> close() async {
    infoLog('WebRTC controller close requested.');
    _closingInProgress = true;
    try {
      await onlineAwareness.stopMonitoring();
      await _connectionStateSubscription?.cancel();
      _connectionStateSubscription = null;
      await closeWebRtcUseCase();

      _state = _state.copyWith(
        status: WebRtcStatus.closed,
        message: 'WebRTC closed.',
        clearError: true,
      );
      infoLog('WebRTC controller closed.');
    } finally {
      _closingInProgress = false;
    }
  }

  Future<void> dispose() async {
    await close();
  }

  // PRIVATE METHODS

  Future<void> _bindObservers() async {
    await _connectionStateSubscription?.cancel();
    _connectionStateSubscription = repository.connectionStates.listen((
      connectionState,
    ) {
      // Suppress recovery callbacks if intentional close is in progress
      if (_closingInProgress) {
        return;
      }

      debugLog('Observed WebRTC connection state=$connectionState.');

      switch (connectionState) {
        case WebRtcConnectionState.connected:
          _state = _state.copyWith(
            status: WebRtcStatus.connected,
            retryCount: 0,
            message: 'Connected.',
            clearError: true,
          );
          infoLog('WebRTC connection established.');
          break;
        case WebRtcConnectionState.disconnected:
        case WebRtcConnectionState.failed:
          warningLog('WebRTC connection degraded: state=$connectionState.');
          _triggerRecovery();
          break;
        case WebRtcConnectionState.closed:
          _state = _state.copyWith(status: WebRtcStatus.closed);
          infoLog('WebRTC connection closed.');
          break;
        case WebRtcConnectionState.newState:
        case WebRtcConnectionState.connecting:
          break;
      }
    });

    // Monitor internet status for network-level recovery
    await onlineAwareness.startMonitoring(
      onRecoveryNeeded: _handleInternetRecovery,
      shouldAutoRecover: () => !_closingInProgress,
    );
  }

  Future<void> _handleInternetRecovery() async {
    if (_closingInProgress || recoveryStrategy.isRecovering) {
      debugLog(
        'Ignoring internet recovery callback; close/recovery already in progress.',
      );
      return;
    }

    _state = _state.copyWith(
      status: WebRtcStatus.retrying,
      message: 'Internet recovered. Attempting recovery...',
    );

    try {
      infoLog('Internet recovered, triggering WebRTC recovery.');
      await _triggerRecovery();
    } catch (_) {
      // State already updated by recovery strategy
    }
  }

  Future<void> _triggerRecovery() async {
    if (_closingInProgress || recoveryStrategy.isRecovering) {
      debugLog('Skipping recovery trigger; already closing or recovering.');
      return;
    }

    try {
      infoLog('Starting WebRTC recovery attempt.');
      await recoveryStrategy.recover();
      infoLog('WebRTC recovery attempt finished.');
    } catch (error) {
      _state = _state.copyWith(
        status: WebRtcStatus.failed,
        error: _toAppError(error).message,
      );
      errorLog('WebRTC recovery failed.', error);
    }
  }

  AppException _toAppError(Object error) {
    if (error is AppException) {
      return error;
    }
    if (error is StateError) {
      return ServerException(message: error.message);
    }
    return const UnknownAppException(
      message: 'WebRTC failed due to an unexpected error.',
    );
  }
}
