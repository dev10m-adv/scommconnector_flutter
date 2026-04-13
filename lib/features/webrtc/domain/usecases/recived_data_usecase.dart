import 'package:scommconnector/features/webrtc/application/webrtc_manager.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_data_message.dart';

class RecivedDataUsecase {
  final WebRtcSessionManager manager;

  const RecivedDataUsecase(this.manager);

  Stream<WebRtcDataMessage> call({required String sessionId}) {
    final repository = manager.getOrCreate(sessionId);
    return repository.dataMessages;
  }
}
