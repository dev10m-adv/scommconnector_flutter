import 'package:get_it/get_it.dart';
import 'package:scommconnector/features/auth/auth.dart';

Future<void> authDI(
  GetIt sl,
  String gRPCHost,
  int gRPCPort,
  bool useTls,
) async {
  /// gRPC
  sl.registerLazySingleton<AuthServiceGrpcClientImpl>(
    () => AuthServiceGrpcClientImpl(
      host: gRPCHost,
      port: gRPCPort,
      useTls: useTls,
    ),
  );

  // Bind interface to implementation for downstream constructors typed
  // against AuthServiceGrpcClient.
  sl.registerLazySingleton<AuthServiceGrpcClient>(
    () => sl<AuthServiceGrpcClientImpl>(),
  );

  /// Remote
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(grpcClient: sl()),
  );

  /// Local
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl()),
  );

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  /// Use cases
  sl.registerLazySingleton(() => ExchangeExternalTokenUseCase(sl()));
  sl.registerLazySingleton(() => ExchangeImapCredentialsUseCase(sl()));
  sl.registerLazySingleton(() => GetAccessTokenUseCase(sl()));
  sl.registerLazySingleton(() => RefreshAccessTokenUseCase(sl()));
}