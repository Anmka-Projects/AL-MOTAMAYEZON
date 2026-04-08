import 'package:equatable/equatable.dart';

/// Represents a video that can be downloaded for offline viewing.
/// [videoId] is the unique identifier; [downloadUrl] is the source URL.
class DownloadableVideo extends Equatable {
  const DownloadableVideo({
    required this.videoId,
    required this.downloadUrl,
    required this.title,
    this.thumbnailUrl,
    this.durationSeconds,
  });

  final String videoId;
  final String downloadUrl;
  final String title;
  final String? thumbnailUrl;
  final int? durationSeconds;

  @override
  List<Object?> get props =>
      [videoId, downloadUrl, title, thumbnailUrl, durationSeconds];
}
