import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth_tokens_model.dart';
import 'auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _tokensStorageKey = 'auth_tokens';

  final SharedPreferences  secureStorage;

  const AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    final payload = jsonEncode(tokens.toJson());
    await secureStorage.setString(_tokensStorageKey, payload);
  }

  @override
  Future<AuthTokensModel?> loadTokens() async {
    final payload = secureStorage.getString(_tokensStorageKey);
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
  Future<String?> getAccessToken() async {
    final tokens = await loadTokens();
    return tokens?.accessToken;
  }

  @override
  Future<void> clearTokens() async {
    await secureStorage.remove(_tokensStorageKey);
  }
}
