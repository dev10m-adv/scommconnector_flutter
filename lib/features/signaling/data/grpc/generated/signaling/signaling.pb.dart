// This is a generated file - do not edit.
//
// Generated from signaling/signaling.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'signaling.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'signaling.pbenum.dart';

/// Example:
/// scomm://alice/laptop:ollama
class DeviceRef extends $pb.GeneratedMessage {
  factory DeviceRef({
    $core.String? uri,
  }) {
    final result = create();
    if (uri != null) result.uri = uri;
    return result;
  }

  DeviceRef._();

  factory DeviceRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceRef',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceRef copyWith(void Function(DeviceRef) updates) =>
      super.copyWith((message) => updates(message as DeviceRef)) as DeviceRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceRef create() => DeviceRef._();
  @$core.override
  DeviceRef createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceRef getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceRef>(create);
  static DeviceRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uri => $_getSZ(0);
  @$pb.TagNumber(1)
  set uri($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUri() => $_has(0);
  @$pb.TagNumber(1)
  void clearUri() => $_clearField(1);
}

enum SignalEnvelope_Payload {
  hello,
  connectionRequest,
  connectionResponse,
  offer,
  answer,
  iceCandidate,
  ping,
  pong,
  notSet
}

class SignalEnvelope extends $pb.GeneratedMessage {
  factory SignalEnvelope({
    $core.String? messageId,
    $core.String? sessionId,
    DeviceRef? from,
    DeviceRef? to,
    HelloPayload? hello,
    ConnectionRequest? connectionRequest,
    ConnectionResponse? connectionResponse,
    OfferPayload? offer,
    AnswerPayload? answer,
    IceCandidatePayload? iceCandidate,
    PingPayload? ping,
    PongPayload? pong,
  }) {
    final result = create();
    if (messageId != null) result.messageId = messageId;
    if (sessionId != null) result.sessionId = sessionId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (hello != null) result.hello = hello;
    if (connectionRequest != null) result.connectionRequest = connectionRequest;
    if (connectionResponse != null)
      result.connectionResponse = connectionResponse;
    if (offer != null) result.offer = offer;
    if (answer != null) result.answer = answer;
    if (iceCandidate != null) result.iceCandidate = iceCandidate;
    if (ping != null) result.ping = ping;
    if (pong != null) result.pong = pong;
    return result;
  }

  SignalEnvelope._();

  factory SignalEnvelope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignalEnvelope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SignalEnvelope_Payload>
      _SignalEnvelope_PayloadByTag = {
    10: SignalEnvelope_Payload.hello,
    11: SignalEnvelope_Payload.connectionRequest,
    12: SignalEnvelope_Payload.connectionResponse,
    13: SignalEnvelope_Payload.offer,
    14: SignalEnvelope_Payload.answer,
    15: SignalEnvelope_Payload.iceCandidate,
    16: SignalEnvelope_Payload.ping,
    17: SignalEnvelope_Payload.pong,
    0: SignalEnvelope_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignalEnvelope',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14, 15, 16, 17])
    ..aOS(1, _omitFieldNames ? '' : 'messageId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOM<DeviceRef>(3, _omitFieldNames ? '' : 'from',
        subBuilder: DeviceRef.create)
    ..aOM<DeviceRef>(4, _omitFieldNames ? '' : 'to',
        subBuilder: DeviceRef.create)
    ..aOM<HelloPayload>(10, _omitFieldNames ? '' : 'hello',
        subBuilder: HelloPayload.create)
    ..aOM<ConnectionRequest>(11, _omitFieldNames ? '' : 'connectionRequest',
        subBuilder: ConnectionRequest.create)
    ..aOM<ConnectionResponse>(12, _omitFieldNames ? '' : 'connectionResponse',
        subBuilder: ConnectionResponse.create)
    ..aOM<OfferPayload>(13, _omitFieldNames ? '' : 'offer',
        subBuilder: OfferPayload.create)
    ..aOM<AnswerPayload>(14, _omitFieldNames ? '' : 'answer',
        subBuilder: AnswerPayload.create)
    ..aOM<IceCandidatePayload>(15, _omitFieldNames ? '' : 'iceCandidate',
        subBuilder: IceCandidatePayload.create)
    ..aOM<PingPayload>(16, _omitFieldNames ? '' : 'ping',
        subBuilder: PingPayload.create)
    ..aOM<PongPayload>(17, _omitFieldNames ? '' : 'pong',
        subBuilder: PongPayload.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalEnvelope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalEnvelope copyWith(void Function(SignalEnvelope) updates) =>
      super.copyWith((message) => updates(message as SignalEnvelope))
          as SignalEnvelope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignalEnvelope create() => SignalEnvelope._();
  @$core.override
  SignalEnvelope createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignalEnvelope getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignalEnvelope>(create);
  static SignalEnvelope? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  SignalEnvelope_Payload whichPayload() =>
      _SignalEnvelope_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  DeviceRef get from => $_getN(2);
  @$pb.TagNumber(3)
  set from(DeviceRef value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);
  @$pb.TagNumber(3)
  DeviceRef ensureFrom() => $_ensure(2);

  @$pb.TagNumber(4)
  DeviceRef get to => $_getN(3);
  @$pb.TagNumber(4)
  set to(DeviceRef value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearTo() => $_clearField(4);
  @$pb.TagNumber(4)
  DeviceRef ensureTo() => $_ensure(3);

  @$pb.TagNumber(10)
  HelloPayload get hello => $_getN(4);
  @$pb.TagNumber(10)
  set hello(HelloPayload value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasHello() => $_has(4);
  @$pb.TagNumber(10)
  void clearHello() => $_clearField(10);
  @$pb.TagNumber(10)
  HelloPayload ensureHello() => $_ensure(4);

  @$pb.TagNumber(11)
  ConnectionRequest get connectionRequest => $_getN(5);
  @$pb.TagNumber(11)
  set connectionRequest(ConnectionRequest value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasConnectionRequest() => $_has(5);
  @$pb.TagNumber(11)
  void clearConnectionRequest() => $_clearField(11);
  @$pb.TagNumber(11)
  ConnectionRequest ensureConnectionRequest() => $_ensure(5);

  @$pb.TagNumber(12)
  ConnectionResponse get connectionResponse => $_getN(6);
  @$pb.TagNumber(12)
  set connectionResponse(ConnectionResponse value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasConnectionResponse() => $_has(6);
  @$pb.TagNumber(12)
  void clearConnectionResponse() => $_clearField(12);
  @$pb.TagNumber(12)
  ConnectionResponse ensureConnectionResponse() => $_ensure(6);

  @$pb.TagNumber(13)
  OfferPayload get offer => $_getN(7);
  @$pb.TagNumber(13)
  set offer(OfferPayload value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOffer() => $_has(7);
  @$pb.TagNumber(13)
  void clearOffer() => $_clearField(13);
  @$pb.TagNumber(13)
  OfferPayload ensureOffer() => $_ensure(7);

  @$pb.TagNumber(14)
  AnswerPayload get answer => $_getN(8);
  @$pb.TagNumber(14)
  set answer(AnswerPayload value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasAnswer() => $_has(8);
  @$pb.TagNumber(14)
  void clearAnswer() => $_clearField(14);
  @$pb.TagNumber(14)
  AnswerPayload ensureAnswer() => $_ensure(8);

  @$pb.TagNumber(15)
  IceCandidatePayload get iceCandidate => $_getN(9);
  @$pb.TagNumber(15)
  set iceCandidate(IceCandidatePayload value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasIceCandidate() => $_has(9);
  @$pb.TagNumber(15)
  void clearIceCandidate() => $_clearField(15);
  @$pb.TagNumber(15)
  IceCandidatePayload ensureIceCandidate() => $_ensure(9);

  @$pb.TagNumber(16)
  PingPayload get ping => $_getN(10);
  @$pb.TagNumber(16)
  set ping(PingPayload value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasPing() => $_has(10);
  @$pb.TagNumber(16)
  void clearPing() => $_clearField(16);
  @$pb.TagNumber(16)
  PingPayload ensurePing() => $_ensure(10);

  @$pb.TagNumber(17)
  PongPayload get pong => $_getN(11);
  @$pb.TagNumber(17)
  set pong(PongPayload value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasPong() => $_has(11);
  @$pb.TagNumber(17)
  void clearPong() => $_clearField(17);
  @$pb.TagNumber(17)
  PongPayload ensurePong() => $_ensure(11);
}

/// First message sent by client after opening the stream.
class HelloPayload extends $pb.GeneratedMessage {
  factory HelloPayload({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  HelloPayload._();

  factory HelloPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HelloPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HelloPayload',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HelloPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HelloPayload copyWith(void Function(HelloPayload) updates) =>
      super.copyWith((message) => updates(message as HelloPayload))
          as HelloPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HelloPayload create() => HelloPayload._();
  @$core.override
  HelloPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HelloPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HelloPayload>(create);
  static HelloPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class ConnectionRequest extends $pb.GeneratedMessage {
  factory ConnectionRequest({
    $core.String? requestId,
    $core.String? serviceName,
    $core.String? note,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (serviceName != null) result.serviceName = serviceName;
    if (note != null) result.note = note;
    return result;
  }

  ConnectionRequest._();

  factory ConnectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectionRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'serviceName')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionRequest copyWith(void Function(ConnectionRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectionRequest))
          as ConnectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectionRequest create() => ConnectionRequest._();
  @$core.override
  ConnectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConnectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectionRequest>(create);
  static ConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

class ConnectionResponse extends $pb.GeneratedMessage {
  factory ConnectionResponse({
    $core.String? requestId,
    ConnectionResponseStatus? status,
    $core.String? reason,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (status != null) result.status = status;
    if (reason != null) result.reason = reason;
    return result;
  }

  ConnectionResponse._();

  factory ConnectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectionResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aE<ConnectionResponseStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: ConnectionResponseStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionResponse copyWith(void Function(ConnectionResponse) updates) =>
      super.copyWith((message) => updates(message as ConnectionResponse))
          as ConnectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectionResponse create() => ConnectionResponse._();
  @$core.override
  ConnectionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConnectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectionResponse>(create);
  static ConnectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  ConnectionResponseStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ConnectionResponseStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class OfferPayload extends $pb.GeneratedMessage {
  factory OfferPayload({
    $core.String? requestId,
    $core.String? sdp,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (sdp != null) result.sdp = sdp;
    return result;
  }

  OfferPayload._();

  factory OfferPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OfferPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferPayload',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'sdp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferPayload copyWith(void Function(OfferPayload) updates) =>
      super.copyWith((message) => updates(message as OfferPayload))
          as OfferPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OfferPayload create() => OfferPayload._();
  @$core.override
  OfferPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OfferPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferPayload>(create);
  static OfferPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdp => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdp($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSdp() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdp() => $_clearField(2);
}

class AnswerPayload extends $pb.GeneratedMessage {
  factory AnswerPayload({
    $core.String? requestId,
    $core.String? sdp,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (sdp != null) result.sdp = sdp;
    return result;
  }

  AnswerPayload._();

  factory AnswerPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AnswerPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnswerPayload',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'sdp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerPayload copyWith(void Function(AnswerPayload) updates) =>
      super.copyWith((message) => updates(message as AnswerPayload))
          as AnswerPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnswerPayload create() => AnswerPayload._();
  @$core.override
  AnswerPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AnswerPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnswerPayload>(create);
  static AnswerPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdp => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdp($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSdp() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdp() => $_clearField(2);
}

class IceCandidatePayload extends $pb.GeneratedMessage {
  factory IceCandidatePayload({
    $core.String? requestId,
    $core.String? candidate,
    $core.String? sdpMid,
    $core.int? sdpMlineIndex,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (candidate != null) result.candidate = candidate;
    if (sdpMid != null) result.sdpMid = sdpMid;
    if (sdpMlineIndex != null) result.sdpMlineIndex = sdpMlineIndex;
    return result;
  }

  IceCandidatePayload._();

  factory IceCandidatePayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IceCandidatePayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IceCandidatePayload',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'candidate')
    ..aOS(3, _omitFieldNames ? '' : 'sdpMid')
    ..aI(4, _omitFieldNames ? '' : 'sdpMlineIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceCandidatePayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceCandidatePayload copyWith(void Function(IceCandidatePayload) updates) =>
      super.copyWith((message) => updates(message as IceCandidatePayload))
          as IceCandidatePayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IceCandidatePayload create() => IceCandidatePayload._();
  @$core.override
  IceCandidatePayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IceCandidatePayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IceCandidatePayload>(create);
  static IceCandidatePayload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get candidate => $_getSZ(1);
  @$pb.TagNumber(2)
  set candidate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCandidate() => $_has(1);
  @$pb.TagNumber(2)
  void clearCandidate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sdpMid => $_getSZ(2);
  @$pb.TagNumber(3)
  set sdpMid($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSdpMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearSdpMid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get sdpMlineIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set sdpMlineIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSdpMlineIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSdpMlineIndex() => $_clearField(4);
}

class PingPayload extends $pb.GeneratedMessage {
  factory PingPayload({
    $fixnum.Int64? timestampMs,
  }) {
    final result = create();
    if (timestampMs != null) result.timestampMs = timestampMs;
    return result;
  }

  PingPayload._();

  factory PingPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PingPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PingPayload',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'timestampMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingPayload copyWith(void Function(PingPayload) updates) =>
      super.copyWith((message) => updates(message as PingPayload))
          as PingPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingPayload create() => PingPayload._();
  @$core.override
  PingPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PingPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PingPayload>(create);
  static PingPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestampMs => $_getI64(0);
  @$pb.TagNumber(1)
  set timestampMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestampMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampMs() => $_clearField(1);
}

class PongPayload extends $pb.GeneratedMessage {
  factory PongPayload({
    $fixnum.Int64? timestampMs,
  }) {
    final result = create();
    if (timestampMs != null) result.timestampMs = timestampMs;
    return result;
  }

  PongPayload._();

  factory PongPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PongPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PongPayload',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'timestampMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PongPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PongPayload copyWith(void Function(PongPayload) updates) =>
      super.copyWith((message) => updates(message as PongPayload))
          as PongPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PongPayload create() => PongPayload._();
  @$core.override
  PongPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PongPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PongPayload>(create);
  static PongPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestampMs => $_getI64(0);
  @$pb.TagNumber(1)
  set timestampMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestampMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampMs() => $_clearField(1);
}

class WatchPresenceRequest extends $pb.GeneratedMessage {
  factory WatchPresenceRequest({
    $core.Iterable<DeviceRef>? targets,
  }) {
    final result = create();
    if (targets != null) result.targets.addAll(targets);
    return result;
  }

  WatchPresenceRequest._();

  factory WatchPresenceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchPresenceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchPresenceRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..pPM<DeviceRef>(1, _omitFieldNames ? '' : 'targets',
        subBuilder: DeviceRef.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPresenceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPresenceRequest copyWith(void Function(WatchPresenceRequest) updates) =>
      super.copyWith((message) => updates(message as WatchPresenceRequest))
          as WatchPresenceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchPresenceRequest create() => WatchPresenceRequest._();
  @$core.override
  WatchPresenceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchPresenceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchPresenceRequest>(create);
  static WatchPresenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DeviceRef> get targets => $_getList(0);
}

class PresenceEvent extends $pb.GeneratedMessage {
  factory PresenceEvent({
    DeviceRef? device,
    PresenceStatus? status,
    $fixnum.Int64? lastSeenAtMs,
  }) {
    final result = create();
    if (device != null) result.device = device;
    if (status != null) result.status = status;
    if (lastSeenAtMs != null) result.lastSeenAtMs = lastSeenAtMs;
    return result;
  }

  PresenceEvent._();

  factory PresenceEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PresenceEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PresenceEvent',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'scomm.signaling'),
      createEmptyInstance: create)
    ..aOM<DeviceRef>(1, _omitFieldNames ? '' : 'device',
        subBuilder: DeviceRef.create)
    ..aE<PresenceStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: PresenceStatus.values)
    ..aInt64(3, _omitFieldNames ? '' : 'lastSeenAtMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PresenceEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PresenceEvent copyWith(void Function(PresenceEvent) updates) =>
      super.copyWith((message) => updates(message as PresenceEvent))
          as PresenceEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PresenceEvent create() => PresenceEvent._();
  @$core.override
  PresenceEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PresenceEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PresenceEvent>(create);
  static PresenceEvent? _defaultInstance;

  @$pb.TagNumber(1)
  DeviceRef get device => $_getN(0);
  @$pb.TagNumber(1)
  set device(DeviceRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  DeviceRef ensureDevice() => $_ensure(0);

  @$pb.TagNumber(2)
  PresenceStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(PresenceStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get lastSeenAtMs => $_getI64(2);
  @$pb.TagNumber(3)
  set lastSeenAtMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastSeenAtMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastSeenAtMs() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
