import 'dart:async';

import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';

import '../../../../core/errors/errors.dart';
import '../../../../core/logging/log.dart';
import '../../../../core/resilience/online_aware_resilience.dart';
import '../../domain/entities/webrtc_connection_state.dart';
import '../../domain/entities/webrtc_data_message.dart';
import '../../domain/entities/webrtc_ice_candidate.dart';
import '../../domain/entities/webrtc_ice_route.dart';
import '../../domain/entities/webrtc_ice_server_config.dart';
import '../../domain/entities/webrtc_session_description.dart';
import '../../domain/services/connection_recovery_strategy.dart';
import '../../domain/usecases/add_data_channel_usecase.dart';
import '../../domain/usecases/add_remote_ice_candidate_usecase.dart';
import '../../domain/usecases/close_webrtc_usecase.dart';
import '../../domain/usecases/connection_state_usecase.dart';
import '../../domain/usecases/create_webrtc_answer_usecase.dart';
import '../../domain/usecases/create_webrtc_offer_usecase.dart';
import '../../domain/usecases/initialize_webrtc_usecase.dart';
import '../../domain/usecases/remove_data_channel_usecase.dart';
import '../../domain/usecases/send_webrtc_data_usecase.dart';
import '../../domain/usecases/set_remote_answer_usecase.dart';
import '../state/webrtc_state.dart';

class WebRtcController {
  final WebRtcSessionManager sessionManager;
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

  final Map<String, WebRtcState> _states = {};
  final Map<String, StreamSubscription<WebRtcConnectionState>> _connectionSubs = {};
  final Set<String> _closingSessions = {};
  final _stateController = StreamController<Map<String, WebRtcState>>.broadcast();

  WebRtcController({
    required this.sessionManager,
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

  Map<String, WebRtcState> get states => Map.unmodifiable(_states);
  Stream<Map<String, WebRtcState>> get webRtcStates => _stateController.stream;

  WebRtcState stateOf(String sessionId) {
    return _states[sessionId] ?? const WebRtcState();
  }

  Stream<WebRtcIceCandidate> localIceCandidates(String sessionId) {
    return sessionManager.getOrCreate(sessionId).localIceCandidates;
  }

  Stream<WebRtcIceRoute> iceRoutes(String sessionId) {
    return sessionManager.getOrCreate(sessionId).iceRoutes;
  }

  WebRtcIceRoute iceRouteOf(String sessionId) {
    return sessionManager.getOrCreate(sessionId).iceRoute;
  }

  Stream<WebRtcDataMessage> receivedDataMessages(String sessionId) {
    return sessionManager.getOrCreate(sessionId).dataMessages;
  }

  Stream<WebRtcConnectionState> connectionStates(String sessionId) {
    return connectionStateUseCase(sessionId: sessionId);
  }

  Future<void> initialize({
    required String sessionId,
    required List<String> dataChannels,
    List<WebRtcIceServerConfig>? iceServers,
  }) async {
    infoLog(
      'WebRTC initialize requested. sessionId=$sessionId channels=${dataChannels.length}',
    );

    _emitState(
      sessionId,
      stateOf(sessionId).copyWith(
        status: WebRtcStatus.initializing,
        clearError: true,
        clearMessage: true,
        retryCount: 0,
      ),
    );

    try {
      await initializeWebRtcUseCase(
        sessionId: sessionId,
        dataChannelLabels: dataChannels,
        iceServers: iceServers,
      );

      await _bindObservers(sessionId);

      _emitState(
        sessionId,
        stateOf(sessionId).copyWith(
          status: WebRtcStatus.negotiating,
          message: 'Peer connection initialized.',
        ),
      );

      infoLog('WebRTC initialized. sessionId=$sessionId');
    } catch (error) {
      _emitState(
        sessionId,
        stateOf(sessionId).copyWith(
          status: WebRtcStatus.failed,
          error: _toAppError(error).message,
        ),
      );
      errorLog('WebRTC initialization failed. sessionId=$sessionId', error);
      rethrow;
    }
  }

  Future<WebRtcSessionDescription> createOffer({
    required String sessionId,
    bool iceRestart = false,
  }) async {
    try {
      _emitState(
        sessionId,
        stateOf(sessionId).copyWith(
          status: WebRtcStatus.negotiating,
          message: iceRestart ? 'Restarting ICE...' : 'Creating offer...',
          clearError: true,
        ),
      );

      return await createWebRtcOfferUseCase(
        sessionId: sessionId,
        iceRestart: iceRestart,
      );
    } catch (error) {
      _emitState(
        sessionId,
        stateOf(sessionId).copyWith(
          status: WebRtcStatus.failed,
          error: _toAppError(error).message,
        ),
      );
      errorLog('WebRTC createOffer failed. sessionId=$sessionId', error);
      rethrow;
    }
  }

  Future<WebRtcSessionDescription> createAnswerForOffer({
    required String sessionId,
    required WebRtcSessionDescription offer,
  }) async {
    try {
      _emitState(
        sessionId,
        stateOf(sessionId).copyWith(
          status: WebRtcStatus.negotiating,
          message: 'Creating answer...',
          clearError: true,
        ),
      );

      return await createWebRtcAnswerUseCase(
        sessionId: sessionId,
        offer: offer,
      );
    } catch (error) {
      _emitState(
        sessionId,
        stateOf(sessionId).copyWith(
          status: WebRtcStatus.failed,
          error: _toAppError(error).message,
        ),
      );
      errorLog('WebRTC createAnswer failed. sessionId=$sessionId', error);
      rethrow;
    }
  }

  Future<void> setRemoteAnswer({
    required String sessionId,
    required WebRtcSessionDescription answer,
  }) {
    return setRemoteAnswerUseCase(
      sessionId: sessionId,
      answer: answer,
    );
  }

  Future<void> addRemoteIceCandidate({
    required String sessionId,
    required WebRtcIceCandidate candidate,
  }) {
    return addRemoteIceCandidateUseCase(
      sessionId: sessionId,
      candidate: candidate,
    );
  }

  Future<void> addDataChannel({
    required String sessionId,
    required String label,
  }) {
    return addDataChannelUseCase(
      sessionId: sessionId,
      label: label,
    );
  }

  Future<void> removeDataChannel({
    required String sessionId,
    required String label,
  }) {
    return removeDataChannelUseCase(
      sessionId: sessionId,
      label: label,
    );
  }

  Future<void> sendData({
    required String sessionId,
    required String channelLabel,
    required String message,
  }) {
    return sendWebRtcDataUseCase(
      sessionId: sessionId,
      channelLabel: channelLabel,
      message: message,
    );
  }

  Future<WebRtcIceRoute> refreshIceRoute(String sessionId) {
    return sessionManager.getOrCreate(sessionId).refreshIceRoute();
  }

  Future<void> close(String sessionId) async {
    infoLog('WebRTC close requested. sessionId=$sessionId');
    _closingSessions.add(sessionId);

    try {
      await _connectionSubs.remove(sessionId)?.cancel();

      await closeWebRtcUseCase(sessionId: sessionId);

      _emitState(
        sessionId,
        stateOf(sessionId).copyWith(
          status: WebRtcStatus.closed,
          message: 'WebRTC closed.',
          clearError: true,
        ),
      );

      await sessionManager.closeSession(sessionId);
      _states.remove(sessionId);
      _pushAllStates();
    } finally {
      _closingSessions.remove(sessionId);
    }
  }

  Future<void> dispose() async {
    for (final sub in _connectionSubs.values) {
      await sub.cancel();
    }
    _connectionSubs.clear();

    await onlineAwareness.stopMonitoring();
    await sessionManager.closeAll();
    _states.clear();

    await _stateController.close();
  }

  Future<void> _bindObservers(String sessionId) async {
    await _connectionSubs.remove(sessionId)?.cancel();

    _connectionSubs[sessionId] = connectionStateUseCase(sessionId: sessionId).listen((
      connectionState,
    ) {
      if (_closingSessions.contains(sessionId)) return;

      switch (connectionState) {
        case WebRtcConnectionState.connected:
          _emitState(
            sessionId,
            stateOf(sessionId).copyWith(
              status: WebRtcStatus.connected,
              retryCount: 0,
              message: 'Connected.',
              clearError: true,
            ),
          );
          break;

        case WebRtcConnectionState.disconnected:
        case WebRtcConnectionState.failed:
          _emitState(
            sessionId,
            stateOf(sessionId).copyWith(
              status: WebRtcStatus.retrying,
              message: connectionState == WebRtcConnectionState.failed
                  ? 'Connection failed. Attempting recovery...'
                  : 'Connection lost. Attempting recovery...',
              clearError: true,
            ),
          );
          _triggerRecovery(sessionId: sessionId);
          break;

        case WebRtcConnectionState.closed:
          _emitState(
            sessionId,
            stateOf(sessionId).copyWith(status: WebRtcStatus.closed),
          );
          break;

        case WebRtcConnectionState.newState:
        case WebRtcConnectionState.connecting:
          break;
      }
    });

    await onlineAwareness.startMonitoring(
      onRecoveryNeeded: () => _handleInternetRecovery(sessionId),
      shouldAutoRecover: () => !_closingSessions.contains(sessionId),
    );
  }

  Future<void> _handleInternetRecovery(String sessionId) async {
    if (_closingSessions.contains(sessionId) || recoveryStrategy.isRecovering) {
      return;
    }

    _emitState(
      sessionId,
      stateOf(sessionId).copyWith(
        status: WebRtcStatus.retrying,
        message: 'Internet recovered. Attempting recovery...',
      ),
    );

    try {
      await _triggerRecovery(sessionId: sessionId);
    } catch (_) {}
  }

  Future<void> _triggerRecovery({required String sessionId}) async {
    if (_closingSessions.contains(sessionId) || recoveryStrategy.isRecovering) {
      return;
    }

    try {
      await recoveryStrategy.recover(sessionId: sessionId);
    } catch (error) {
      _emitState(
        sessionId,
        stateOf(sessionId).copyWith(
          status: WebRtcStatus.failed,
          error: _toAppError(error).message,
        ),
      );
      errorLog('Recovery failed. sessionId=$sessionId', error);
    }
  }

  void _emitState(String sessionId, WebRtcState next) {
    _states[sessionId] = next;
    _pushAllStates();
  }

  void _pushAllStates() {
    if (!_stateController.isClosed) {
      _stateController.add(Map.unmodifiable(_states));
    }
  }

  AppException _toAppError(Object error) {
    if (error is AppException) return error;
    if (error is StateError) {
      return ServerException(message: error.message);
    }
    return const UnknownAppException(
      message: 'WebRTC failed due to an unexpected error.',
    );
  }
}