import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth_tokens_model.dart';
import 'auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _tokensStorageKey = 'auth_tokens';

  final SharedPreferences  secureStorage;

  const AuthLocalDataSourceImpl({required this.secureStorage});

  String _getUserTokenKey(String userId) => '$_tokensStorageKey$userId';

  @override
  Future<void> saveTokens(AuthTokensModel tokens, String userId) async {
    final payload = jsonEncode(tokens.toJson());
    await secureStorage.setString(_getUserTokenKey(userId), payload);
  }

  @override
  Future<AuthTokensModel?> loadTokens(String userId) async {
    final payload = secureStorage.getString(_getUserTokenKey(userId));
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
    final keys = secureStorage.getKeys().where((key) => key.startsWith(_tokensStorageKey));
    for (final key in keys) {
      await secureStorage.remove(key);
    }
  }

  @override
  Future<void> clearUserToken(String userId) async {
    await secureStorage.remove(_getUserTokenKey(userId));
  }
}
