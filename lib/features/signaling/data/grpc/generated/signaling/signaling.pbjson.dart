// This is a generated file - do not edit.
//
// Generated from signaling/signaling.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use connectionResponseStatusDescriptor instead')
const ConnectionResponseStatus$json = {
  '1': 'ConnectionResponseStatus',
  '2': [
    {'1': 'CONNECTION_RESPONSE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ACCEPTED', '2': 1},
    {'1': 'REJECTED', '2': 2},
    {'1': 'BUSY', '2': 3},
    {'1': 'BLOCKED', '2': 4},
  ],
};

/// Descriptor for `ConnectionResponseStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionResponseStatusDescriptor = $convert.base64Decode(
    'ChhDb25uZWN0aW9uUmVzcG9uc2VTdGF0dXMSKgomQ09OTkVDVElPTl9SRVNQT05TRV9TVEFUVV'
    'NfVU5TUEVDSUZJRUQQABIMCghBQ0NFUFRFRBABEgwKCFJFSkVDVEVEEAISCAoEQlVTWRADEgsK'
    'B0JMT0NLRUQQBA==');

@$core.Deprecated('Use presenceStatusDescriptor instead')
const PresenceStatus$json = {
  '1': 'PresenceStatus',
  '2': [
    {'1': 'PRESENCE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ONLINE', '2': 1},
    {'1': 'OFFLINE', '2': 2},
  ],
};

/// Descriptor for `PresenceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List presenceStatusDescriptor = $convert.base64Decode(
    'Cg5QcmVzZW5jZVN0YXR1cxIfChtQUkVTRU5DRV9TVEFUVVNfVU5TUEVDSUZJRUQQABIKCgZPTk'
    'xJTkUQARILCgdPRkZMSU5FEAI=');

@$core.Deprecated('Use deviceRefDescriptor instead')
const DeviceRef$json = {
  '1': 'DeviceRef',
  '2': [
    {'1': 'uri', '3': 1, '4': 1, '5': 9, '10': 'uri'},
  ],
};

/// Descriptor for `DeviceRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceRefDescriptor =
    $convert.base64Decode('CglEZXZpY2VSZWYSEAoDdXJpGAEgASgJUgN1cmk=');

@$core.Deprecated('Use signalEnvelopeDescriptor instead')
const SignalEnvelope$json = {
  '1': 'SignalEnvelope',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'from',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.DeviceRef',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.DeviceRef',
      '10': 'to'
    },
    {
      '1': 'hello',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.HelloPayload',
      '9': 0,
      '10': 'hello'
    },
    {
      '1': 'connection_request',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.ConnectionRequest',
      '9': 0,
      '10': 'connectionRequest'
    },
    {
      '1': 'connection_response',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.ConnectionResponse',
      '9': 0,
      '10': 'connectionResponse'
    },
    {
      '1': 'offer',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.OfferPayload',
      '9': 0,
      '10': 'offer'
    },
    {
      '1': 'answer',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.AnswerPayload',
      '9': 0,
      '10': 'answer'
    },
    {
      '1': 'ice_candidate',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.IceCandidatePayload',
      '9': 0,
      '10': 'iceCandidate'
    },
    {
      '1': 'ping',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.PingPayload',
      '9': 0,
      '10': 'ping'
    },
    {
      '1': 'pong',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.PongPayload',
      '9': 0,
      '10': 'pong'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `SignalEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalEnvelopeDescriptor = $convert.base64Decode(
    'Cg5TaWduYWxFbnZlbG9wZRIdCgptZXNzYWdlX2lkGAEgASgJUgltZXNzYWdlSWQSHQoKc2Vzc2'
    'lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEi4KBGZyb20YAyABKAsyGi5zY29tbS5zaWduYWxpbmcu'
    'RGV2aWNlUmVmUgRmcm9tEioKAnRvGAQgASgLMhouc2NvbW0uc2lnbmFsaW5nLkRldmljZVJlZl'
    'ICdG8SNQoFaGVsbG8YCiABKAsyHS5zY29tbS5zaWduYWxpbmcuSGVsbG9QYXlsb2FkSABSBWhl'
    'bGxvElMKEmNvbm5lY3Rpb25fcmVxdWVzdBgLIAEoCzIiLnNjb21tLnNpZ25hbGluZy5Db25uZW'
    'N0aW9uUmVxdWVzdEgAUhFjb25uZWN0aW9uUmVxdWVzdBJWChNjb25uZWN0aW9uX3Jlc3BvbnNl'
    'GAwgASgLMiMuc2NvbW0uc2lnbmFsaW5nLkNvbm5lY3Rpb25SZXNwb25zZUgAUhJjb25uZWN0aW'
    '9uUmVzcG9uc2USNQoFb2ZmZXIYDSABKAsyHS5zY29tbS5zaWduYWxpbmcuT2ZmZXJQYXlsb2Fk'
    'SABSBW9mZmVyEjgKBmFuc3dlchgOIAEoCzIeLnNjb21tLnNpZ25hbGluZy5BbnN3ZXJQYXlsb2'
    'FkSABSBmFuc3dlchJLCg1pY2VfY2FuZGlkYXRlGA8gASgLMiQuc2NvbW0uc2lnbmFsaW5nLklj'
    'ZUNhbmRpZGF0ZVBheWxvYWRIAFIMaWNlQ2FuZGlkYXRlEjIKBHBpbmcYECABKAsyHC5zY29tbS'
    '5zaWduYWxpbmcuUGluZ1BheWxvYWRIAFIEcGluZxIyCgRwb25nGBEgASgLMhwuc2NvbW0uc2ln'
    'bmFsaW5nLlBvbmdQYXlsb2FkSABSBHBvbmdCCQoHcGF5bG9hZA==');

@$core.Deprecated('Use helloPayloadDescriptor instead')
const HelloPayload$json = {
  '1': 'HelloPayload',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `HelloPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloPayloadDescriptor = $convert.base64Decode(
    'CgxIZWxsb1BheWxvYWQSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZA==');

@$core.Deprecated('Use connectionRequestDescriptor instead')
const ConnectionRequest$json = {
  '1': 'ConnectionRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'service_name', '3': 2, '4': 1, '5': 9, '10': 'serviceName'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ConnectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionRequestDescriptor = $convert.base64Decode(
    'ChFDb25uZWN0aW9uUmVxdWVzdBIdCgpyZXF1ZXN0X2lkGAEgASgJUglyZXF1ZXN0SWQSIQoMc2'
    'VydmljZV9uYW1lGAIgASgJUgtzZXJ2aWNlTmFtZRISCgRub3RlGAMgASgJUgRub3Rl');

@$core.Deprecated('Use connectionResponseDescriptor instead')
const ConnectionResponse$json = {
  '1': 'ConnectionResponse',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.scomm.signaling.ConnectionResponseStatus',
      '10': 'status'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ConnectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionResponseDescriptor = $convert.base64Decode(
    'ChJDb25uZWN0aW9uUmVzcG9uc2USHQoKcmVxdWVzdF9pZBgBIAEoCVIJcmVxdWVzdElkEkEKBn'
    'N0YXR1cxgCIAEoDjIpLnNjb21tLnNpZ25hbGluZy5Db25uZWN0aW9uUmVzcG9uc2VTdGF0dXNS'
    'BnN0YXR1cxIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use offerPayloadDescriptor instead')
const OfferPayload$json = {
  '1': 'OfferPayload',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'sdp', '3': 2, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `OfferPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerPayloadDescriptor = $convert.base64Decode(
    'CgxPZmZlclBheWxvYWQSHQoKcmVxdWVzdF9pZBgBIAEoCVIJcmVxdWVzdElkEhAKA3NkcBgCIA'
    'EoCVIDc2Rw');

@$core.Deprecated('Use answerPayloadDescriptor instead')
const AnswerPayload$json = {
  '1': 'AnswerPayload',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'sdp', '3': 2, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `AnswerPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List answerPayloadDescriptor = $convert.base64Decode(
    'Cg1BbnN3ZXJQYXlsb2FkEh0KCnJlcXVlc3RfaWQYASABKAlSCXJlcXVlc3RJZBIQCgNzZHAYAi'
    'ABKAlSA3NkcA==');

@$core.Deprecated('Use iceCandidatePayloadDescriptor instead')
const IceCandidatePayload$json = {
  '1': 'IceCandidatePayload',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'candidate', '3': 2, '4': 1, '5': 9, '10': 'candidate'},
    {'1': 'sdp_mid', '3': 3, '4': 1, '5': 9, '10': 'sdpMid'},
    {'1': 'sdp_mline_index', '3': 4, '4': 1, '5': 5, '10': 'sdpMlineIndex'},
  ],
};

/// Descriptor for `IceCandidatePayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iceCandidatePayloadDescriptor = $convert.base64Decode(
    'ChNJY2VDYW5kaWRhdGVQYXlsb2FkEh0KCnJlcXVlc3RfaWQYASABKAlSCXJlcXVlc3RJZBIcCg'
    'ljYW5kaWRhdGUYAiABKAlSCWNhbmRpZGF0ZRIXCgdzZHBfbWlkGAMgASgJUgZzZHBNaWQSJgoP'
    'c2RwX21saW5lX2luZGV4GAQgASgFUg1zZHBNbGluZUluZGV4');

@$core.Deprecated('Use pingPayloadDescriptor instead')
const PingPayload$json = {
  '1': 'PingPayload',
  '2': [
    {'1': 'timestamp_ms', '3': 1, '4': 1, '5': 3, '10': 'timestampMs'},
  ],
};

/// Descriptor for `PingPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingPayloadDescriptor = $convert.base64Decode(
    'CgtQaW5nUGF5bG9hZBIhCgx0aW1lc3RhbXBfbXMYASABKANSC3RpbWVzdGFtcE1z');

@$core.Deprecated('Use pongPayloadDescriptor instead')
const PongPayload$json = {
  '1': 'PongPayload',
  '2': [
    {'1': 'timestamp_ms', '3': 1, '4': 1, '5': 3, '10': 'timestampMs'},
  ],
};

/// Descriptor for `PongPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pongPayloadDescriptor = $convert.base64Decode(
    'CgtQb25nUGF5bG9hZBIhCgx0aW1lc3RhbXBfbXMYASABKANSC3RpbWVzdGFtcE1z');

@$core.Deprecated('Use watchPresenceRequestDescriptor instead')
const WatchPresenceRequest$json = {
  '1': 'WatchPresenceRequest',
  '2': [
    {
      '1': 'targets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.scomm.signaling.DeviceRef',
      '10': 'targets'
    },
  ],
};

/// Descriptor for `WatchPresenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPresenceRequestDescriptor = $convert.base64Decode(
    'ChRXYXRjaFByZXNlbmNlUmVxdWVzdBI0Cgd0YXJnZXRzGAEgAygLMhouc2NvbW0uc2lnbmFsaW'
    '5nLkRldmljZVJlZlIHdGFyZ2V0cw==');

@$core.Deprecated('Use presenceEventDescriptor instead')
const PresenceEvent$json = {
  '1': 'PresenceEvent',
  '2': [
    {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.scomm.signaling.DeviceRef',
      '10': 'device'
    },
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.scomm.signaling.PresenceStatus',
      '10': 'status'
    },
    {'1': 'last_seen_at_ms', '3': 3, '4': 1, '5': 3, '10': 'lastSeenAtMs'},
  ],
};

/// Descriptor for `PresenceEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceEventDescriptor = $convert.base64Decode(
    'Cg1QcmVzZW5jZUV2ZW50EjIKBmRldmljZRgBIAEoCzIaLnNjb21tLnNpZ25hbGluZy5EZXZpY2'
    'VSZWZSBmRldmljZRI3CgZzdGF0dXMYAiABKA4yHy5zY29tbS5zaWduYWxpbmcuUHJlc2VuY2VT'
    'dGF0dXNSBnN0YXR1cxIlCg9sYXN0X3NlZW5fYXRfbXMYAyABKANSDGxhc3RTZWVuQXRNcw==');
