// This is a generated file - do not edit.
//
// Generated from identity/identity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DeviceMode extends $pb.ProtobufEnum {
  static const DeviceMode DEVICE_MODE_UNSPECIFIED =
      DeviceMode._(0, _omitEnumNames ? '' : 'DEVICE_MODE_UNSPECIFIED');
  static const DeviceMode CLIENT =
      DeviceMode._(1, _omitEnumNames ? '' : 'CLIENT');
  static const DeviceMode PROVIDER =
      DeviceMode._(2, _omitEnumNames ? '' : 'PROVIDER');
  static const DeviceMode HYBRID =
      DeviceMode._(3, _omitEnumNames ? '' : 'HYBRID');

  static const $core.List<DeviceMode> values = <DeviceMode>[
    DEVICE_MODE_UNSPECIFIED,
    CLIENT,
    PROVIDER,
    HYBRID,
  ];

  static final $core.List<DeviceMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DeviceMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeviceMode._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
