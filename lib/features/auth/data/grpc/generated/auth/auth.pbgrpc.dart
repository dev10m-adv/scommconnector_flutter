// This is a generated file - do not edit.
//
// Generated from auth/auth.proto.

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

import 'auth.pb.dart' as $0;

export 'auth.pb.dart';

@$pb.GrpcServiceName('scomm.auth.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.AuthTokensResponse> exchangeExternalToken(
    $0.ExchangeExternalTokenRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exchangeExternalToken, request, options: options);
  }

  $grpc.ResponseFuture<$0.AuthTokensResponse> exchangeImapCredentials(
    $0.ExchangeImapCredentialsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exchangeImapCredentials, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.AuthTokensResponse> refreshTokens(
    $0.RefreshTokensRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$refreshTokens, request, options: options);
  }

  // method descriptors

  static final _$exchangeExternalToken = $grpc.ClientMethod<
          $0.ExchangeExternalTokenRequest, $0.AuthTokensResponse>(
      '/scomm.auth.AuthService/ExchangeExternalToken',
      ($0.ExchangeExternalTokenRequest value) => value.writeToBuffer(),
      $0.AuthTokensResponse.fromBuffer);
  static final _$exchangeImapCredentials = $grpc.ClientMethod<
          $0.ExchangeImapCredentialsRequest, $0.AuthTokensResponse>(
      '/scomm.auth.AuthService/ExchangeImapCredentials',
      ($0.ExchangeImapCredentialsRequest value) => value.writeToBuffer(),
      $0.AuthTokensResponse.fromBuffer);
  static final _$refreshTokens =
      $grpc.ClientMethod<$0.RefreshTokensRequest, $0.AuthTokensResponse>(
          '/scomm.auth.AuthService/RefreshTokens',
          ($0.RefreshTokensRequest value) => value.writeToBuffer(),
          $0.AuthTokensResponse.fromBuffer);
}

@$pb.GrpcServiceName('scomm.auth.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'scomm.auth.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ExchangeExternalTokenRequest,
            $0.AuthTokensResponse>(
        'ExchangeExternalToken',
        exchangeExternalToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ExchangeExternalTokenRequest.fromBuffer(value),
        ($0.AuthTokensResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExchangeImapCredentialsRequest,
            $0.AuthTokensResponse>(
        'ExchangeImapCredentials',
        exchangeImapCredentials_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ExchangeImapCredentialsRequest.fromBuffer(value),
        ($0.AuthTokensResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RefreshTokensRequest, $0.AuthTokensResponse>(
            'RefreshTokens',
            refreshTokens_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RefreshTokensRequest.fromBuffer(value),
            ($0.AuthTokensResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.AuthTokensResponse> exchangeExternalToken_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ExchangeExternalTokenRequest> $request) async {
    return exchangeExternalToken($call, await $request);
  }

  $async.Future<$0.AuthTokensResponse> exchangeExternalToken(
      $grpc.ServiceCall call, $0.ExchangeExternalTokenRequest request);

  $async.Future<$0.AuthTokensResponse> exchangeImapCredentials_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ExchangeImapCredentialsRequest> $request) async {
    return exchangeImapCredentials($call, await $request);
  }

  $async.Future<$0.AuthTokensResponse> exchangeImapCredentials(
      $grpc.ServiceCall call, $0.ExchangeImapCredentialsRequest request);

  $async.Future<$0.AuthTokensResponse> refreshTokens_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RefreshTokensRequest> $request) async {
    return refreshTokens($call, await $request);
  }

  $async.Future<$0.AuthTokensResponse> refreshTokens(
      $grpc.ServiceCall call, $0.RefreshTokensRequest request);
}
