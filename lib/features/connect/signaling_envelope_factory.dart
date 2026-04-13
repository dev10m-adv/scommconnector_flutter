// import '../signaling/domain/entities/signaling_entities.dart';
// import '../webrtc/domain/entities/webrtc_ice_candidate.dart';
// import '../webrtc/domain/entities/webrtc_session_description.dart';

// class SignalingEnvelopeFactory {
//   final String Function() messageIdBuilder;

//   const SignalingEnvelopeFactory({required this.messageIdBuilder});

//   SignalEnvelope buildConnectionResponse({
//     required String fromUri,
//     required String toUri,
//     required String requestId,
//     required bool accept,
//     String reason = '',
//   }) {
//     return SignalEnvelope(
//       messageId: messageIdBuilder(),
//       from: SignalingDeviceRef(uri: fromUri),
//       to: SignalingDeviceRef(uri: toUri),
//       connectionResponse: SignalingConnectionResponse(
//         requestId: requestId,
//         status: accept
//             ? SignalingConnectionResponseStatus.accepted
//             : SignalingConnectionResponseStatus.rejected,
//         reason: reason,
//       ),
//     );
//   }

//   SignalEnvelope buildOffer({
//     required String fromUri,
//     required String toUri,
//     required String requestId,
//     required WebRtcSessionDescription offer,
//   }) {
//     return SignalEnvelope(
//       messageId: messageIdBuilder(),
//       from: SignalingDeviceRef(uri: fromUri),
//       to: SignalingDeviceRef(uri: toUri),
//       offer: SignalingOffer(requestId: requestId, sdp: offer.sdp),
//     );
//   }

//   SignalEnvelope buildAnswer({
//     required String fromUri,
//     required String toUri,
//     required String requestId,
//     required WebRtcSessionDescription answer,
//   }) {
//     return SignalEnvelope(
//       messageId: messageIdBuilder(),
//       from: SignalingDeviceRef(uri: fromUri),
//       to: SignalingDeviceRef(uri: toUri),
//       answer: SignalingAnswer(requestId: requestId, sdp: answer.sdp),
//     );
//   }

//   SignalEnvelope buildIceCandidate({
//     required String fromUri,
//     required String toUri,
//     required String requestId,
//     required WebRtcIceCandidate candidate,
//   }) {
//     return SignalEnvelope(
//       messageId: messageIdBuilder(),
//       from: SignalingDeviceRef(uri: fromUri),
//       to: SignalingDeviceRef(uri: toUri),
//       iceCandidate: SignalingIceCandidate(
//         requestId: requestId,
//         candidate: candidate.candidate,
//         sdpMid: candidate.sdpMid ?? '',
//         sdpMLineIndex: candidate.sdpMLineIndex ?? 0,
//       ),
//     );
//   }
// }
