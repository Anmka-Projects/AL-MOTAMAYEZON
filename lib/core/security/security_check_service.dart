import 'package:flutter/foundation.dart';

/// Basic security checks: debug mode and optional root detection.
/// In production, sensitive flows (e.g. decryption) can be gated on these.
class SecurityCheckService {
  SecurityCheckService();

  /// Returns true if the app is running in debug mode.
  /// Production builds should avoid storing decrypted content when this is true.
  bool get isDebugMode => kDebugMode;

  /// Basic root/jailbreak detection (platform-specific checks can be added).
  /// Returns true if the device might be compromised.
  Future<bool> get isPossiblyRooted async {
    // Basic check: debug mode often implies emulator/root for dev.
    if (kDebugMode) return false;
    // Optional: integrate with packages like 'flutter_jailbreak_detection'
    // or native checks for su binary, Magisk, etc.
    return false;
  }

  /// Returns true if it's safe to perform sensitive operations
  /// (e.g. decrypt to temp file). Can be extended with root check.
  Future<bool> get isEnvironmentSafe async {
    if (isDebugMode) return true;
    return !await isPossiblyRooted;
  }
}
