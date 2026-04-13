import 'dart:async';
import 'dart:convert';
import 'package:scommconnector/features/auth/auth.dart';
import 'package:scommconnector/features/identity/identity.dart';
import 'package:scommconnector/features/scomm_session_state.dart';
import 'package:scommconnector/features/signaling/signaling.dart';
import 'package:scommconnector/features/webrtc/webrtc.dart';
import 'package:scommconnector/core/di/service_locator.dart';
import 'package:scommconnector/features/connect/connect_controller.dart';
import 'package:scommconnector/features/connect/datachannel/scomm_datachannel_controller.dart';
import 'package:scommconnector/features/connect/datachannel/scomm_datachannel_protocol.dart';
import 'package:scommconnector/features/connect/datachannel/scomm_datachannel_transport.dart';
import 'package:scommconnector/features/connect/datachannel/scomm_transfer_speed.dart';
import 'package:scommconnector/scomm_start_config.dart';

/////// Main public API surface of the ScommConnector package. This class is a singleton
/////// that provides high-level methods for authentication, identity management, connection handling, and data channel communication.
/////// It internally uses the various controllers and services defined in the package, and exposes a simplified interface for consumers.
/////// Consumers can listen to various streams for updates on connection state, incoming messages, presence events, etc., and can send messages or connection requests using the provided methods.

class ScommConnectorController {
  static final ScommConnectorController _instance =
      ScommConnectorController._internal();
  factory ScommConnectorController() => _instance;

  StreamSubscription? _authSub;
  StreamSubscription? _identitySub;
  StreamSubscription? _signalingSub;
  StreamSubscription? _webrtcSub;
  StreamSubscription<WebRtcIceRoute>? _iceRouteSubscription;

  ScommConnectorController._internal() {
    _datachannelController = ScommDatachannelController(
      transport: ScommDataChannelTransport(
        sendRawMessage: _sendTrackedRawMessage,
        isConnected: _canSendDataChannel,
      ),
    );
    _authStateSubscription = _authController.authStates.listen((_) {
      if (!_stateChangesController.isClosed) {
        _stateChangesController.add(null);
      }
    });
    _startTransferSpeedTicker();
  }

  final _webrtccontroller = scommDi<WebRtcController>();
  final _connectController = scommDi<ConnectController>();
  final _identityController = scommDi<IdentityController>();
  final _authController = scommDi<ScommAuthController>();
  final _stateChangesController = StreamController<void>.broadcast();
  late ScommDatachannelController _datachannelController;
  final _dataMessageSubscriptions =
      <String, StreamSubscription<WebRtcDataMessage>>{};
  final _requestSessionByRequestId = <String, String>{};
  StreamSubscription<AuthState>? _authStateSubscription;
  final _incomingRequestCache = <String, SignalEnvelope>{};
  Timer? _transferSpeedTimer;
  int _sentBytesSinceLastTick = 0;
  int _receivedBytesSinceLastTick = 0;
  ScommTransferSpeed _transferSpeed = const ScommTransferSpeed();
  WebRtcIceRoute _iceRoute = const WebRtcIceRoute();
  final _transferSpeedController =
      StreamController<ScommTransferSpeed>.broadcast();
  final _iceRouteController = StreamController<WebRtcIceRoute>.broadcast();

  ///// Exposed state and streams for consumers.
  ScommSessionState _sessionState = ScommSessionState.initial();
  final _sessionStateController =
      StreamController<ScommSessionState>.broadcast();

  ScommSessionState get sessionState => _sessionState;
  Stream<ScommSessionState> get stream => _sessionStateController.stream;
  ScommTransferSpeed get transferSpeed => _transferSpeed;
  Stream<ScommTransferSpeed> get transferSpeeds =>
      _transferSpeedController.stream;
  WebRtcIceRoute get iceRoute => _iceRoute;
  Stream<WebRtcIceRoute> get iceRoutes => _iceRouteController.stream;

  // Snapshot states for consumers that need synchronous reads.

  IdentityState get identityState => _identityController.state;
  WebRtcState get webrtcState {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) return const WebRtcState();
    return _webrtccontroller.stateOf(sessionId);
  }

  SignalingState get signalingState =>
      _connectController.signalingController.state;
  Stream<void> get stateChanges => _stateChangesController.stream;

  bool _canSendDataChannel() {
    final status = webrtcState.status;
    return status == WebRtcStatus.connected ||
        status == WebRtcStatus.negotiating ||
        status == WebRtcStatus.retrying;
  }

  void _emitSession(ScommSessionState next) {
    print('Emitting new session state: $next');
    _sessionState = next;
    _sessionStateController.add(next);
  }

  void _syncSessionState() {
    final auth = _authController.state;
    final identity = _identityController.state;
    final signaling = _connectController.signalingController.state;
    final webrtc = webrtcState;

    _emitSession(
      ScommSessionState(
        isAuthenticated: auth.isLoggedIn,
        isDeviceRegistered: identity.isRegistered,
        authState: auth,
        identityState: identity,
        signalingState: signaling,
        webRtcState: webrtc,
      ),
    );
  }

  ///////// Authentication methods ///////////

  Future<void> initialize() async {
    await _authController.init();

    await _authSub?.cancel();
    await _identitySub?.cancel();
    await _signalingSub?.cancel();
    await _webrtcSub?.cancel();
    await _iceRouteSubscription?.cancel();

    _authSub = _authController.authStates.listen((_) => _syncSessionState());
    _identitySub = _identityController.identityStates.listen(
      (_) => _syncSessionState(),
    );
    _signalingSub = _connectController.signalingController.signalingStates
        .listen((_) => _syncSessionState());
    _webrtcSub = _webrtccontroller.webRtcStates.listen(
      (_) => _syncSessionState(),
    );

    _syncSessionState();
  }

  Future<void> login(ScommLoginConfig config) async {
    if (config is ScommTokenExchangeLoginConfig) {
      print(
        'Starting token exchange authentication for user ${config.email} with provider ${config.provider}',
      );
      await _authController.exchangeProviderToken(
        provider: config.provider,
        externalAccessToken: config.externalAccessToken,
        email: config.email,
      );
    } else if (config is ScommImapLoginConfig) {
      await _authController.exchangeImapLogin(
        credentials: ImapCredentials(
          username: config.email,
          password: config.password,
          host: config.host,
          port: config.port,
          useTls: config.useTls,
        ),
      );
    }
  }

  Future<void> logout() => _authController.logout();

  Future<void> refreshAccessToken({
    required String refreshToken,
    required String email,
  }) {
    return _authController.refreshAccessToken(
      refreshToken: refreshToken,
      email: email,
    );
  }

  ////////// Identity methods //////////
  Future<void> registerDevice(
    String deviceName,
    String deviceType,
    DeviceMode mode,
  ) async {
    print(
      'Registering device with name="$deviceName", type="$deviceType", mode="$mode"',
    );
    await _identityController.registerDevice(
      deviceName: deviceName,
      deviceType: deviceType,
      mode: mode,
    );
  }

  Future<void> registerService(String deviceId, String serviceName) async {
    await _identityController.registerService(
      deviceId: deviceId,
      serviceName: serviceName,
    );
  }

  Future<List<IdentityDevice>> listAllowlistedDevices(String myDeviceId) =>
      _identityController.listAllowUserDevices(deviceId: myDeviceId);

  Future<SavedDeviceIdentity?> loadMyCurrentDeviceIdentity(String userId) =>
      _identityController.loadSavedDeviceIdentity(userId);

  Future<List<IdentityDevice>> listMyDevices() =>
      _identityController.listMyDevices();

  Future<void> deleteDevice(String deviceId) =>
      _identityController.deleteDevice(deviceId: deviceId);

  Future<void> deleteService(String serviceId) =>
      _identityController.deleteService(serviceId: serviceId);

  Future<List<DeviceService>> listDeviceServices(String deviceId) =>
      _identityController.listDeviceServices(deviceId: deviceId);

  Future<void> updateService({
    required String serviceId,
    required String serviceName,
  }) {
    return _identityController.updateService(
      serviceId: serviceId,
      serviceName: serviceName,
    );
  }

  Future<void> addAllowUserDevice({
    required String userId,
    required String deviceId,
    required String state,
  }) {
    return _identityController.addAllowUserDevice(
      userId: userId,
      deviceId: deviceId,
      state: state,
    );
  }

  Future<void> removeAllowUserDevice({
    required String userId,
    required String deviceId,
  }) {
    return _identityController.removeAllowUserDevice(
      userId: userId,
      deviceId: deviceId,
    );
  }

  Future<void> updateAllowUserDevice({
    required String userId,
    required String deviceId,
    required String state,
  }) {
    return _identityController.updateAllowUserDevice(
      userId: userId,
      deviceId: deviceId,
      state: state,
    );
  }

  Future<void> updateDevice({
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required DeviceMode mode,
  }) => _identityController.updateDevice(
    deviceId: deviceId,
    mode: mode,
    deviceName: deviceName,
    deviceType: deviceType,
  );

  // Backward-compatible aliases used by runner code.
  Future<void> registerDevices(
    String deviceName,
    String deviceType,
    DeviceMode mode,
  ) => registerDevice(deviceName, deviceType, mode);

  Future<SavedDeviceIdentity?> loadMyDevices(String userId) =>
      loadMyCurrentDeviceIdentity(userId);

  ///// Connection and DataChannel methods //////////
  Future<void> start(ScommStartConfig config) async {
    final localUri = 'scomm:${config.email}/${config.deviceId}';

    await _connectController.start(
      deviceId: config.deviceId,
      localUri: localUri,
      dataChannels: const [ScommDataChannelTransport.mainChannel],
      iceServers: config.iceServers,
    );

    for (final sub in _dataMessageSubscriptions.values) {
      await sub.cancel();
    }
    _dataMessageSubscriptions.clear();
    _requestSessionByRequestId.clear();
  }

  Future<void> bindSelectedSessionStreams() async {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      for (final sub in _dataMessageSubscriptions.values) {
        await sub.cancel();
      }
      _dataMessageSubscriptions.clear();
      _requestSessionByRequestId.clear();
      // _boundDataSessionId = null;
      await _iceRouteSubscription?.cancel();
      _iceRouteSubscription = null;
      return;
    }

    final activeSessionIds = _connectController.sessionStore.sessionIds.toSet();

    final staleSubscriptions = _dataMessageSubscriptions.keys
        .where((id) => !activeSessionIds.contains(id))
        .toList(growable: false);
    for (final staleSessionId in staleSubscriptions) {
      await _dataMessageSubscriptions.remove(staleSessionId)?.cancel();
    }

    final staleRequestMappings = _requestSessionByRequestId.entries
        .where((entry) => !activeSessionIds.contains(entry.value))
        .map((entry) => entry.key)
        .toList(growable: false);
    for (final requestId in staleRequestMappings) {
      _requestSessionByRequestId.remove(requestId);
    }

    for (final activeSessionId in activeSessionIds) {
      if (_dataMessageSubscriptions.containsKey(activeSessionId)) {
        continue;
      }

      _dataMessageSubscriptions[activeSessionId] = _webrtccontroller
          .receivedDataMessages(activeSessionId)
          .listen((message) async {
            if (message.channelLabel != ScommDataChannelTransport.mainChannel) {
              return;
            }
            _recordReceivedPayload(message.message);
            final parsed = await _datachannelController.receiveRawMessage(
              message.message,
            );
            final requestId = parsed?.requestId?.trim();
            if (requestId != null && requestId.isNotEmpty) {
              _requestSessionByRequestId[requestId] = activeSessionId;
            }
          });
    }
    // _boundDataSessionId = sessionId;

    await _iceRouteSubscription?.cancel();
    _iceRouteSubscription = _webrtccontroller
        .iceRoutes(sessionId)
        .listen(_setIceRoute);
  }

  Future<void> stop() async {
    await stopWebRtc();
    await stopSignaling();
  }

  Future<void> stopSignaling() async {
    _incomingRequestCache.clear();
    await _connectController.stopSignaling();
  }

  Future<void> stopWebRtc() async {
    final sessionId = _connectController.selectedSession?.sessionId;
    if (sessionId != null) {
      await _connectController.stopWebRtcSession(sessionId);
      await _dataMessageSubscriptions.remove(sessionId)?.cancel();
      _requestSessionByRequestId.removeWhere(
        (_, mapped) => mapped == sessionId,
      );
      // _boundDataSessionId = null;
      await _iceRouteSubscription?.cancel();
      _iceRouteSubscription = null;
      _resetTransferSpeed();
      _setIceRoute(const WebRtcIceRoute());
    }
  }

  Future<void> dispose() async {
    await _authSub?.cancel();
    await _identitySub?.cancel();
    await _signalingSub?.cancel();
    await _webrtcSub?.cancel();
    await _iceRouteSubscription?.cancel();
    await _authStateSubscription?.cancel();
    for (final sub in _dataMessageSubscriptions.values) {
      await sub.cancel();
    }
    _dataMessageSubscriptions.clear();
    _requestSessionByRequestId.clear();
    _transferSpeedTimer?.cancel();
    await _transferSpeedController.close();
    await _iceRouteController.close();
    await _stateChangesController.close();
    await _datachannelController.dispose();
    await _sessionStateController.close();
    await stop();
  }

  Future<void> restart(ScommStartConfig config) async {
    await stop();
    await start(config);
  }

  Stream<WebRtcConnectionState> get scommConnectionState {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      return const Stream.empty();
    }
    return _webrtccontroller.connectionStates(sessionId);
  }

  Stream<WebRtcIceCandidate> get localIceCandidates {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      return const Stream.empty();
    }
    return _webrtccontroller.localIceCandidates(sessionId);
  }

  Stream<WebRtcDataMessage> get webrtcDataMessages {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      return const Stream.empty();
    }
    return _webrtccontroller.receivedDataMessages(sessionId);
  }

  Future<WebRtcIceRoute> refreshIceRoute() {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      return Future.value(const WebRtcIceRoute());
    }
    return _webrtccontroller.refreshIceRoute(sessionId);
  }

  Stream<SignalEnvelope> get scommConnectionIncomingRequests =>
      _connectController.incomingConnectionRequests.map((request) {
        final requestId = request.connectionRequest?.requestId;
        if (requestId != null && requestId.isNotEmpty) {
          _incomingRequestCache[requestId] = request;
        }
        return request;
      });

  Stream<SignalEnvelope> get incomingSignalingMessages =>
      _connectController.signalingController.incomingMessages;

  //// Stream reciving from DataChannel
  Stream<ScommRemoteMessage> get scommDataChannelMessages =>
      _datachannelController.messages;

  Future<void> sendMessageOverDataChannel(String message) async {
    await _sendTrackedRawMessage(
      channelLabel: ScommDataChannelTransport.mainChannel,
      message: message,
    );
  }

  Future<String> sendDatachannelRequest({
    required String service,
    required String action,
    required Map<String, dynamic> data,
    String? requestId,
  }) {
    return _datachannelController.sendRequest(
      service: service,
      action: action,
      data: data,
      requestId: requestId,
    );
  }

  Future<void> sendDatachannelResponse({
    required String requestId,
    required String service,
    required String action,
    required Map<String, dynamic> data,
  }) {
    return _sendRoutedDataChannelMessage(
      requestId: requestId,
      message: ScommRemoteMessage(
        type: ScommMessageType.response,
        requestId: requestId,
        service: service,
        action: action,
        data: data,
      ),
    );
  }

  Future<void> sendDatachannelStream({
    required String requestId,
    required String service,
    required String action,
    required Map<String, dynamic> data,
  }) {
    return _sendRoutedDataChannelMessage(
      requestId: requestId,
      message: ScommRemoteMessage(
        type: ScommMessageType.stream,
        requestId: requestId,
        service: service,
        action: action,
        data: data,
      ),
    );
  }

  Future<void> sendDatachannelEvent({
    required String service,
    required String action,
    required Map<String, dynamic> data,
  }) {
    return _datachannelController.sendEvent(
      service: service,
      action: action,
      data: data,
    );
  }

  Future<ScommRemoteMessage?> receiveRawDatachannelMessage(String rawMessage) {
    return _datachannelController.receiveRawMessage(rawMessage);
  }

  ///// Is DataChannel open
  Stream<bool> get isDataChannelOpen {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      return Stream<bool>.value(false);
    }

    return _webrtccontroller
        .connectionStates(sessionId)
        .map((state) => state == WebRtcConnectionState.connected)
        .distinct();
  }

  Future<void> acceptConnectionRequest(String requestId) async {
    final request = _incomingRequestCache.remove(requestId);
    if (request == null) {
      throw StateError('Unknown requestId: $requestId');
    }

    await _connectController.acceptIncomingRequest(
      requestEnvelope: request,
      accept: true,
    );

    await bindSelectedSessionStreams();
  }

  Future<void> rejectConnectionRequest(
    String requestId, {
    String reason = '',
  }) async {
    final request = _incomingRequestCache.remove(requestId);
    if (request == null) {
      throw StateError('Unknown requestId: $requestId');
    }

    await _connectController.acceptIncomingRequest(
      requestEnvelope: request,
      accept: false,
      reason: reason,
    );
  }

  Stream<SignalingPresenceEvent> get presebceEvents =>
      _connectController.signalingController.presenceEvents;

  Stream<SignalingPresenceEvent> get presenceEvents => presebceEvents;

  Future<void> watchPresence(List<String> targetUris) {
    return _connectController.signalingController.watchPresence(
      targetUris: targetUris,
    );
  }

  Stream<List<String>> get onlineDevicesStream async* {
    final statusByUri = <String, String>{};
    await for (final event in presenceEvents) {
      statusByUri[event.deviceUri] = event.status;
      yield statusByUri.entries
          .where((entry) => _isOnlineStatus(entry.value))
          .map((entry) => entry.key)
          .toList(growable: false);
    }
  }

  Future<void> sendConnectionRequest(String deviceId) async {
    await _connectController.initiateConnection(
      toUri: deviceId,
      serviceName: ScommDataChannelTransport.mainChannel,
    );

    await bindSelectedSessionStreams();
  }

  Future<void> sendConnectionRequestDetailed({
    required String toUri,
    required String serviceName,
    String note = '',
    Duration timeout = const Duration(seconds: 12),
  }) {
    return _connectController.initiateConnection(
      toUri: toUri,
      serviceName: serviceName,
      note: note,
      timeout: timeout,
    );
  }

  Future<void> setRemoteAnswer(WebRtcSessionDescription answer) {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      throw StateError('No active selected WebRTC session.');
    }
    return _webrtccontroller.setRemoteAnswer(
      sessionId: sessionId,
      answer: answer,
    );
  }

  Future<void> addRemoteIceCandidate(WebRtcIceCandidate candidate) {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      throw StateError('No active selected WebRTC session.');
    }
    return _webrtccontroller.addRemoteIceCandidate(
      sessionId: sessionId,
      candidate: candidate,
    );
  }

  Future<void> addDataChannel(String label) {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      throw StateError('No active selected WebRTC session.');
    }
    return _webrtccontroller.addDataChannel(sessionId: sessionId, label: label);
  }

  Future<void> removeDataChannel(String label) {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      throw StateError('No active selected WebRTC session.');
    }
    return _webrtccontroller.removeDataChannel(
      sessionId: sessionId,
      label: label,
    );
  }

  bool _isOnlineStatus(String status) {
    final normalized = status.trim().toUpperCase();
    return normalized == 'ONLINE' || normalized == 'AVAILABLE';
  }

  Future<void> _sendTrackedRawMessage({
    required String channelLabel,
    required String message,
  }) async {
    final sessionId = _connectController.selectedSessionId;
    if (sessionId == null) {
      throw StateError('No active selected WebRTC session.');
    }

    await bindSelectedSessionStreams();

    _recordSentPayload(message);
    await _webrtccontroller.sendData(
      sessionId: sessionId,
      channelLabel: channelLabel,
      message: message,
    );
  }

  Future<void> _sendRoutedDataChannelMessage({
    required String requestId,
    required ScommRemoteMessage message,
  }) async {
    final sessionId = _requestSessionByRequestId[requestId.trim()];
    if (sessionId == null || sessionId.isEmpty) {
      return _datachannelController.transport.send(message);
    }

    _recordSentPayload(message.encode());
    await _webrtccontroller.sendData(
      sessionId: sessionId,
      channelLabel: ScommDataChannelTransport.mainChannel,
      message: message.encode(),
    );
  }

  void _recordSentPayload(String message) {
    _sentBytesSinceLastTick += utf8.encode(message).length;
  }

  void _recordReceivedPayload(String message) {
    _receivedBytesSinceLastTick += utf8.encode(message).length;
  }

  void _startTransferSpeedTicker() {
    _transferSpeedTimer?.cancel();
    _transferSpeedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _transferSpeed = ScommTransferSpeed(
        sentBytesPerSecond: _sentBytesSinceLastTick,
        receivedBytesPerSecond: _receivedBytesSinceLastTick,
      );
      _sentBytesSinceLastTick = 0;
      _receivedBytesSinceLastTick = 0;

      if (!_transferSpeedController.isClosed) {
        _transferSpeedController.add(_transferSpeed);
      }
    });
  }

  void _resetTransferSpeed() {
    _sentBytesSinceLastTick = 0;
    _receivedBytesSinceLastTick = 0;
    _transferSpeed = const ScommTransferSpeed();
    if (!_transferSpeedController.isClosed) {
      _transferSpeedController.add(_transferSpeed);
    }
  }

  void _setIceRoute(WebRtcIceRoute next) {
    if (_iceRoute == next) {
      return;
    }
    _iceRoute = next;
    if (!_iceRouteController.isClosed) {
      _iceRouteController.add(next);
    }
    if (!_stateChangesController.isClosed) {
      _stateChangesController.add(null);
    }
  }
}
