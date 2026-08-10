import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../errors/custom_exception.dart';

class SecureCache {
  static const FlutterSecureStorage _localStorage = FlutterSecureStorage();

  static Future<void> insertToCache({
    required String key,
    required String value,
  }) async {
    try {
      await _localStorage.write(key: key, value: value);
    } catch (_) {
      throw CacheException();
    }
  }

  static Future<String> getFromCache({required String key}) async {
    try {
      return await _localStorage.read(key: key) ?? '';
    } catch (_) {
      throw CacheException();
    }
  }

  static Future<void> deleteFromCacheByKey({required String key}) async {
    try {
      await _localStorage.delete(key: key);
    } catch (_) {
      throw CacheException();
    }
  }

  static Future<void> deleteFromCache() async {
    try {
      await _localStorage.deleteAll();
    } catch (_) {
      throw CacheException();
    }
  }
}
