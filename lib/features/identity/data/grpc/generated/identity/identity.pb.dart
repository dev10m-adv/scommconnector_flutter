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

import 'identity.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'identity.pbenum.dart';

class RegisterDeviceRequest extends $pb.GeneratedMessage {
  factory RegisterDeviceRequest({
    $core.String? deviceName,
    $core.String? deviceType,
    DeviceMode? mode,
  }) {
    final result = create();
    if (deviceName != null) result.deviceName = deviceName;
    if (deviceType != null) result.deviceType = deviceType;
    if (mode != null) result.mode = mode;
    return result;
  }

  RegisterDeviceRequest._();

  factory RegisterDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterDeviceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceName')
    ..aOS(2, _omitFieldNames ? '' : 'deviceType')
    ..aE<DeviceMode>(3, _omitFieldNames ? '' : 'mode',
        enumValues: DeviceMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDeviceRequest copyWith(
          void Function(RegisterDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterDeviceRequest))
          as RegisterDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterDeviceRequest create() => RegisterDeviceRequest._();
  @$core.override
  RegisterDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterDeviceRequest>(create);
  static RegisterDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceType => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceType() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceType() => $_clearField(2);

  @$pb.TagNumber(3)
  DeviceMode get mode => $_getN(2);
  @$pb.TagNumber(3)
  set mode(DeviceMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);
}

class RegisterDeviceResponse extends $pb.GeneratedMessage {
  factory RegisterDeviceResponse({
    Device? device,
    $core.String? message,
  }) {
    final result = create();
    if (device != null) result.device = device;
    if (message != null) result.message = message;
    return result;
  }

  RegisterDeviceResponse._();

  factory RegisterDeviceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterDeviceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterDeviceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOM<Device>(1, _omitFieldNames ? '' : 'device', subBuilder: Device.create)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDeviceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterDeviceResponse copyWith(
          void Function(RegisterDeviceResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterDeviceResponse))
          as RegisterDeviceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterDeviceResponse create() => RegisterDeviceResponse._();
  @$core.override
  RegisterDeviceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterDeviceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterDeviceResponse>(create);
  static RegisterDeviceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Device get device => $_getN(0);
  @$pb.TagNumber(1)
  set device(Device value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  Device ensureDevice() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class UpdateDeviceRequest extends $pb.GeneratedMessage {
  factory UpdateDeviceRequest({
    $core.String? deviceId,
    $core.String? deviceName,
    $core.String? deviceType,
    DeviceMode? mode,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (deviceName != null) result.deviceName = deviceName;
    if (deviceType != null) result.deviceType = deviceType;
    if (mode != null) result.mode = mode;
    return result;
  }

  UpdateDeviceRequest._();

  factory UpdateDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateDeviceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aOS(3, _omitFieldNames ? '' : 'deviceType')
    ..aE<DeviceMode>(4, _omitFieldNames ? '' : 'mode',
        enumValues: DeviceMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeviceRequest copyWith(void Function(UpdateDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateDeviceRequest))
          as UpdateDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateDeviceRequest create() => UpdateDeviceRequest._();
  @$core.override
  UpdateDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateDeviceRequest>(create);
  static UpdateDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceType => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceType() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceType() => $_clearField(3);

  @$pb.TagNumber(4)
  DeviceMode get mode => $_getN(3);
  @$pb.TagNumber(4)
  set mode(DeviceMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);
}

class UpdateDeviceResponse extends $pb.GeneratedMessage {
  factory UpdateDeviceResponse({
    Device? device,
    $core.String? message,
  }) {
    final result = create();
    if (device != null) result.device = device;
    if (message != null) result.message = message;
    return result;
  }

  UpdateDeviceResponse._();

  factory UpdateDeviceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateDeviceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateDeviceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOM<Device>(1, _omitFieldNames ? '' : 'device', subBuilder: Device.create)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeviceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeviceResponse copyWith(void Function(UpdateDeviceResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateDeviceResponse))
          as UpdateDeviceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateDeviceResponse create() => UpdateDeviceResponse._();
  @$core.override
  UpdateDeviceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateDeviceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateDeviceResponse>(create);
  static UpdateDeviceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Device get device => $_getN(0);
  @$pb.TagNumber(1)
  set device(Device value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  Device ensureDevice() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class DeleteDeviceRequest extends $pb.GeneratedMessage {
  factory DeleteDeviceRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  DeleteDeviceRequest._();

  factory DeleteDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteDeviceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteDeviceRequest copyWith(void Function(DeleteDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteDeviceRequest))
          as DeleteDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteDeviceRequest create() => DeleteDeviceRequest._();
  @$core.override
  DeleteDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteDeviceRequest>(create);
  static DeleteDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class DeleteDeviceResponse extends $pb.GeneratedMessage {
  factory DeleteDeviceResponse({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  DeleteDeviceResponse._();

  factory DeleteDeviceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteDeviceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteDeviceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteDeviceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteDeviceResponse copyWith(void Function(DeleteDeviceResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteDeviceResponse))
          as DeleteDeviceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteDeviceResponse create() => DeleteDeviceResponse._();
  @$core.override
  DeleteDeviceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteDeviceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteDeviceResponse>(create);
  static DeleteDeviceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class ListMyDevicesRequest extends $pb.GeneratedMessage {
  factory ListMyDevicesRequest() => create();

  ListMyDevicesRequest._();

  factory ListMyDevicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMyDevicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMyDevicesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyDevicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyDevicesRequest copyWith(void Function(ListMyDevicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListMyDevicesRequest))
          as ListMyDevicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMyDevicesRequest create() => ListMyDevicesRequest._();
  @$core.override
  ListMyDevicesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMyDevicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMyDevicesRequest>(create);
  static ListMyDevicesRequest? _defaultInstance;
}

class ListMyDevicesResponse extends $pb.GeneratedMessage {
  factory ListMyDevicesResponse({
    $core.Iterable<Device>? devices,
  }) {
    final result = create();
    if (devices != null) result.devices.addAll(devices);
    return result;
  }

  ListMyDevicesResponse._();

  factory ListMyDevicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMyDevicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMyDevicesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..pPM<Device>(1, _omitFieldNames ? '' : 'devices',
        subBuilder: Device.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyDevicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyDevicesResponse copyWith(
          void Function(ListMyDevicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListMyDevicesResponse))
          as ListMyDevicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMyDevicesResponse create() => ListMyDevicesResponse._();
  @$core.override
  ListMyDevicesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMyDevicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMyDevicesResponse>(create);
  static ListMyDevicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Device> get devices => $_getList(0);
}

class ListUserDevicesRequest extends $pb.GeneratedMessage {
  factory ListUserDevicesRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  ListUserDevicesRequest._();

  factory ListUserDevicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUserDevicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUserDevicesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserDevicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserDevicesRequest copyWith(
          void Function(ListUserDevicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListUserDevicesRequest))
          as ListUserDevicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUserDevicesRequest create() => ListUserDevicesRequest._();
  @$core.override
  ListUserDevicesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUserDevicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUserDevicesRequest>(create);
  static ListUserDevicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class ListUserDevicesResponse extends $pb.GeneratedMessage {
  factory ListUserDevicesResponse({
    $core.Iterable<Device>? devices,
  }) {
    final result = create();
    if (devices != null) result.devices.addAll(devices);
    return result;
  }

  ListUserDevicesResponse._();

  factory ListUserDevicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUserDevicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUserDevicesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..pPM<Device>(1, _omitFieldNames ? '' : 'devices',
        subBuilder: Device.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserDevicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserDevicesResponse copyWith(
          void Function(ListUserDevicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListUserDevicesResponse))
          as ListUserDevicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUserDevicesResponse create() => ListUserDevicesResponse._();
  @$core.override
  ListUserDevicesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUserDevicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUserDevicesResponse>(create);
  static ListUserDevicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Device> get devices => $_getList(0);
}

class Device extends $pb.GeneratedMessage {
  factory Device({
    $core.String? deviceId,
    $core.String? userId,
    $core.String? deviceName,
    $core.String? deviceType,
    DeviceMode? mode,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (userId != null) result.userId = userId;
    if (deviceName != null) result.deviceName = deviceName;
    if (deviceType != null) result.deviceType = deviceType;
    if (mode != null) result.mode = mode;
    return result;
  }

  Device._();

  factory Device.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Device.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Device',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'deviceName')
    ..aOS(4, _omitFieldNames ? '' : 'deviceType')
    ..aE<DeviceMode>(5, _omitFieldNames ? '' : 'mode',
        enumValues: DeviceMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Device clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Device copyWith(void Function(Device) updates) =>
      super.copyWith((message) => updates(message as Device)) as Device;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Device create() => Device._();
  @$core.override
  Device createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Device getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Device>(create);
  static Device? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get deviceType => $_getSZ(3);
  @$pb.TagNumber(4)
  set deviceType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeviceType() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeviceType() => $_clearField(4);

  @$pb.TagNumber(5)
  DeviceMode get mode => $_getN(4);
  @$pb.TagNumber(5)
  set mode(DeviceMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearMode() => $_clearField(5);
}

class RegisterServiceRequest extends $pb.GeneratedMessage {
  factory RegisterServiceRequest({
    $core.String? deviceId,
    $core.String? serviceName,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (serviceName != null) result.serviceName = serviceName;
    return result;
  }

  RegisterServiceRequest._();

  factory RegisterServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'serviceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterServiceRequest copyWith(
          void Function(RegisterServiceRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterServiceRequest))
          as RegisterServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterServiceRequest create() => RegisterServiceRequest._();
  @$core.override
  RegisterServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterServiceRequest>(create);
  static RegisterServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceName() => $_clearField(2);
}

class RegisterServiceResponse extends $pb.GeneratedMessage {
  factory RegisterServiceResponse({
    Service? service,
    $core.String? message,
  }) {
    final result = create();
    if (service != null) result.service = service;
    if (message != null) result.message = message;
    return result;
  }

  RegisterServiceResponse._();

  factory RegisterServiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterServiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterServiceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOM<Service>(1, _omitFieldNames ? '' : 'service',
        subBuilder: Service.create)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterServiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterServiceResponse copyWith(
          void Function(RegisterServiceResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterServiceResponse))
          as RegisterServiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterServiceResponse create() => RegisterServiceResponse._();
  @$core.override
  RegisterServiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterServiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterServiceResponse>(create);
  static RegisterServiceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Service get service => $_getN(0);
  @$pb.TagNumber(1)
  set service(Service value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasService() => $_has(0);
  @$pb.TagNumber(1)
  void clearService() => $_clearField(1);
  @$pb.TagNumber(1)
  Service ensureService() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class ListDeviceServicesRequest extends $pb.GeneratedMessage {
  factory ListDeviceServicesRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  ListDeviceServicesRequest._();

  factory ListDeviceServicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDeviceServicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDeviceServicesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeviceServicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeviceServicesRequest copyWith(
          void Function(ListDeviceServicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListDeviceServicesRequest))
          as ListDeviceServicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeviceServicesRequest create() => ListDeviceServicesRequest._();
  @$core.override
  ListDeviceServicesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDeviceServicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDeviceServicesRequest>(create);
  static ListDeviceServicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class ListDeviceServicesResponse extends $pb.GeneratedMessage {
  factory ListDeviceServicesResponse({
    $core.Iterable<Service>? services,
  }) {
    final result = create();
    if (services != null) result.services.addAll(services);
    return result;
  }

  ListDeviceServicesResponse._();

  factory ListDeviceServicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDeviceServicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDeviceServicesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..pPM<Service>(1, _omitFieldNames ? '' : 'services',
        subBuilder: Service.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeviceServicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeviceServicesResponse copyWith(
          void Function(ListDeviceServicesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDeviceServicesResponse))
          as ListDeviceServicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeviceServicesResponse create() => ListDeviceServicesResponse._();
  @$core.override
  ListDeviceServicesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDeviceServicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDeviceServicesResponse>(create);
  static ListDeviceServicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Service> get services => $_getList(0);
}

class UpdateServiceRequest extends $pb.GeneratedMessage {
  factory UpdateServiceRequest({
    $core.String? serviceId,
    $core.String? serviceName,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (serviceName != null) result.serviceName = serviceName;
    return result;
  }

  UpdateServiceRequest._();

  factory UpdateServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'serviceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateServiceRequest copyWith(void Function(UpdateServiceRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateServiceRequest))
          as UpdateServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateServiceRequest create() => UpdateServiceRequest._();
  @$core.override
  UpdateServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateServiceRequest>(create);
  static UpdateServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceName() => $_clearField(2);
}

class UpdateServiceResponse extends $pb.GeneratedMessage {
  factory UpdateServiceResponse({
    Service? service,
    $core.String? message,
  }) {
    final result = create();
    if (service != null) result.service = service;
    if (message != null) result.message = message;
    return result;
  }

  UpdateServiceResponse._();

  factory UpdateServiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateServiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateServiceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOM<Service>(1, _omitFieldNames ? '' : 'service',
        subBuilder: Service.create)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateServiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateServiceResponse copyWith(
          void Function(UpdateServiceResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateServiceResponse))
          as UpdateServiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateServiceResponse create() => UpdateServiceResponse._();
  @$core.override
  UpdateServiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateServiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateServiceResponse>(create);
  static UpdateServiceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Service get service => $_getN(0);
  @$pb.TagNumber(1)
  set service(Service value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasService() => $_has(0);
  @$pb.TagNumber(1)
  void clearService() => $_clearField(1);
  @$pb.TagNumber(1)
  Service ensureService() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class DeleteServiceRequest extends $pb.GeneratedMessage {
  factory DeleteServiceRequest({
    $core.String? serviceId,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    return result;
  }

  DeleteServiceRequest._();

  factory DeleteServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteServiceRequest copyWith(void Function(DeleteServiceRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteServiceRequest))
          as DeleteServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteServiceRequest create() => DeleteServiceRequest._();
  @$core.override
  DeleteServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteServiceRequest>(create);
  static DeleteServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);
}

class DeleteServiceResponse extends $pb.GeneratedMessage {
  factory DeleteServiceResponse({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  DeleteServiceResponse._();

  factory DeleteServiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteServiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteServiceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteServiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteServiceResponse copyWith(
          void Function(DeleteServiceResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteServiceResponse))
          as DeleteServiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteServiceResponse create() => DeleteServiceResponse._();
  @$core.override
  DeleteServiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteServiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteServiceResponse>(create);
  static DeleteServiceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class Service extends $pb.GeneratedMessage {
  factory Service({
    $core.String? serviceId,
    $core.String? deviceId,
    $core.String? serviceName,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (deviceId != null) result.deviceId = deviceId;
    if (serviceName != null) result.serviceName = serviceName;
    return result;
  }

  Service._();

  factory Service.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Service.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Service',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.identity'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceId')
    ..aOS(3, _omitFieldNames ? '' : 'serviceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Service clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Service copyWith(void Function(Service) updates) =>
      super.copyWith((message) => updates(message as Service)) as Service;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Service create() => Service._();
  @$core.override
  Service createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Service getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Service>(create);
  static Service? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get serviceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set serviceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServiceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearServiceName() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
