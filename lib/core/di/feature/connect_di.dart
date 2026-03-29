import 'package:get_it/get_it.dart';
import 'package:scommconnector/features/connect/connect_controller.dart';

Future<void> connectDI(GetIt sl) async {
  sl.registerLazySingleton<ConnectController>(
    () => ConnectController(
      signalingController: sl(),
      webRtcController: sl(),
    ),
  );
}