class AppConstants {
  static const String baseUrl = 'https://almutamayizun.anmka.com/api';
  static const Duration apiTimeOut = Duration(milliseconds: 60000);
  static const int splashDelay = 5;

  /// Salt for per-user offline video encryption key derivation. Keep secret.
  /// In production consider fetching from backend or remote config.
  static const String offlineVideoEncryptionSalt =
      'elmotamizon_offline_video_salt_v1';
}
