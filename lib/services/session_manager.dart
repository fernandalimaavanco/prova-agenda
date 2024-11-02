import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'user_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'user_token');
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'user_token');
  }
}
