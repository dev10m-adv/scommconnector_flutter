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

import 'package:protobuf/protobuf.dart' as $pb;

class ConnectionResponseStatus extends $pb.ProtobufEnum {
  static const ConnectionResponseStatus CONNECTION_RESPONSE_STATUS_UNSPECIFIED =
      ConnectionResponseStatus._(
          0, _omitEnumNames ? '' : 'CONNECTION_RESPONSE_STATUS_UNSPECIFIED');
  static const ConnectionResponseStatus ACCEPTED =
      ConnectionResponseStatus._(1, _omitEnumNames ? '' : 'ACCEPTED');
  static const ConnectionResponseStatus REJECTED =
      ConnectionResponseStatus._(2, _omitEnumNames ? '' : 'REJECTED');
  static const ConnectionResponseStatus BUSY =
      ConnectionResponseStatus._(3, _omitEnumNames ? '' : 'BUSY');
  static const ConnectionResponseStatus BLOCKED =
      ConnectionResponseStatus._(4, _omitEnumNames ? '' : 'BLOCKED');
  static const ConnectionResponseStatus DISCONNECTED =
      ConnectionResponseStatus._(5, _omitEnumNames ? '' : 'DISCONNECTED');

  static const $core.List<ConnectionResponseStatus> values =
      <ConnectionResponseStatus>[
    CONNECTION_RESPONSE_STATUS_UNSPECIFIED,
    ACCEPTED,
    REJECTED,
    BUSY,
    BLOCKED,
    DISCONNECTED,
  ];

  static final $core.List<ConnectionResponseStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ConnectionResponseStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConnectionResponseStatus._(super.value, super.name);
}

class PresenceStatus extends $pb.ProtobufEnum {
  static const PresenceStatus PRESENCE_STATUS_UNSPECIFIED =
      PresenceStatus._(0, _omitEnumNames ? '' : 'PRESENCE_STATUS_UNSPECIFIED');
  static const PresenceStatus ONLINE =
      PresenceStatus._(1, _omitEnumNames ? '' : 'ONLINE');
  static const PresenceStatus OFFLINE =
      PresenceStatus._(2, _omitEnumNames ? '' : 'OFFLINE');

  static const $core.List<PresenceStatus> values = <PresenceStatus>[
    PRESENCE_STATUS_UNSPECIFIED,
    ONLINE,
    OFFLINE,
  ];

  static final $core.List<PresenceStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PresenceStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PresenceStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
