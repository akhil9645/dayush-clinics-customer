import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> storeToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: 'refreshtoken', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshtoken');
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refreshtoken');
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
