import 'package:equatable/equatable.dart';

/// Metadata for an encrypted video stored on device.
/// Does not expose key or raw path; used for listing and playback requests.
class EncryptedVideoMetadata extends Equatable {
  const EncryptedVideoMetadata({
    required this.videoId,
    required this.title,
    required this.fileName,
    required this.downloadedAt,
    this.thumbnailUrl,
    this.durationSeconds,
  });

  final String videoId;
  final String title;

  /// Basename of the .bin file (e.g. video_123.bin).
  final String fileName;
  final DateTime downloadedAt;
  final String? thumbnailUrl;
  final int? durationSeconds;

  @override
  List<Object?> get props =>
      [videoId, title, fileName, downloadedAt, thumbnailUrl, durationSeconds];
}
