import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/auth_tokens_model.dart';
import 'auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _tokensStorageKey = 'auth_tokens';

  final FlutterSecureStorage  secureStorage;

  const AuthLocalDataSourceImpl({required this.secureStorage});

  String _getUserTokenKey(String userId) => '$_tokensStorageKey$userId';

  @override
  Future<void> saveTokens(AuthTokensModel tokens, String userId) async {
    final payload = jsonEncode(tokens.toJson());
    await secureStorage.write(key: _getUserTokenKey(userId), value: payload);
  }

  @override
  Future<AuthTokensModel?> loadTokens(String userId) async {
    final payload = await secureStorage.read(key: _getUserTokenKey(userId));
    if (payload == null || payload.isEmpty) {
      return null;
    }

    final raw = jsonDecode(payload);
    if (raw is! Map<String, dynamic>) {
      return null;
    }

    return AuthTokensModel.fromJson(raw);
  }

  @override
  Future<String?> getAccessToken(String userId) async {
    final tokens = await loadTokens(userId);
    return tokens?.accessToken;
  }

  @override
  Future<void> clearTokens() async {
    //// This method can be used to clear all tokens for all users if needed
    final keys = await secureStorage.readAll();
    for (final key in keys.keys.where((key) => key.startsWith(_tokensStorageKey))) {
      await secureStorage.delete(key: key);
    }
  }

  @override
  Future<void> clearUserToken(String userId) async {
    await secureStorage.delete(key: _getUserTokenKey(userId));
  }
  
  @override
  Future<String?> getLastUsedUserId() async {
    return secureStorage.read(key: 'last_used_user_id');
  }
  
  @override
  Future<void> saveLastUsedUserId(String userId) {
    return secureStorage.write(key: 'last_used_user_id', value: userId);
  }

  @override
  Future<void> removeLastUsedUserId() {
    return secureStorage.delete(key: 'last_used_user_id');
  }
}
