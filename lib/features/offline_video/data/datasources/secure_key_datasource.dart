import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:elmotamizon/core/error/offline_video_exceptions.dart';

/// Stores and retrieves the per-user encryption key in secure storage.
/// Key is derived externally (e.g. [KeyDerivationService]) and stored by key id.
abstract class SecureKeyDatasource {
  Future<void> saveEncryptionKey(String keyId, List<int> keyBytes);
  Future<List<int>?> getEncryptionKey(String keyId);
  Future<void> deleteEncryptionKey(String keyId);
}

class SecureKeyDatasourceImpl implements SecureKeyDatasource {
  SecureKeyDatasourceImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;
  static const String _prefix = 'offline_video_key_';

  String _storageKey(String keyId) => '$_prefix$keyId';

  @override
  Future<void> saveEncryptionKey(String keyId, List<int> keyBytes) async {
    try {
      final base64 = base64Encode(keyBytes);
      await _storage.write(key: _storageKey(keyId), value: base64);
    } catch (e, st) {
      throw KeyAccessException('Failed to save encryption key', e);
    }
  }

  @override
  Future<List<int>?> getEncryptionKey(String keyId) async {
    try {
      final value = await _storage.read(key: _storageKey(keyId));
      if (value == null) return null;
      return base64Decode(value);
    } catch (e, st) {
      throw KeyAccessException('Failed to read encryption key', e);
    }
  }

  @override
  Future<void> deleteEncryptionKey(String keyId) async {
    try {
      await _storage.delete(key: _storageKey(keyId));
    } catch (e, st) {
      throw KeyAccessException('Failed to delete encryption key', e);
    }
  }
}
