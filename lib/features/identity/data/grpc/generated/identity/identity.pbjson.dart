// This is a generated file - do not edit.
//
// Generated from identity/identity.proto.

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

@$core.Deprecated('Use deviceModeDescriptor instead')
const DeviceMode$json = {
  '1': 'DeviceMode',
  '2': [
    {'1': 'DEVICE_MODE_UNSPECIFIED', '2': 0},
    {'1': 'CLIENT', '2': 1},
    {'1': 'PROVIDER', '2': 2},
    {'1': 'HYBRID', '2': 3},
  ],
};

/// Descriptor for `DeviceMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deviceModeDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VNb2RlEhsKF0RFVklDRV9NT0RFX1VOU1BFQ0lGSUVEEAASCgoGQ0xJRU5UEAESDA'
    'oIUFJPVklERVIQAhIKCgZIWUJSSUQQAw==');

@$core.Deprecated('Use registerDeviceRequestDescriptor instead')
const RegisterDeviceRequest$json = {
  '1': 'RegisterDeviceRequest',
  '2': [
    {'1': 'device_name', '3': 1, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'device_type', '3': 2, '4': 1, '5': 9, '10': 'deviceType'},
    {
      '1': 'mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.scomm.identity.DeviceMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `RegisterDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerDeviceRequestDescriptor = $convert.base64Decode(
    'ChVSZWdpc3RlckRldmljZVJlcXVlc3QSHwoLZGV2aWNlX25hbWUYASABKAlSCmRldmljZU5hbW'
    'USHwoLZGV2aWNlX3R5cGUYAiABKAlSCmRldmljZVR5cGUSLgoEbW9kZRgDIAEoDjIaLnNjb21t'
    'LmlkZW50aXR5LkRldmljZU1vZGVSBG1vZGU=');

@$core.Deprecated('Use registerDeviceResponseDescriptor instead')
const RegisterDeviceResponse$json = {
  '1': 'RegisterDeviceResponse',
  '2': [
    {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.scomm.identity.Device',
      '10': 'device'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RegisterDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerDeviceResponseDescriptor =
    $convert.base64Decode(
        'ChZSZWdpc3RlckRldmljZVJlc3BvbnNlEi4KBmRldmljZRgBIAEoCzIWLnNjb21tLmlkZW50aX'
        'R5LkRldmljZVIGZGV2aWNlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use updateDeviceRequestDescriptor instead')
const UpdateDeviceRequest$json = {
  '1': 'UpdateDeviceRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'device_name', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'device_type', '3': 3, '4': 1, '5': 9, '10': 'deviceType'},
    {
      '1': 'mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.scomm.identity.DeviceMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `UpdateDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDeviceRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVEZXZpY2VSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSHwoLZG'
    'V2aWNlX25hbWUYAiABKAlSCmRldmljZU5hbWUSHwoLZGV2aWNlX3R5cGUYAyABKAlSCmRldmlj'
    'ZVR5cGUSLgoEbW9kZRgEIAEoDjIaLnNjb21tLmlkZW50aXR5LkRldmljZU1vZGVSBG1vZGU=');

@$core.Deprecated('Use updateDeviceResponseDescriptor instead')
const UpdateDeviceResponse$json = {
  '1': 'UpdateDeviceResponse',
  '2': [
    {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.scomm.identity.Device',
      '10': 'device'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UpdateDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDeviceResponseDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVEZXZpY2VSZXNwb25zZRIuCgZkZXZpY2UYASABKAsyFi5zY29tbS5pZGVudGl0eS'
    '5EZXZpY2VSBmRldmljZRIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use deleteDeviceRequestDescriptor instead')
const DeleteDeviceRequest$json = {
  '1': 'DeleteDeviceRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `DeleteDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteDeviceRequestDescriptor =
    $convert.base64Decode(
        'ChNEZWxldGVEZXZpY2VSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQ=');

@$core.Deprecated('Use deleteDeviceResponseDescriptor instead')
const DeleteDeviceResponse$json = {
  '1': 'DeleteDeviceResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteDeviceResponseDescriptor =
    $convert.base64Decode(
        'ChREZWxldGVEZXZpY2VSZXNwb25zZRIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use listMyDevicesRequestDescriptor instead')
const ListMyDevicesRequest$json = {
  '1': 'ListMyDevicesRequest',
};

/// Descriptor for `ListMyDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMyDevicesRequestDescriptor =
    $convert.base64Decode('ChRMaXN0TXlEZXZpY2VzUmVxdWVzdA==');

@$core.Deprecated('Use listMyDevicesResponseDescriptor instead')
const ListMyDevicesResponse$json = {
  '1': 'ListMyDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.scomm.identity.Device',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `ListMyDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMyDevicesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0TXlEZXZpY2VzUmVzcG9uc2USMAoHZGV2aWNlcxgBIAMoCzIWLnNjb21tLmlkZW50aX'
    'R5LkRldmljZVIHZGV2aWNlcw==');

@$core.Deprecated('Use listUserDevicesRequestDescriptor instead')
const ListUserDevicesRequest$json = {
  '1': 'ListUserDevicesRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ListUserDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserDevicesRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0VXNlckRldmljZXNSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use listUserDevicesResponseDescriptor instead')
const ListUserDevicesResponse$json = {
  '1': 'ListUserDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.scomm.identity.Device',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `ListUserDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserDevicesResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0VXNlckRldmljZXNSZXNwb25zZRIwCgdkZXZpY2VzGAEgAygLMhYuc2NvbW0uaWRlbn'
        'RpdHkuRGV2aWNlUgdkZXZpY2Vz');

@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = {
  '1': 'Device',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'device_name', '3': 3, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'device_type', '3': 4, '4': 1, '5': 9, '10': 'deviceType'},
    {
      '1': 'mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.scomm.identity.DeviceMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode(
    'CgZEZXZpY2USGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIXCgd1c2VyX2lkGAIgASgJUg'
    'Z1c2VySWQSHwoLZGV2aWNlX25hbWUYAyABKAlSCmRldmljZU5hbWUSHwoLZGV2aWNlX3R5cGUY'
    'BCABKAlSCmRldmljZVR5cGUSLgoEbW9kZRgFIAEoDjIaLnNjb21tLmlkZW50aXR5LkRldmljZU'
    '1vZGVSBG1vZGU=');

@$core.Deprecated('Use listAllowUserDevicesRequestDescriptor instead')
const ListAllowUserDevicesRequest$json = {
  '1': 'ListAllowUserDevicesRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `ListAllowUserDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAllowUserDevicesRequestDescriptor =
    $convert.base64Decode(
        'ChtMaXN0QWxsb3dVc2VyRGV2aWNlc1JlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2'
        'VJZA==');

@$core.Deprecated('Use listAllowUserDevicesResponseDescriptor instead')
const ListAllowUserDevicesResponse$json = {
  '1': 'ListAllowUserDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.scomm.identity.Device',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `ListAllowUserDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAllowUserDevicesResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXN0QWxsb3dVc2VyRGV2aWNlc1Jlc3BvbnNlEjAKB2RldmljZXMYASADKAsyFi5zY29tbS'
        '5pZGVudGl0eS5EZXZpY2VSB2RldmljZXM=');

@$core.Deprecated('Use addAllowUserDeviceRequestDescriptor instead')
const AddAllowUserDeviceRequest$json = {
  '1': 'AddAllowUserDeviceRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'state', '3': 3, '4': 1, '5': 9, '10': 'state'},
  ],
};

/// Descriptor for `AddAllowUserDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAllowUserDeviceRequestDescriptor =
    $convert.base64Decode(
        'ChlBZGRBbGxvd1VzZXJEZXZpY2VSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSW'
        'QSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklkEhQKBXN0YXRlGAMgASgJUgVzdGF0ZQ==');

@$core.Deprecated('Use addAllowUserDeviceResponseDescriptor instead')
const AddAllowUserDeviceResponse$json = {
  '1': 'AddAllowUserDeviceResponse',
  '2': [
    {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.scomm.identity.Device',
      '10': 'device'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `AddAllowUserDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAllowUserDeviceResponseDescriptor =
    $convert.base64Decode(
        'ChpBZGRBbGxvd1VzZXJEZXZpY2VSZXNwb25zZRIuCgZkZXZpY2UYASABKAsyFi5zY29tbS5pZG'
        'VudGl0eS5EZXZpY2VSBmRldmljZRIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use removeAllowUserDeviceRequestDescriptor instead')
const RemoveAllowUserDeviceRequest$json = {
  '1': 'RemoveAllowUserDeviceRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `RemoveAllowUserDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeAllowUserDeviceRequestDescriptor =
    $convert.base64Decode(
        'ChxSZW1vdmVBbGxvd1VzZXJEZXZpY2VSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aW'
        'NlSWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklk');

@$core.Deprecated('Use removeAllowUserDeviceResponseDescriptor instead')
const RemoveAllowUserDeviceResponse$json = {
  '1': 'RemoveAllowUserDeviceResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RemoveAllowUserDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeAllowUserDeviceResponseDescriptor =
    $convert.base64Decode(
        'Ch1SZW1vdmVBbGxvd1VzZXJEZXZpY2VSZXNwb25zZRIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYW'
        'dl');

@$core.Deprecated('Use updateAllowUserDeviceRequestDescriptor instead')
const UpdateAllowUserDeviceRequest$json = {
  '1': 'UpdateAllowUserDeviceRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'state', '3': 3, '4': 1, '5': 9, '10': 'state'},
  ],
};

/// Descriptor for `UpdateAllowUserDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAllowUserDeviceRequestDescriptor =
    $convert.base64Decode(
        'ChxVcGRhdGVBbGxvd1VzZXJEZXZpY2VSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aW'
        'NlSWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklkEhQKBXN0YXRlGAMgASgJUgVzdGF0ZQ==');

@$core.Deprecated('Use updateAllowUserDeviceResponseDescriptor instead')
const UpdateAllowUserDeviceResponse$json = {
  '1': 'UpdateAllowUserDeviceResponse',
  '2': [
    {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.scomm.identity.Device',
      '10': 'device'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UpdateAllowUserDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAllowUserDeviceResponseDescriptor =
    $convert.base64Decode(
        'Ch1VcGRhdGVBbGxvd1VzZXJEZXZpY2VSZXNwb25zZRIuCgZkZXZpY2UYASABKAsyFi5zY29tbS'
        '5pZGVudGl0eS5EZXZpY2VSBmRldmljZRIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use registerServiceRequestDescriptor instead')
const RegisterServiceRequest$json = {
  '1': 'RegisterServiceRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'service_name', '3': 2, '4': 1, '5': 9, '10': 'serviceName'},
  ],
};

/// Descriptor for `RegisterServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerServiceRequestDescriptor =
    $convert.base64Decode(
        'ChZSZWdpc3RlclNlcnZpY2VSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSIQ'
        'oMc2VydmljZV9uYW1lGAIgASgJUgtzZXJ2aWNlTmFtZQ==');

@$core.Deprecated('Use registerServiceResponseDescriptor instead')
const RegisterServiceResponse$json = {
  '1': 'RegisterServiceResponse',
  '2': [
    {
      '1': 'service',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.scomm.identity.Service',
      '10': 'service'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RegisterServiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerServiceResponseDescriptor =
    $convert.base64Decode(
        'ChdSZWdpc3RlclNlcnZpY2VSZXNwb25zZRIxCgdzZXJ2aWNlGAEgASgLMhcuc2NvbW0uaWRlbn'
        'RpdHkuU2VydmljZVIHc2VydmljZRIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use listDeviceServicesRequestDescriptor instead')
const ListDeviceServicesRequest$json = {
  '1': 'ListDeviceServicesRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `ListDeviceServicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDeviceServicesRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0RGV2aWNlU2VydmljZXNSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSW'
        'Q=');

@$core.Deprecated('Use listDeviceServicesResponseDescriptor instead')
const ListDeviceServicesResponse$json = {
  '1': 'ListDeviceServicesResponse',
  '2': [
    {
      '1': 'services',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.scomm.identity.Service',
      '10': 'services'
    },
  ],
};

/// Descriptor for `ListDeviceServicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDeviceServicesResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0RGV2aWNlU2VydmljZXNSZXNwb25zZRIzCghzZXJ2aWNlcxgBIAMoCzIXLnNjb21tLm'
        'lkZW50aXR5LlNlcnZpY2VSCHNlcnZpY2Vz');

@$core.Deprecated('Use updateServiceRequestDescriptor instead')
const UpdateServiceRequest$json = {
  '1': 'UpdateServiceRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'service_name', '3': 2, '4': 1, '5': 9, '10': 'serviceName'},
  ],
};

/// Descriptor for `UpdateServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateServiceRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVTZXJ2aWNlUmVxdWVzdBIdCgpzZXJ2aWNlX2lkGAEgASgJUglzZXJ2aWNlSWQSIQ'
    'oMc2VydmljZV9uYW1lGAIgASgJUgtzZXJ2aWNlTmFtZQ==');

@$core.Deprecated('Use updateServiceResponseDescriptor instead')
const UpdateServiceResponse$json = {
  '1': 'UpdateServiceResponse',
  '2': [
    {
      '1': 'service',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.scomm.identity.Service',
      '10': 'service'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UpdateServiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateServiceResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXJ2aWNlUmVzcG9uc2USMQoHc2VydmljZRgBIAEoCzIXLnNjb21tLmlkZW50aX'
    'R5LlNlcnZpY2VSB3NlcnZpY2USGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use deleteServiceRequestDescriptor instead')
const DeleteServiceRequest$json = {
  '1': 'DeleteServiceRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
  ],
};

/// Descriptor for `DeleteServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteServiceRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVTZXJ2aWNlUmVxdWVzdBIdCgpzZXJ2aWNlX2lkGAEgASgJUglzZXJ2aWNlSWQ=');

@$core.Deprecated('Use deleteServiceResponseDescriptor instead')
const DeleteServiceResponse$json = {
  '1': 'DeleteServiceResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteServiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteServiceResponseDescriptor =
    $convert.base64Decode(
        'ChVEZWxldGVTZXJ2aWNlUmVzcG9uc2USGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use serviceDescriptor instead')
const Service$json = {
  '1': 'Service',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'device_id', '3': 2, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'service_name', '3': 3, '4': 1, '5': 9, '10': 'serviceName'},
  ],
};

/// Descriptor for `Service`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceDescriptor = $convert.base64Decode(
    'CgdTZXJ2aWNlEh0KCnNlcnZpY2VfaWQYASABKAlSCXNlcnZpY2VJZBIbCglkZXZpY2VfaWQYAi'
    'ABKAlSCGRldmljZUlkEiEKDHNlcnZpY2VfbmFtZRgDIAEoCVILc2VydmljZU5hbWU=');
