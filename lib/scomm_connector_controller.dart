import 'dart:async';
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

  ScommConnectorController._internal() {
    _datachannelController = ScommDatachannelController(
      transport: ScommDataChannelTransport(
        sendRawMessage: _webrtccontroller.sendData,
        isConnected: _canSendDataChannel,
      ),
    );
    _authStateSubscription = _authController.authStates.listen((_) {
      if (!_stateChangesController.isClosed) {
        _stateChangesController.add(null);
      }
    });
  }

  final _webrtccontroller = scommDi<WebRtcController>();
  final _connectController = scommDi<ConnectController>();
  final _identityController = scommDi<IdentityController>();
  final _authController = scommDi<ScommAuthController>();
  final _stateChangesController = StreamController<void>.broadcast();
  late ScommDatachannelController _datachannelController;
  StreamSubscription<WebRtcDataMessage>? _dataMessageSubscription;
  StreamSubscription<AuthState>? _authStateSubscription;
  final _incomingRequestCache = <String, SignalEnvelope>{};


  ///// Exposed state and streams for consumers.
  ScommSessionState _sessionState = ScommSessionState.initial();
  final _sessionStateController = StreamController<ScommSessionState>.broadcast();

  ScommSessionState get sessionState => _sessionState;
  Stream<ScommSessionState> get stream => _sessionStateController.stream;

  // Snapshot states for consumers that need synchronous reads.
  
  IdentityState get identityState => _identityController.state;
  WebRtcState get webrtcState => _webrtccontroller.state;
  SignalingState get signalingState =>
      _connectController.signalingController.state;
  Stream<void> get stateChanges => _stateChangesController.stream;

  bool _canSendDataChannel() {
    final status = _webrtccontroller.state.status;
    return status == WebRtcStatus.connected ||
        status == WebRtcStatus.negotiating ||
        status == WebRtcStatus.retrying;
  }


  void _emitSession(ScommSessionState next) {
    _sessionState = next;
    _sessionStateController.add(next);
  }

  void _syncSessionState() {
    print('Syncing session state...');
    final auth = _authController.state;
    final identity = _identityController.state;
    final signaling = _connectController.signalingController.state;
    final webrtc = _webrtccontroller.state;

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

    _authSub = _authController.authStates.listen((_) => _syncSessionState());
    _identitySub = _identityController.identityStates.listen((_) => _syncSessionState());
    _signalingSub = _connectController.signalingController.signalingStates.listen((_) => _syncSessionState());
    _webrtcSub = _webrtccontroller.webRtcStates.listen((_) => _syncSessionState());

    _syncSessionState();
  }

  Future<void> login(ScommLoginConfig config) async {
    if (config is ScommTokenExchangeLoginConfig) {
      print(
        'Starting token exchange authentication for user ${config.userId} with provider ${config.provider}',
      );
      await _authController.exchangeProviderToken(
        provider: config.provider,
        externalAccessToken: config.externalAccessToken,
        userId: config.userId,
      );
    } else if (config is ScommImapLoginConfig) {
      await _authController.exchangeImapLogin(
        credentials: ImapCredentials(
          username: config.email,
          password: config.password,
          host: config.host,
          port: config.port,
          userId: config.email,
        ),
      );
    }
  }

  Future<void> logout() => _authController.logout();

  Future<void> refreshAccessToken({
    required String refreshToken,
    required String userId,
  }) {
    return _authController.refreshAccessToken(
      refreshToken: refreshToken,
      userId: userId,
    );
  }

  ////////// Identity methods //////////
  Future<void> registerDevice(
    String deviceName,
    String deviceType,
    DeviceMode mode,
  ) async {
    print('Registering device with name="$deviceName", type="$deviceType", mode="$mode"');
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

  Future<List<IdentityDevice>> listUserDevices(String userId) =>
      _identityController.listUserDevices(userId: userId);

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
    print(
      'ScommConnector : start with deviceId=${config.deviceId}, serverAddress=${config.serverAddress}, iceServers=${config.iceServers}',
    );
    final localUri = 'scomm:${config.userId}/${config.deviceId}';
    await _connectController.start(
      deviceId: config.deviceId,
      localUri: localUri,
      dataChannels: const [ScommDataChannelTransport.mainChannel],
      iceServers: config.iceServers,
    );

    _dataMessageSubscription ??= _webrtccontroller.receivedDataMessages.listen((
      message,
    ) {
      if (message.channelLabel != ScommDataChannelTransport.mainChannel) {
        return;
      }
      _datachannelController.receiveRawMessage(message.message);
    });
  }

  Future<void> stop() async {
    _incomingRequestCache.clear();
    await _connectController.stop();
  }

  Future<void> dispose() async {
    await _authSub?.cancel();
    await _identitySub?.cancel();
    await _signalingSub?.cancel();
    await _webrtcSub?.cancel();
    await _authStateSubscription?.cancel();
    await _dataMessageSubscription?.cancel();
    _dataMessageSubscription = null;
    await _stateChangesController.close();
    await _datachannelController.dispose();
    await _sessionStateController.close();
    await stop();
  }

  Future<void> restart(ScommStartConfig config) async {
    await stop();
    await start(config);
  }

  Stream<WebRtcConnectionState> get scommConnectionState =>
      _webrtccontroller.connectionStates;

  Stream<WebRtcIceCandidate> get localIceCandidates =>
      _webrtccontroller.localIceCandidates;

  Stream<WebRtcDataMessage> get webrtcDataMessages =>
      _webrtccontroller.receivedDataMessages;

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
    await _webrtccontroller.sendData(
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
    return _datachannelController.sendResponse(
      requestId: requestId,
      service: service,
      action: action,
      data: data,
    );
  }

  Future<void> sendDatachannelStream({
    required String requestId,
    required String service,
    required String action,
    required Map<String, dynamic> data,
  }) {
    return _datachannelController.sendStream(
      requestId: requestId,
      service: service,
      action: action,
      data: data,
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
  Stream<bool> get isDataChannelOpen => _webrtccontroller.connectionStates
      .map((state) => state == WebRtcConnectionState.connected)
      .distinct();

  Future<void> acceptConnectionRequest(String requestId) async {
    final request = _incomingRequestCache.remove(requestId);
    if (request == null) {
      throw StateError('Unknown requestId: $requestId');
    }

    await _connectController.acceptIncomingRequest(
      requestEnvelope: request,
      accept: true,
    );
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
    return _webrtccontroller.setRemoteAnswer(answer);
  }

  Future<void> addRemoteIceCandidate(WebRtcIceCandidate candidate) {
    return _webrtccontroller.addRemoteIceCandidate(candidate);
  }

  Future<void> addDataChannel(String label) {
    return _webrtccontroller.addDataChannel(label);
  }

  Future<void> removeDataChannel(String label) {
    return _webrtccontroller.removeDataChannel(label);
  }

  bool _isOnlineStatus(String status) {
    final normalized = status.trim().toUpperCase();
    return normalized == 'ONLINE' || normalized == 'AVAILABLE';
  }
}
