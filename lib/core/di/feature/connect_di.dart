import 'package:get_it/get_it.dart';
import 'package:scommconnector/features/connect/connect_controller.dart';
import 'package:scommconnector/features/connect/connect_session_store.dart';

Future<void> connectDI(GetIt sl) async {
  sl.registerLazySingleton<ConnectSessionStore>(() => ConnectSessionStore());

  sl.registerLazySingleton<ConnectController>(
    () => ConnectController(
      sessionStore: sl(),
      signalingController: sl(),
      webRtcController: sl(),
    ),
  );
}