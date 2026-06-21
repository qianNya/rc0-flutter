import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStore {
  TokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _expiresAtKey = 'expires_at';

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<DateTime?> getExpiresAt() async {
    final raw = await _storage.read(key: _expiresAtKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    int? expiresInSeconds,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    if (expiresInSeconds != null && expiresInSeconds > 0) {
      final expiresAt = DateTime.now().toUtc().add(
        Duration(seconds: expiresInSeconds),
      );
      await _storage.write(
        key: _expiresAtKey,
        value: expiresAt.toIso8601String(),
      );
    }
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _expiresAtKey);
  }
}
