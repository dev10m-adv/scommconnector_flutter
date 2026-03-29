import 'package:get_it/get_it.dart';
import 'package:scommconnector/core/di/service_locator.dart';
import 'package:scommconnector/core/resilience/online_aware_resilience.dart';
import 'package:scommconnector/features/signaling/signaling.dart';

Future<void> signalingDI(
  GetIt sl,
  String host,
  int port,
  bool useTls,
) async {
  /// gRPC
  sl.registerLazySingleton<SignalingServiceGrpcClient>(
    () => SignalingServiceGrpcClientImpl(
      host: host,
      port: port,
      useTls: useTls,
      accessTokenProvider: () async => sl<AuthSessionState>().tokenOrNull,
    ),
  );

  /// Repository
  sl.registerLazySingleton<SignalingRepository>(
    () => SignalingRepositoryImpl(
      grpcClient: sl(),
    ),
  );

  /// Use cases
  sl.registerLazySingleton(() => ConnectSignalingUseCase(sl()));
  sl.registerLazySingleton(() => DisconnectSignalingUseCase(sl()));
  sl.registerLazySingleton(() => SendSignalEnvelopeUseCase(sl()));
  sl.registerLazySingleton(() => WatchPresenceUseCase(sl()));

  /// Core shared services
  sl.registerLazySingleton<IOnlineAwareResilience>(
    OnlineAwareResilience.new,
  );

  /// Domain services
  sl.registerLazySingleton<ISignalingErrorClassifier>(
    SignalingErrorClassifier.new,
  );

  sl.registerLazySingleton<IRequestMatcher>(RequestMatcher.new);

  sl.registerLazySingleton<IConnectionHealthMonitor>(
    ConnectionHealthMonitor.new,
  );

  /// Controller
  sl.registerLazySingleton<SignalingController>(
    () => SignalingController(
      connectSignalingUseCase: sl(),
      disconnectSignalingUseCase: sl(),
      sendSignalEnvelopeUseCase: sl(),
      watchPresenceUseCase: sl(),
      healthMonitor: sl(),
      errorClassifier: sl(),
      onlineAwareness: sl(),
      requestMatcher: sl(),
    ),
  );
}