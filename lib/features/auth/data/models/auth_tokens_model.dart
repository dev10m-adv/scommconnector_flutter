import '../../domain/entities/auth_tokens.dart';

class AuthTokensModel {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final expiresAtRaw = json['expiresAt'];
    DateTime? expiresAt;

    if (expiresAtRaw is String && expiresAtRaw.isNotEmpty) {
      expiresAt = DateTime.tryParse(expiresAtRaw);
    }

    return AuthTokensModel(
      accessToken: (json['accessToken'] ?? '') as String,
      refreshToken: (json['refreshToken'] ?? '') as String,
      expiresAt: expiresAt,
    );
  }

  factory AuthTokensModel.fromEntity(AuthTokens entity) {
    return AuthTokensModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresAt: entity.expiresAt,
    );
  }

  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}
