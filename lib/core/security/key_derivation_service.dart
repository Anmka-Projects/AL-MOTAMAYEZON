import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Derives a deterministic 256-bit key from user id and a secret salt.
/// Used for per-user encryption so keys are reproducible for the same user
/// but unique across users.
///
/// Key = SHA256(userId + secretSalt) → 32 bytes for AES-256.
class KeyDerivationService {
  KeyDerivationService({
    required this.secretSalt,
  });

  /// Application-specific salt. In production, consider fetching from
  /// secure backend or build-time injection. Must be kept secret.
  final String secretSalt;

  /// Derives a 32-byte key suitable for AES-256.
  /// [userId] uniquely identifies the user (e.g. from auth).
  List<int> deriveKey(String userId) {
    final input = utf8.encode('$userId$secretSalt');
    final digest = sha256.convert(input);
    return digest.bytes;
  }
}
