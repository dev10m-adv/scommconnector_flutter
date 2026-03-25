import 'package:scommconnector/features/webrtc/domain/entities/webrtc_data_message.dart';
import '../repositories/webrtc_repository.dart';

class RecivedDataUsecase {
  final WebRtcRepository repository;

  const RecivedDataUsecase(this.repository);

  Stream<WebRtcDataMessage> call() => repository.dataMessages;
}
