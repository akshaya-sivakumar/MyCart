import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CartSecureStore {
  static const _secureStore = FlutterSecureStorage();
  static const String userName = 'userName';

  static const String profile = 'profile';
  static const String userId = 'userId';
  static Future<void> setSecureStore(String key, var data) async {
    await _secureStore.write(key: key, value: data);
  }

  static Future<String> getSecureStore(String key) async {
    return await _secureStore.read(key: key) ?? "";
  }

  static Future<void> deleteSecureStore(String key) async {
    await _secureStore.delete(key: key);
  }
}
