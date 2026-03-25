// This is a generated file - do not edit.
//
// Generated from identity/identity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'identity.pb.dart' as $0;

export 'identity.pb.dart';

@$pb.GrpcServiceName('scomm.identity.IdentityService')
class IdentityServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  IdentityServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RegisterDeviceResponse> registerDevice(
    $0.RegisterDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateDeviceResponse> updateDevice(
    $0.UpdateDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteDeviceResponse> deleteDevice(
    $0.DeleteDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListMyDevicesResponse> listMyDevices(
    $0.ListMyDevicesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMyDevices, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListUserDevicesResponse> listUserDevices(
    $0.ListUserDevicesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listUserDevices, request, options: options);
  }

  $grpc.ResponseFuture<$0.RegisterServiceResponse> registerService(
    $0.RegisterServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerService, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListDeviceServicesResponse> listDeviceServices(
    $0.ListDeviceServicesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listDeviceServices, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateServiceResponse> updateService(
    $0.UpdateServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateService, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteServiceResponse> deleteService(
    $0.DeleteServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteService, request, options: options);
  }

  // method descriptors

  static final _$registerDevice =
      $grpc.ClientMethod<$0.RegisterDeviceRequest, $0.RegisterDeviceResponse>(
          '/scomm.identity.IdentityService/RegisterDevice',
          ($0.RegisterDeviceRequest value) => value.writeToBuffer(),
          $0.RegisterDeviceResponse.fromBuffer);
  static final _$updateDevice =
      $grpc.ClientMethod<$0.UpdateDeviceRequest, $0.UpdateDeviceResponse>(
          '/scomm.identity.IdentityService/UpdateDevice',
          ($0.UpdateDeviceRequest value) => value.writeToBuffer(),
          $0.UpdateDeviceResponse.fromBuffer);
  static final _$deleteDevice =
      $grpc.ClientMethod<$0.DeleteDeviceRequest, $0.DeleteDeviceResponse>(
          '/scomm.identity.IdentityService/DeleteDevice',
          ($0.DeleteDeviceRequest value) => value.writeToBuffer(),
          $0.DeleteDeviceResponse.fromBuffer);
  static final _$listMyDevices =
      $grpc.ClientMethod<$0.ListMyDevicesRequest, $0.ListMyDevicesResponse>(
          '/scomm.identity.IdentityService/ListMyDevices',
          ($0.ListMyDevicesRequest value) => value.writeToBuffer(),
          $0.ListMyDevicesResponse.fromBuffer);
  static final _$listUserDevices =
      $grpc.ClientMethod<$0.ListUserDevicesRequest, $0.ListUserDevicesResponse>(
          '/scomm.identity.IdentityService/ListUserDevices',
          ($0.ListUserDevicesRequest value) => value.writeToBuffer(),
          $0.ListUserDevicesResponse.fromBuffer);
  static final _$registerService =
      $grpc.ClientMethod<$0.RegisterServiceRequest, $0.RegisterServiceResponse>(
          '/scomm.identity.IdentityService/RegisterService',
          ($0.RegisterServiceRequest value) => value.writeToBuffer(),
          $0.RegisterServiceResponse.fromBuffer);
  static final _$listDeviceServices = $grpc.ClientMethod<
          $0.ListDeviceServicesRequest, $0.ListDeviceServicesResponse>(
      '/scomm.identity.IdentityService/ListDeviceServices',
      ($0.ListDeviceServicesRequest value) => value.writeToBuffer(),
      $0.ListDeviceServicesResponse.fromBuffer);
  static final _$updateService =
      $grpc.ClientMethod<$0.UpdateServiceRequest, $0.UpdateServiceResponse>(
          '/scomm.identity.IdentityService/UpdateService',
          ($0.UpdateServiceRequest value) => value.writeToBuffer(),
          $0.UpdateServiceResponse.fromBuffer);
  static final _$deleteService =
      $grpc.ClientMethod<$0.DeleteServiceRequest, $0.DeleteServiceResponse>(
          '/scomm.identity.IdentityService/DeleteService',
          ($0.DeleteServiceRequest value) => value.writeToBuffer(),
          $0.DeleteServiceResponse.fromBuffer);
}

@$pb.GrpcServiceName('scomm.identity.IdentityService')
abstract class IdentityServiceBase extends $grpc.Service {
  $core.String get $name => 'scomm.identity.IdentityService';

  IdentityServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterDeviceRequest,
            $0.RegisterDeviceResponse>(
        'RegisterDevice',
        registerDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterDeviceRequest.fromBuffer(value),
        ($0.RegisterDeviceResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateDeviceRequest, $0.UpdateDeviceResponse>(
            'UpdateDevice',
            updateDevice_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateDeviceRequest.fromBuffer(value),
            ($0.UpdateDeviceResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteDeviceRequest, $0.DeleteDeviceResponse>(
            'DeleteDevice',
            deleteDevice_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteDeviceRequest.fromBuffer(value),
            ($0.DeleteDeviceResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListMyDevicesRequest, $0.ListMyDevicesResponse>(
            'ListMyDevices',
            listMyDevices_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListMyDevicesRequest.fromBuffer(value),
            ($0.ListMyDevicesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListUserDevicesRequest,
            $0.ListUserDevicesResponse>(
        'ListUserDevices',
        listUserDevices_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListUserDevicesRequest.fromBuffer(value),
        ($0.ListUserDevicesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RegisterServiceRequest,
            $0.RegisterServiceResponse>(
        'RegisterService',
        registerService_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RegisterServiceRequest.fromBuffer(value),
        ($0.RegisterServiceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListDeviceServicesRequest,
            $0.ListDeviceServicesResponse>(
        'ListDeviceServices',
        listDeviceServices_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListDeviceServicesRequest.fromBuffer(value),
        ($0.ListDeviceServicesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateServiceRequest, $0.UpdateServiceResponse>(
            'UpdateService',
            updateService_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateServiceRequest.fromBuffer(value),
            ($0.UpdateServiceResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteServiceRequest, $0.DeleteServiceResponse>(
            'DeleteService',
            deleteService_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteServiceRequest.fromBuffer(value),
            ($0.DeleteServiceResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterDeviceResponse> registerDevice_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RegisterDeviceRequest> $request) async {
    return registerDevice($call, await $request);
  }

  $async.Future<$0.RegisterDeviceResponse> registerDevice(
      $grpc.ServiceCall call, $0.RegisterDeviceRequest request);

  $async.Future<$0.UpdateDeviceResponse> updateDevice_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateDeviceRequest> $request) async {
    return updateDevice($call, await $request);
  }

  $async.Future<$0.UpdateDeviceResponse> updateDevice(
      $grpc.ServiceCall call, $0.UpdateDeviceRequest request);

  $async.Future<$0.DeleteDeviceResponse> deleteDevice_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteDeviceRequest> $request) async {
    return deleteDevice($call, await $request);
  }

  $async.Future<$0.DeleteDeviceResponse> deleteDevice(
      $grpc.ServiceCall call, $0.DeleteDeviceRequest request);

  $async.Future<$0.ListMyDevicesResponse> listMyDevices_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListMyDevicesRequest> $request) async {
    return listMyDevices($call, await $request);
  }

  $async.Future<$0.ListMyDevicesResponse> listMyDevices(
      $grpc.ServiceCall call, $0.ListMyDevicesRequest request);

  $async.Future<$0.ListUserDevicesResponse> listUserDevices_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListUserDevicesRequest> $request) async {
    return listUserDevices($call, await $request);
  }

  $async.Future<$0.ListUserDevicesResponse> listUserDevices(
      $grpc.ServiceCall call, $0.ListUserDevicesRequest request);

  $async.Future<$0.RegisterServiceResponse> registerService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RegisterServiceRequest> $request) async {
    return registerService($call, await $request);
  }

  $async.Future<$0.RegisterServiceResponse> registerService(
      $grpc.ServiceCall call, $0.RegisterServiceRequest request);

  $async.Future<$0.ListDeviceServicesResponse> listDeviceServices_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListDeviceServicesRequest> $request) async {
    return listDeviceServices($call, await $request);
  }

  $async.Future<$0.ListDeviceServicesResponse> listDeviceServices(
      $grpc.ServiceCall call, $0.ListDeviceServicesRequest request);

  $async.Future<$0.UpdateServiceResponse> updateService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateServiceRequest> $request) async {
    return updateService($call, await $request);
  }

  $async.Future<$0.UpdateServiceResponse> updateService(
      $grpc.ServiceCall call, $0.UpdateServiceRequest request);

  $async.Future<$0.DeleteServiceResponse> deleteService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteServiceRequest> $request) async {
    return deleteService($call, await $request);
  }

  $async.Future<$0.DeleteServiceResponse> deleteService(
      $grpc.ServiceCall call, $0.DeleteServiceRequest request);
}
