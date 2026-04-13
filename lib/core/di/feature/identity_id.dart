import 'package:get_it/get_it.dart';
import 'package:scommconnector/core/di/service_locator.dart';
import 'package:scommconnector/features/identity/domain/usecases/add_allow_devices_usecase.dart';
import 'package:scommconnector/features/identity/domain/usecases/list_allow_devices_usecase.dart';
import 'package:scommconnector/features/identity/domain/usecases/remove_allow_devices_usecase.dart';
import 'package:scommconnector/features/identity/domain/usecases/update_allow_devices_usecase.dart';
import 'package:scommconnector/features/identity/identity.dart';

Future<void> identityDI(
  GetIt sl,
  String host,
  int port,
  bool useTls,
) async {
  /// State
  sl.registerLazySingleton<AuthSessionState>(AuthSessionState.new);

  /// gRPC
  sl.registerLazySingleton<IdentityServiceGrpcClientImpl>(
    () => IdentityServiceGrpcClientImpl(
      host: host,
      port: port,
      useTls: useTls,
      accessTokenProvider: () async => sl<AuthSessionState>().tokenOrNull,
    ),
  );

  /// Remote
  sl.registerLazySingleton<IdentityRemoteDataSource>(
    () => IdentityRemoteDataSourceImpl(
      grpcClient: sl<IdentityServiceGrpcClientImpl>(),
    ),
  );

  /// Local
  sl.registerLazySingleton<IdentityLocalDataSource>(
    () => IdentityLocalDataSourceImpl(secureStorage: sl()),
  );

  /// Repository
  sl.registerLazySingleton<IdentityRepository>(
    () => IdentityRepositoryImpl(
      remoteDataSource: sl<IdentityRemoteDataSource>(),
      localDataSource: sl<IdentityLocalDataSource>(),
    ),
  );

  /// Controller
  sl.registerLazySingleton<IdentityController>(
    () => IdentityController(
      registerDeviceUseCase: RegisterDeviceUseCase(sl<IdentityRepository>()),
      updateDeviceUseCase: UpdateDeviceUseCase(sl<IdentityRepository>()),
      deleteDeviceUseCase: DeleteDeviceUseCase(sl<IdentityRepository>()),
      listMyDevicesUseCase: ListMyDevicesUseCase(sl<IdentityRepository>()),
      registerServiceUseCase: RegisterServiceUseCase(sl<IdentityRepository>()),
      listDeviceServicesUseCase: ListDeviceServicesUseCase(sl<IdentityRepository>()),
      updateServiceUseCase: UpdateServiceUseCase(sl<IdentityRepository>()),
      deleteServiceUseCase: DeleteServiceUseCase(sl<IdentityRepository>()),

      listAllowUserDevicesUseCase: ListAllowUserDevicesUsecase(sl<IdentityRepository>()),
      updateAllowUserDeviceUseCase: UpdateAllowUserDeviceUsecase(sl<IdentityRepository>()),
      addAllowUserDeviceUseCase: AddAllowUserDeviceUsecase(sl<IdentityRepository>()),
      removeAllowUserDeviceUseCase: RemoveAllowUserDeviceUsecase(sl<IdentityRepository>()),
    ),
  );
}