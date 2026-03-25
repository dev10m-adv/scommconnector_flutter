import 'dart:async';

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:grpc/grpc.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/logging/log.dart';
import '../../domain/entities/signaling_entities.dart';
import 'generated/signaling/signaling.pb.dart' as signaling_pb;
import 'generated/signaling/signaling.pbgrpc.dart' as signaling_grpc;
import 'signaling_service_grpc_client.dart';

class SignalingServiceGrpcClientImpl implements SignalingServiceGrpcClient {
  final signaling_grpc.SignalingServiceClient _client;
  final SignalingAccessTokenProvider _accessTokenProvider;

  StreamController<signaling_pb.SignalEnvelope>? _outgoingController;
  StreamSubscription<signaling_pb.SignalEnvelope>? _incomingSubscription;
  StreamController<SignalingEnvelope>? _incomingController;

  SignalingServiceGrpcClientImpl({
    required String host,
    required int port,
    bool useTls = false,
    required SignalingAccessTokenProvider accessTokenProvider,
  }) : _client = signaling_grpc.SignalingServiceClient(
         ClientChannel(
           host,
           port: port,
           options: ChannelOptions(
             credentials: useTls
                 ? const ChannelCredentials.secure()
                 : const ChannelCredentials.insecure(),
           ),
         ),
       ),
       _accessTokenProvider = accessTokenProvider;

  @override
  Stream<SignalingEnvelope> connect({required String deviceId}) {
    infoLog('Opening signaling gRPC stream for deviceId=$deviceId.');
    final incomingController = StreamController<SignalingEnvelope>.broadcast();
    _incomingController = incomingController;

    unawaited(_openConnection(deviceId: deviceId, sink: incomingController));

    return incomingController.stream;
  }

  Future<void> _openConnection({
    required String deviceId,
    required StreamController<SignalingEnvelope> sink,
  }) async {
    try {
      debugLog('Creating authorized signaling call options.');
      final options = await _authorizedOptions();
      await _outgoingController?.close();
      _outgoingController = StreamController<signaling_pb.SignalEnvelope>();

      final responseStream = _client.connect(
        _outgoingController!.stream,
        options: options,
      );

      // First message must be hello with current deviceId.
      _outgoingController!.add(
        signaling_pb.SignalEnvelope(
          messageId: _buildMessageId(),
          hello: signaling_pb.HelloPayload(deviceId: deviceId),
        ),
      );
      debugLog('Sent signaling HELLO handshake for deviceId=$deviceId.');

      await _incomingSubscription?.cancel();
      _incomingSubscription = responseStream.listen(
        (event) {
          final envelope = _fromProtoEnvelope(event);
          debugLog(
            'Received signaling envelope from gRPC type=${envelope.payloadType} messageId=${envelope.messageId}.',
          );
          sink.add(envelope);
        },
        onError: (Object error, StackTrace stackTrace) {
          warningLog('Signaling gRPC stream error.', error, stackTrace);
          sink.addError(_toAppError(error), stackTrace);
        },
        onDone: () {
          warningLog('Signaling gRPC stream completed.');
          sink.close();
        },
      );
    } catch (error, stackTrace) {
      errorLog('Failed to open signaling gRPC stream.', error, stackTrace);
      sink.addError(_toAppError(error), stackTrace);
      await sink.close();
    }
  }

  @override
  Future<void> sendEnvelope(SignalingEnvelope envelope) async {
    try {
      if (_outgoingController == null) {
        throw const ServerException(
          message: 'Signaling stream is not connected.',
        );
      }

      debugLog(
        'Queueing outbound signaling envelope type=${envelope.payloadType} messageId=${envelope.messageId}.',
      );
      _outgoingController!.add(_toProtoEnvelope(envelope));
    } catch (error) {
      errorLog('Failed to queue outbound signaling envelope.', error);
      throw _toAppError(error);
    }
  }

  @override
  Stream<SignalingPresenceEvent> watchPresence({
    required List<String> targetUris,
  }) async* {
    try {
      infoLog('Watching presence for ${targetUris.length} target URIs.');
      final options = await _authorizedOptions();
      final response = _client.watchPresence(
        signaling_pb.WatchPresenceRequest(
          targets: targetUris
              .map((uri) => signaling_pb.DeviceRef(uri: uri))
              .toList(growable: false),
        ),
        options: options,
      );

      await for (final event in response) {
        final mapped = _fromProtoPresence(event);
        debugLog(
          'Presence update uri=${mapped.deviceUri} status=${mapped.status}.',
        );
        yield mapped;
      }
    } on GrpcError catch (error) {
      warningLog('Presence watch gRPC error: code=${error.code}.', error);
      throw _mapGrpcError(error);
    } catch (error) {
      if (error is AppException) rethrow;
      errorLog('Presence watch failed with unexpected error.', error);
      throw const UnknownAppException(
        message: 'Signaling presence watch failed.',
      );
    }
  }

  @override
  Future<void> disconnect() async {
    infoLog('Disconnecting signaling gRPC stream.');
    await _incomingSubscription?.cancel();
    _incomingSubscription = null;

    await _outgoingController?.close();
    _outgoingController = null;

    await _incomingController?.close();
    _incomingController = null;
  }

  signaling_pb.SignalEnvelope _toProtoEnvelope(SignalingEnvelope envelope) {
    final proto = signaling_pb.SignalEnvelope(
      messageId: envelope.messageId,
      sessionId: envelope.sessionId,
    );

    if (envelope.from != null) {
      proto.from = signaling_pb.DeviceRef(uri: envelope.from!.uri);
    }
    if (envelope.to != null) {
      proto.to = signaling_pb.DeviceRef(uri: envelope.to!.uri);
    }
    if (envelope.helloDeviceId != null && envelope.helloDeviceId!.isNotEmpty) {
      proto.hello = signaling_pb.HelloPayload(deviceId: envelope.helloDeviceId);
    }
    if (envelope.connectionRequest != null) {
      final request = envelope.connectionRequest!;
      proto.connectionRequest = signaling_pb.ConnectionRequest(
        requestId: request.requestId,
        serviceName: request.serviceName,
        note: request.note,
      );
    }
    if (envelope.connectionResponse != null) {
      final response = envelope.connectionResponse!;
      proto.connectionResponse = signaling_pb.ConnectionResponse(
        requestId: response.requestId,
        status: _toProtoResponseStatus(response.status),
        reason: response.reason,
      );
    }
    if (envelope.offer != null) {
      proto.offer = signaling_pb.OfferPayload(
        requestId: envelope.offer!.requestId,
        sdp: envelope.offer!.sdp,
      );
    }
    if (envelope.answer != null) {
      proto.answer = signaling_pb.AnswerPayload(
        requestId: envelope.answer!.requestId,
        sdp: envelope.answer!.sdp,
      );
    }
    if (envelope.iceCandidate != null) {
      final candidate = envelope.iceCandidate!;
      proto.iceCandidate = signaling_pb.IceCandidatePayload(
        requestId: candidate.requestId,
        candidate: candidate.candidate,
        sdpMid: candidate.sdpMid,
        sdpMlineIndex: candidate.sdpMLineIndex,
      );
    }
    if (envelope.pingTimestampMs != null) {
      proto.ping = signaling_pb.PingPayload(
        timestampMs: fixnum.Int64(envelope.pingTimestampMs!),
      );
    }
    if (envelope.pongTimestampMs != null) {
      proto.pong = signaling_pb.PongPayload(
        timestampMs: fixnum.Int64(envelope.pongTimestampMs!),
      );
    }

    return proto;
  }

  SignalingEnvelope _fromProtoEnvelope(signaling_pb.SignalEnvelope proto) {
    return SignalingEnvelope(
      messageId: proto.messageId,
      sessionId: proto.sessionId,
      from: proto.hasFrom() ? SignalingDeviceRef(uri: proto.from.uri) : null,
      to: proto.hasTo() ? SignalingDeviceRef(uri: proto.to.uri) : null,
      helloDeviceId: proto.hasHello() ? proto.hello.deviceId : null,
      connectionRequest: proto.hasConnectionRequest()
          ? SignalingConnectionRequest(
              requestId: proto.connectionRequest.requestId,
              serviceName: proto.connectionRequest.serviceName,
              note: proto.connectionRequest.note,
            )
          : null,
      connectionResponse: proto.hasConnectionResponse()
          ? SignalingConnectionResponse(
              requestId: proto.connectionResponse.requestId,
              status: _fromProtoResponseStatus(proto.connectionResponse.status),
              reason: proto.connectionResponse.reason,
            )
          : null,
      offer: proto.hasOffer()
          ? SignalingOffer(
              requestId: proto.offer.requestId,
              sdp: proto.offer.sdp,
            )
          : null,
      answer: proto.hasAnswer()
          ? SignalingAnswer(
              requestId: proto.answer.requestId,
              sdp: proto.answer.sdp,
            )
          : null,
      iceCandidate: proto.hasIceCandidate()
          ? SignalingIceCandidate(
              requestId: proto.iceCandidate.requestId,
              candidate: proto.iceCandidate.candidate,
              sdpMid: proto.iceCandidate.sdpMid,
              sdpMLineIndex: proto.iceCandidate.sdpMlineIndex,
            )
          : null,
      pingTimestampMs: proto.hasPing() ? proto.ping.timestampMs.toInt() : null,
      pongTimestampMs: proto.hasPong() ? proto.pong.timestampMs.toInt() : null,
    );
  }

  SignalingPresenceEvent _fromProtoPresence(signaling_pb.PresenceEvent event) {
    return SignalingPresenceEvent(
      deviceUri: event.device.uri,
      status: event.status.name,
      lastSeenAtMs: event.lastSeenAtMs.toInt(),
    );
  }

  signaling_pb.ConnectionResponseStatus _toProtoResponseStatus(
    SignalingConnectionResponseStatus status,
  ) {
    switch (status) {
      case SignalingConnectionResponseStatus.accepted:
        return signaling_pb.ConnectionResponseStatus.ACCEPTED;
      case SignalingConnectionResponseStatus.rejected:
        return signaling_pb.ConnectionResponseStatus.REJECTED;
      case SignalingConnectionResponseStatus.busy:
        return signaling_pb.ConnectionResponseStatus.BUSY;
      case SignalingConnectionResponseStatus.blocked:
        return signaling_pb.ConnectionResponseStatus.BLOCKED;
      case SignalingConnectionResponseStatus.unspecified:
        return signaling_pb
            .ConnectionResponseStatus
            .CONNECTION_RESPONSE_STATUS_UNSPECIFIED;
    }
  }

  SignalingConnectionResponseStatus _fromProtoResponseStatus(
    signaling_pb.ConnectionResponseStatus status,
  ) {
    switch (status) {
      case signaling_pb.ConnectionResponseStatus.ACCEPTED:
        return SignalingConnectionResponseStatus.accepted;
      case signaling_pb.ConnectionResponseStatus.REJECTED:
        return SignalingConnectionResponseStatus.rejected;
      case signaling_pb.ConnectionResponseStatus.BUSY:
        return SignalingConnectionResponseStatus.busy;
      case signaling_pb.ConnectionResponseStatus.BLOCKED:
        return SignalingConnectionResponseStatus.blocked;
      case signaling_pb
          .ConnectionResponseStatus
          .CONNECTION_RESPONSE_STATUS_UNSPECIFIED:
      default:
        return SignalingConnectionResponseStatus.unspecified;
    }
  }

  Future<CallOptions> _authorizedOptions() async {
    final accessToken = await _accessTokenProvider();
    if (accessToken == null || accessToken.isEmpty) {
      warningLog('Missing signaling access token while authorizing call.');
      throw const UnauthorizedException();
    }

    return CallOptions(
      metadata: <String, String>{'authorization': 'Bearer $accessToken'},
    );
  }

  AppException _toAppError(Object error) {
    if (error is AppException) {
      return error;
    }
    if (error is GrpcError) {
      return _mapGrpcError(error);
    }
    return const UnknownAppException(
      message: 'Signaling failed due to an unexpected error.',
    );
  }

  AppException _mapGrpcError(GrpcError error) {
    switch (error.code) {
      case StatusCode.deadlineExceeded:
        return const RequestTimeoutException();
      case StatusCode.unavailable:
        return const NoConnectionException();
      case StatusCode.unauthenticated:
      case StatusCode.permissionDenied:
        return const UnauthorizedException();
      case StatusCode.invalidArgument:
      case StatusCode.notFound:
      case StatusCode.failedPrecondition:
      case StatusCode.internal:
      case StatusCode.unknown:
      case StatusCode.aborted:
      case StatusCode.resourceExhausted:
        return const ServerException();
      default:
        return const UnknownAppException();
    }
  }

  String _buildMessageId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
