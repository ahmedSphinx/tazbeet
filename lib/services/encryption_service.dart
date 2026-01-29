import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptionService {
  static const String _encryptionKeyName = 'hive_encryption_key';
  static final _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future<List<int>> getEncryptionKey() async {
    try {
      // Try to use secure storage first
      String? keyString = await _secureStorage.read(key: _encryptionKeyName);

      if (keyString == null) {
        final key = Hive.generateSecureKey();
        await _secureStorage.write(key: _encryptionKeyName, value: base64UrlEncode(key));
        return key;
      }

      return base64Url.decode(keyString);
    } catch (e) {
      // Fallback to SharedPreferences if secure storage is not available
      print('⚠️ Secure storage not available, falling back to SharedPreferences: $e');
      return _getEncryptionKeyFromPrefs();
    }
  }

  static Future<List<int>> _getEncryptionKeyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? keyString = prefs.getString(_encryptionKeyName);

    if (keyString == null) {
      final key = Hive.generateSecureKey();
      await prefs.setString(_encryptionKeyName, base64UrlEncode(key));
      return key;
    }

    return base64Url.decode(keyString);
  }

  static Future<void> deleteEncryptionKey() async {
    try {
      await _secureStorage.delete(key: _encryptionKeyName);
    } catch (e) {
      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_encryptionKeyName);
    }
  }

  static Future<HiveAesCipher> getCipher() async {
    final key = await getEncryptionKey();
    return HiveAesCipher(key);
  }
}
