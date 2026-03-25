// This is a generated file - do not edit.
//
// Generated from auth/auth.proto.

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

@$core.Deprecated('Use imapCredentialsDescriptor instead')
const ImapCredentials$json = {
  '1': 'ImapCredentials',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'host', '3': 3, '4': 1, '5': 9, '10': 'host'},
    {'1': 'port', '3': 4, '4': 1, '5': 5, '10': 'port'},
    {'1': 'use_tls', '3': 5, '4': 1, '5': 8, '10': 'useTls'},
  ],
};

/// Descriptor for `ImapCredentials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imapCredentialsDescriptor = $convert.base64Decode(
    'Cg9JbWFwQ3JlZGVudGlhbHMSGgoIdXNlcm5hbWUYASABKAlSCHVzZXJuYW1lEhoKCHBhc3N3b3'
    'JkGAIgASgJUghwYXNzd29yZBISCgRob3N0GAMgASgJUgRob3N0EhIKBHBvcnQYBCABKAVSBHBv'
    'cnQSFwoHdXNlX3RscxgFIAEoCFIGdXNlVGxz');

@$core.Deprecated('Use exchangeExternalTokenRequestDescriptor instead')
const ExchangeExternalTokenRequest$json = {
  '1': 'ExchangeExternalTokenRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '10': 'provider'},
    {
      '1': 'external_access_token',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'externalAccessToken'
    },
  ],
};

/// Descriptor for `ExchangeExternalTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeExternalTokenRequestDescriptor =
    $convert.base64Decode(
        'ChxFeGNoYW5nZUV4dGVybmFsVG9rZW5SZXF1ZXN0EhoKCHByb3ZpZGVyGAEgASgJUghwcm92aW'
        'RlchIyChVleHRlcm5hbF9hY2Nlc3NfdG9rZW4YAiABKAlSE2V4dGVybmFsQWNjZXNzVG9rZW4=');

@$core.Deprecated('Use exchangeImapCredentialsRequestDescriptor instead')
const ExchangeImapCredentialsRequest$json = {
  '1': 'ExchangeImapCredentialsRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '10': 'provider'},
    {
      '1': 'imap_credentials',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.scomm.auth.ImapCredentials',
      '10': 'imapCredentials'
    },
  ],
};

/// Descriptor for `ExchangeImapCredentialsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeImapCredentialsRequestDescriptor =
    $convert.base64Decode(
        'Ch5FeGNoYW5nZUltYXBDcmVkZW50aWFsc1JlcXVlc3QSGgoIcHJvdmlkZXIYASABKAlSCHByb3'
        'ZpZGVyEkYKEGltYXBfY3JlZGVudGlhbHMYAiABKAsyGy5zY29tbS5hdXRoLkltYXBDcmVkZW50'
        'aWFsc1IPaW1hcENyZWRlbnRpYWxz');

@$core.Deprecated('Use refreshTokensRequestDescriptor instead')
const RefreshTokensRequest$json = {
  '1': 'RefreshTokensRequest',
  '2': [
    {'1': 'refresh_token', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

/// Descriptor for `RefreshTokensRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshTokensRequestDescriptor = $convert.base64Decode(
    'ChRSZWZyZXNoVG9rZW5zUmVxdWVzdBIjCg1yZWZyZXNoX3Rva2VuGAEgASgJUgxyZWZyZXNoVG'
    '9rZW4=');

@$core.Deprecated('Use authTokensResponseDescriptor instead')
const AuthTokensResponse$json = {
  '1': 'AuthTokensResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'access_token', '3': 4, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'refresh_token', '3': 5, '4': 1, '5': 9, '10': 'refreshToken'},
    {
      '1': 'expires_at_epoch_seconds',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'expiresAtEpochSeconds'
    },
  ],
};

/// Descriptor for `AuthTokensResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authTokensResponseDescriptor = $convert.base64Decode(
    'ChJBdXRoVG9rZW5zUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYW'
    'dlGAIgASgJUgdtZXNzYWdlEhcKB3VzZXJfaWQYAyABKAlSBnVzZXJJZBIhCgxhY2Nlc3NfdG9r'
    'ZW4YBCABKAlSC2FjY2Vzc1Rva2VuEiMKDXJlZnJlc2hfdG9rZW4YBSABKAlSDHJlZnJlc2hUb2'
    'tlbhI3ChhleHBpcmVzX2F0X2Vwb2NoX3NlY29uZHMYBiABKANSFWV4cGlyZXNBdEVwb2NoU2Vj'
    'b25kcw==');
