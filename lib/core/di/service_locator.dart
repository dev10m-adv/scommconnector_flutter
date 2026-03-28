import 'package:get_it/get_it.dart';
import 'package:scommconnector/core/config/webrtc_config.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/connection_state_usecase.dart';
import '../../core/resilience/online_aware_resilience.dart';
import '../../features/identity/identity.dart';
import '../../features/connect/connect_controller.dart';
import '../../features/signaling/signaling.dart';
import '../../features/webrtc/webrtc.dart';

final getIt = GetIt.instance;

class TestSessionState {
  String _accessToken = '';

  String get accessToken => _accessToken;
  String? get tokenOrNull =>
      _accessToken.trim().isEmpty ? null : _accessToken.trim();

  void setAccessToken(String token) {
    _accessToken = token;
  }
}

Future<void> setupDependencies({
  String host = ScommConfig.grocHost,
  int port = ScommConfig.grocPort,
  bool useTls = false,
}) async {
  if (getIt.isRegistered<TestSessionState>()) {
    return;
  }

  getIt.registerLazySingleton<TestSessionState>(TestSessionState.new);

  getIt.registerLazySingleton<IdentityServiceGrpcClient>(
    () => IdentityServiceGrpcClientImpl(
      host: host,
      port: port,
      useTls: useTls,
      accessTokenProvider: () async => getIt<TestSessionState>().tokenOrNull,
    ),
  );

  getIt.registerLazySingleton<IdentityRemoteDataSource>(
    () => IdentityRemoteDataSourceImpl(
      grpcClient: getIt<IdentityServiceGrpcClient>(),
    ),
  );

  getIt.registerLazySingleton<IdentityLocalDataSource>(
    IdentityLocalDataSourceImpl.new,
  );

  getIt.registerLazySingleton<IdentityRepository>(
    () => IdentityRepositoryImpl(
      remoteDataSource: getIt<IdentityRemoteDataSource>(),
      localDataSource: getIt<IdentityLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<IdentityController>(
    () => IdentityController(
      registerDeviceUseCase: RegisterDeviceUseCase(getIt<IdentityRepository>()),
      updateDeviceUseCase: UpdateDeviceUseCase(getIt<IdentityRepository>()),
      deleteDeviceUseCase: DeleteDeviceUseCase(getIt<IdentityRepository>()),
      listMyDevicesUseCase: ListMyDevicesUseCase(getIt<IdentityRepository>()),
      listUserDevicesUseCase: ListUserDevicesUseCase(
        getIt<IdentityRepository>(),
      ),
      registerServiceUseCase: RegisterServiceUseCase(
        getIt<IdentityRepository>(),
      ),
      listDeviceServicesUseCase: ListDeviceServicesUseCase(
        getIt<IdentityRepository>(),
      ),
      updateServiceUseCase: UpdateServiceUseCase(getIt<IdentityRepository>()),
      deleteServiceUseCase: DeleteServiceUseCase(getIt<IdentityRepository>()),
    ),
  );

  getIt.registerLazySingleton<SignalingServiceGrpcClient>(
    () => SignalingServiceGrpcClientImpl(
      host: host,
      port: port,
      useTls: useTls,
      accessTokenProvider: () async => getIt<TestSessionState>().tokenOrNull,
    ),
  );

  getIt.registerLazySingleton<SignalingRepository>(
    () => SignalingRepositoryImpl(
      grpcClient: getIt<SignalingServiceGrpcClient>(),
    ),
  );

  // Signaling use cases
  getIt.registerLazySingleton<ConnectSignalingUseCase>(
    () => ConnectSignalingUseCase(getIt<SignalingRepository>()),
  );

  getIt.registerLazySingleton<DisconnectSignalingUseCase>(
    () => DisconnectSignalingUseCase(getIt<SignalingRepository>()),
  );

  getIt.registerLazySingleton<SendSignalEnvelopeUseCase>(
    () => SendSignalEnvelopeUseCase(getIt<SignalingRepository>()),
  );

  getIt.registerLazySingleton<WatchPresenceUseCase>(
    () => WatchPresenceUseCase(getIt<SignalingRepository>()),
  );

  // Core resilience services (shared)
  getIt.registerLazySingleton<IOnlineAwareResilience>(
    OnlineAwareResilience.new,
  );

  // Signaling domain services
  getIt.registerLazySingleton<ISignalingErrorClassifier>(
    SignalingErrorClassifier.new,
  );

  getIt.registerLazySingleton<IRequestMatcher>(RequestMatcher.new);

  getIt.registerLazySingleton<IConnectionHealthMonitor>(
    ConnectionHealthMonitor.new,
  );

  getIt.registerLazySingleton<SignalingController>(
    () => SignalingController(
      connectSignalingUseCase: getIt<ConnectSignalingUseCase>(),
      disconnectSignalingUseCase: getIt<DisconnectSignalingUseCase>(),
      sendSignalEnvelopeUseCase: getIt<SendSignalEnvelopeUseCase>(),
      watchPresenceUseCase: getIt<WatchPresenceUseCase>(),
      healthMonitor: getIt<IConnectionHealthMonitor>(),
      errorClassifier: getIt<ISignalingErrorClassifier>(),
      onlineAwareness: getIt<IOnlineAwareResilience>(),
      requestMatcher: getIt<IRequestMatcher>(),
    ),
  );

  getIt.registerLazySingleton<WebRtcPeerService>(WebRtcPeerService.new);

  getIt.registerLazySingleton<WebRtcRepository>(
    () => WebRtcRepositoryImpl(peerService: getIt<WebRtcPeerService>()),
  );

  // WebRTC use cases
  getIt.registerLazySingleton<InitializeWebRtcUseCase>(
    () => InitializeWebRtcUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<CreateWebRtcOfferUseCase>(
    () => CreateWebRtcOfferUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<CreateWebRtcAnswerUseCase>(
    () => CreateWebRtcAnswerUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<SetRemoteAnswerUseCase>(
    () => SetRemoteAnswerUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<AddRemoteIceCandidateUseCase>(
    () => AddRemoteIceCandidateUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<AddDataChannelUseCase>(
    () => AddDataChannelUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<RemoveDataChannelUseCase>(
    () => RemoveDataChannelUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<SendWebRtcDataUseCase>(
    () => SendWebRtcDataUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<ConnectionStateUseCase>(
    () => ConnectionStateUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<CloseWebRtcUseCase>(
    () => CloseWebRtcUseCase(getIt<WebRtcRepository>()),
  );

  getIt.registerLazySingleton<RestartIceAndCreateOfferUseCase>(
    () => RestartIceAndCreateOfferUseCase(getIt<WebRtcRepository>()),
  );

  // WebRTC domain services
  getIt.registerLazySingleton<IConnectionRecoveryStrategy>(
    () => ConnectionRecoveryStrategy(
      restartIceAndCreateOfferUseCase: getIt<RestartIceAndCreateOfferUseCase>(),
      closeWebRtcUseCase: getIt<CloseWebRtcUseCase>(),
    ),
  );


  getIt.registerLazySingleton<WebRtcController>(
    () => WebRtcController(
      repository: getIt<WebRtcRepository>(),
      initializeWebRtcUseCase: getIt<InitializeWebRtcUseCase>(),
      createWebRtcOfferUseCase: getIt<CreateWebRtcOfferUseCase>(),
      createWebRtcAnswerUseCase: getIt<CreateWebRtcAnswerUseCase>(),
      setRemoteAnswerUseCase: getIt<SetRemoteAnswerUseCase>(),
      addRemoteIceCandidateUseCase: getIt<AddRemoteIceCandidateUseCase>(),
      addDataChannelUseCase: getIt<AddDataChannelUseCase>(),
      removeDataChannelUseCase: getIt<RemoveDataChannelUseCase>(),
      sendWebRtcDataUseCase: getIt<SendWebRtcDataUseCase>(),
      closeWebRtcUseCase: getIt<CloseWebRtcUseCase>(),

      connectionStateUseCase: getIt<ConnectionStateUseCase>(),

      recoveryStrategy: getIt<IConnectionRecoveryStrategy>(),
      onlineAwareness: getIt<IOnlineAwareResilience>(),
    ),
  );

  getIt.registerLazySingleton<ConnectController>(
    () => ConnectController(
      signalingController: getIt<SignalingController>(),
      webRtcController: getIt<WebRtcController>(),
    ),
  );
}
