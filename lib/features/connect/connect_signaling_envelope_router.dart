// import '../signaling/domain/entities/signaling_entities.dart';

// typedef ConnectEnvelopeHandler = Future<void> Function(SignalEnvelope envelope);

// class ConnectSignalingEnvelopeHandlers {
//   final ConnectEnvelopeHandler onConnectionRequest;
//   final ConnectEnvelopeHandler onOffer;
//   final ConnectEnvelopeHandler onAnswer;
//   final ConnectEnvelopeHandler onIceCandidate;
//   final ConnectEnvelopeHandler onConnectionResponse;
//   final ConnectEnvelopeHandler onPing;
//   final ConnectEnvelopeHandler onPong;
//   final ConnectEnvelopeHandler onDefault;

//   const ConnectSignalingEnvelopeHandlers({
//     required this.onConnectionRequest,
//     required this.onOffer,
//     required this.onAnswer,
//     required this.onIceCandidate,
//     required this.onConnectionResponse,
//     required this.onPing,
//     required this.onPong,
//     required this.onDefault,
//   });
// }

// class ConnectSignalingEnvelopeRouter {
//   final ConnectSignalingEnvelopeHandlers _handlers;

//   const ConnectSignalingEnvelopeRouter({
//     required ConnectSignalingEnvelopeHandlers handlers,
//   }) : _handlers = handlers;

//   Future<void> route(SignalEnvelope envelope) {
//     switch (envelope.payloadType) {
//       case SignalingPayloadType.connectionRequest:
//         return _handlers.onConnectionRequest(envelope);
//       case SignalingPayloadType.offer:
//         return _handlers.onOffer(envelope);
//       case SignalingPayloadType.answer:
//         return _handlers.onAnswer(envelope);
//       case SignalingPayloadType.iceCandidate:
//         return _handlers.onIceCandidate(envelope);
//       case SignalingPayloadType.connectionResponse:
//         return _handlers.onConnectionResponse(envelope);
//       case SignalingPayloadType.ping:
//         return _handlers.onPing(envelope);
//       case SignalingPayloadType.pong:
//         return _handlers.onPong(envelope);
//       case SignalingPayloadType.unknown:
//       case SignalingPayloadType.hello:
//         return _handlers.onDefault(envelope);
//     }
//   }
// }
