import 'package:get_it/get_it.dart';
import 'package:scommconnector/features/webrtc/domain/usecases/connection_state_usecase.dart';
import 'package:scommconnector/features/webrtc/webrtc.dart';

Future<void> webrtcDI(GetIt sl) async {
  /// Core
  sl.registerLazySingleton<WebRtcPeerService>(
    WebRtcPeerService.new,
  );

  /// Repository
  sl.registerLazySingleton<WebRtcRepository>(
    () => WebRtcRepositoryImpl(peerService: sl()),
  );

  /// Use cases
  sl.registerLazySingleton(() => InitializeWebRtcUseCase(sl()));
  sl.registerLazySingleton(() => CreateWebRtcOfferUseCase(sl()));
  sl.registerLazySingleton(() => CreateWebRtcAnswerUseCase(sl()));
  sl.registerLazySingleton(() => SetRemoteAnswerUseCase(sl()));
  sl.registerLazySingleton(() => AddRemoteIceCandidateUseCase(sl()));
  sl.registerLazySingleton(() => AddDataChannelUseCase(sl()));
  sl.registerLazySingleton(() => RemoveDataChannelUseCase(sl()));
  sl.registerLazySingleton(() => SendWebRtcDataUseCase(sl()));
  sl.registerLazySingleton(() => ConnectionStateUseCase(sl()));
  sl.registerLazySingleton(() => CloseWebRtcUseCase(sl()));
  sl.registerLazySingleton(() => RestartIceAndCreateOfferUseCase(sl()));

  /// Domain services
  sl.registerLazySingleton<IConnectionRecoveryStrategy>(
    () => ConnectionRecoveryStrategy(
      restartIceAndCreateOfferUseCase: sl(),
      closeWebRtcUseCase: sl(),
    ),
  );

  /// Controller
  sl.registerLazySingleton<WebRtcController>(
    () => WebRtcController(
      repository: sl(),
      initializeWebRtcUseCase: sl(),
      createWebRtcOfferUseCase: sl(),
      createWebRtcAnswerUseCase: sl(),
      setRemoteAnswerUseCase: sl(),
      addRemoteIceCandidateUseCase: sl(),
      addDataChannelUseCase: sl(),
      removeDataChannelUseCase: sl(),
      sendWebRtcDataUseCase: sl(),
      closeWebRtcUseCase: sl(),
      connectionStateUseCase: sl(),
      recoveryStrategy: sl(),
      onlineAwareness: sl(),
    ),
  );
}