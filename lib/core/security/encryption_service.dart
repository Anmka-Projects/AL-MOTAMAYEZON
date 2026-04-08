import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;

/// AES-256-CBC encryption/decryption with random IV per operation.
/// IV is prepended to ciphertext so decryption can recover it.
class EncryptionService {
  EncryptionService();

  static const int _ivLength = 16;

  /// Encrypts [plainBytes] with [key] (must be 32 bytes for AES-256).
  /// Returns: IV (16 bytes) + ciphertext. Caller must store entire result.
  Uint8List encrypt(Uint8List plainBytes, List<int> key) {
    final iv = enc.IV.fromLength(16);
    final encKey = enc.Key(Uint8List.fromList(key));
    final encrypter = enc.Encrypter(enc.AES(encKey));
    final encrypted = encrypter.encryptBytes(plainBytes, iv: iv);
    final out = Uint8List(_ivLength + encrypted.bytes.length);
    out.setRange(0, _ivLength, iv.bytes);
    out.setRange(_ivLength, out.length, encrypted.bytes);
    return out;
  }

  /// Decrypts [cipherBytes] (IV + ciphertext) with [key].
  /// [cipherBytes] must be at least 16 bytes (IV).
  Uint8List decrypt(Uint8List cipherBytes, List<int> key) {
    if (cipherBytes.length < _ivLength) {
      throw ArgumentError('Cipher bytes too short for IV');
    }
    final iv = enc.IV(cipherBytes.sublist(0, _ivLength));
    final encKey = enc.Key(Uint8List.fromList(key));
    final encrypter = enc.Encrypter(enc.AES(encKey));
    final encrypted = enc.Encrypted(cipherBytes.sublist(_ivLength));
    return Uint8List.fromList(
      encrypter.decryptBytes(encrypted, iv: iv),
    );
  }
}
