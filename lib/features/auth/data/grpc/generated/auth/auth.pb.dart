// This is a generated file - do not edit.
//
// Generated from auth/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ImapCredentials extends $pb.GeneratedMessage {
  factory ImapCredentials({
    $core.String? username,
    $core.String? password,
    $core.String? host,
    $core.int? port,
    $core.bool? useTls,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    if (host != null) result.host = host;
    if (port != null) result.port = port;
    if (useTls != null) result.useTls = useTls;
    return result;
  }

  ImapCredentials._();

  factory ImapCredentials.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ImapCredentials.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImapCredentials',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'host')
    ..aI(4, _omitFieldNames ? '' : 'port')
    ..aOB(5, _omitFieldNames ? '' : 'useTls')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImapCredentials clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImapCredentials copyWith(void Function(ImapCredentials) updates) =>
      super.copyWith((message) => updates(message as ImapCredentials))
          as ImapCredentials;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImapCredentials create() => ImapCredentials._();
  @$core.override
  ImapCredentials createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ImapCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImapCredentials>(create);
  static ImapCredentials? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get host => $_getSZ(2);
  @$pb.TagNumber(3)
  set host($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHost() => $_has(2);
  @$pb.TagNumber(3)
  void clearHost() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get useTls => $_getBF(4);
  @$pb.TagNumber(5)
  set useTls($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUseTls() => $_has(4);
  @$pb.TagNumber(5)
  void clearUseTls() => $_clearField(5);
}

class ExchangeExternalTokenRequest extends $pb.GeneratedMessage {
  factory ExchangeExternalTokenRequest({
    $core.String? provider,
    $core.String? externalAccessToken,
  }) {
    final result = create();
    if (provider != null) result.provider = provider;
    if (externalAccessToken != null)
      result.externalAccessToken = externalAccessToken;
    return result;
  }

  ExchangeExternalTokenRequest._();

  factory ExchangeExternalTokenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExchangeExternalTokenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExchangeExternalTokenRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provider')
    ..aOS(2, _omitFieldNames ? '' : 'externalAccessToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeExternalTokenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeExternalTokenRequest copyWith(
          void Function(ExchangeExternalTokenRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ExchangeExternalTokenRequest))
          as ExchangeExternalTokenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExchangeExternalTokenRequest create() =>
      ExchangeExternalTokenRequest._();
  @$core.override
  ExchangeExternalTokenRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExchangeExternalTokenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExchangeExternalTokenRequest>(create);
  static ExchangeExternalTokenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get provider => $_getSZ(0);
  @$pb.TagNumber(1)
  set provider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get externalAccessToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set externalAccessToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExternalAccessToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearExternalAccessToken() => $_clearField(2);
}

class ExchangeImapCredentialsRequest extends $pb.GeneratedMessage {
  factory ExchangeImapCredentialsRequest({
    $core.String? provider,
    ImapCredentials? imapCredentials,
  }) {
    final result = create();
    if (provider != null) result.provider = provider;
    if (imapCredentials != null) result.imapCredentials = imapCredentials;
    return result;
  }

  ExchangeImapCredentialsRequest._();

  factory ExchangeImapCredentialsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExchangeImapCredentialsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExchangeImapCredentialsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provider')
    ..aOM<ImapCredentials>(2, _omitFieldNames ? '' : 'imapCredentials',
        subBuilder: ImapCredentials.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeImapCredentialsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeImapCredentialsRequest copyWith(
          void Function(ExchangeImapCredentialsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ExchangeImapCredentialsRequest))
          as ExchangeImapCredentialsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExchangeImapCredentialsRequest create() =>
      ExchangeImapCredentialsRequest._();
  @$core.override
  ExchangeImapCredentialsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExchangeImapCredentialsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExchangeImapCredentialsRequest>(create);
  static ExchangeImapCredentialsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get provider => $_getSZ(0);
  @$pb.TagNumber(1)
  set provider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);

  @$pb.TagNumber(2)
  ImapCredentials get imapCredentials => $_getN(1);
  @$pb.TagNumber(2)
  set imapCredentials(ImapCredentials value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasImapCredentials() => $_has(1);
  @$pb.TagNumber(2)
  void clearImapCredentials() => $_clearField(2);
  @$pb.TagNumber(2)
  ImapCredentials ensureImapCredentials() => $_ensure(1);
}

class RefreshTokensRequest extends $pb.GeneratedMessage {
  factory RefreshTokensRequest({
    $core.String? refreshToken,
  }) {
    final result = create();
    if (refreshToken != null) result.refreshToken = refreshToken;
    return result;
  }

  RefreshTokensRequest._();

  factory RefreshTokensRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefreshTokensRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefreshTokensRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'refreshToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshTokensRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshTokensRequest copyWith(void Function(RefreshTokensRequest) updates) =>
      super.copyWith((message) => updates(message as RefreshTokensRequest))
          as RefreshTokensRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefreshTokensRequest create() => RefreshTokensRequest._();
  @$core.override
  RefreshTokensRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefreshTokensRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefreshTokensRequest>(create);
  static RefreshTokensRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get refreshToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set refreshToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRefreshToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefreshToken() => $_clearField(1);
}

class AuthTokensResponse extends $pb.GeneratedMessage {
  factory AuthTokensResponse({
    $core.bool? success,
    $core.String? message,
    $core.String? userId,
    $core.String? accessToken,
    $core.String? refreshToken,
    $fixnum.Int64? expiresAtEpochSeconds,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (userId != null) result.userId = userId;
    if (accessToken != null) result.accessToken = accessToken;
    if (refreshToken != null) result.refreshToken = refreshToken;
    if (expiresAtEpochSeconds != null)
      result.expiresAtEpochSeconds = expiresAtEpochSeconds;
    return result;
  }

  AuthTokensResponse._();

  factory AuthTokensResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthTokensResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthTokensResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'scomm.auth'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'accessToken')
    ..aOS(5, _omitFieldNames ? '' : 'refreshToken')
    ..aInt64(6, _omitFieldNames ? '' : 'expiresAtEpochSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthTokensResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthTokensResponse copyWith(void Function(AuthTokensResponse) updates) =>
      super.copyWith((message) => updates(message as AuthTokensResponse))
          as AuthTokensResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthTokensResponse create() => AuthTokensResponse._();
  @$core.override
  AuthTokensResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthTokensResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthTokensResponse>(create);
  static AuthTokensResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get accessToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set accessToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccessToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccessToken() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get refreshToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set refreshToken($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRefreshToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearRefreshToken() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expiresAtEpochSeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set expiresAtEpochSeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresAtEpochSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresAtEpochSeconds() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
