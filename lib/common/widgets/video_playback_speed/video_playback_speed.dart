import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

/// Supported playback rates (YouTube-style subset).
///
/// Platforms may not support every value; [apply] still attempts [setPlaybackSpeed]
/// and returns `false` on failure.
abstract final class VideoPlaybackSpeed {
  VideoPlaybackSpeed._();

  static const List<double> supported = [
    0.25,
    0.5,
    1.0,
    1.25,
    1.5,
    2.0,
  ];

  static const double defaultSpeed = 1.0;

  /// Whether [speed] matches a supported step (float-safe).
  static bool isAllowed(double speed) {
    return supported.any((s) => (s - speed).abs() < 0.001);
  }

  /// User-facing label for chips, sheets, and overlays.
  static String label(double speed) {
    if ((speed - 1.0).abs() < 0.001) return 'Normal';
    final s = _trimTrailingZeros(speed);
    return '${s}x';
  }

  /// Speed as plain numbers only (e.g. `0.25`, `1`, `1.5`) for dropdowns.
  static String numericLabel(double speed) {
    return _trimTrailingZeros(speed);
  }

  /// Maps a possibly approximate [current] rate to the nearest [supported] value.
  static double resolveSupported(double current) {
    for (final s in supported) {
      if ((current - s).abs() < 0.001) return s;
    }
    return defaultSpeed;
  }

  static String _trimTrailingZeros(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  /// Applies [speed] only if [controller] is non-null and initialized.
  /// Returns `true` when [VideoPlayerController.setPlaybackSpeed] completes without error.
  static Future<bool> apply(
    VideoPlayerController? controller,
    double speed,
  ) async {
    if (controller == null) return false;
    if (!controller.value.isInitialized) return false;
    if (!isAllowed(speed)) {
      debugPrint('VideoPlaybackSpeed: rejected non-supported speed $speed');
      return false;
    }
    try {
      await controller.setPlaybackSpeed(speed);
      return true;
    } catch (e, st) {
      debugPrint('VideoPlaybackSpeed: setPlaybackSpeed failed: $e\n$st');
      return false;
    }
  }
}
