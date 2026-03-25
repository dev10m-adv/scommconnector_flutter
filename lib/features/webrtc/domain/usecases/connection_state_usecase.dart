import 'package:scommconnector/features/webrtc/domain/entities/webrtc_connection_state.dart';

import '../repositories/webrtc_repository.dart';

class ConnectionStateUseCase {
  final WebRtcRepository repository;
  const ConnectionStateUseCase(this.repository);
  Stream<WebRtcConnectionState> call() => repository.connectionStates;
}
