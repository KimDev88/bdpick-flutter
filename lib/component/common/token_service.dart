import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/token.dart';

class TokenService {
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  static const String keyRefresh = 'refreshToken';
  static const String keyAccess = 'accessToken';

  static saveToken(Token token) {
    storage.write(key: keyRefresh, value: token.refreshToken);
    storage.write(key: keyAccess, value: token.accessToken);
  }

  static Future<String?> getRefreshToken() async {
    return await storage.read(key: keyRefresh);
  }

  static Future<String?> getAccessToken() async {
    return await storage.read(key: keyAccess);
  }

  static Future<void> clear() {
    return storage.deleteAll();
  }
}
