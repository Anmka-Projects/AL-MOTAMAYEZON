import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';

/// Data model for [DownloadableVideo]. Can add fromJson/toJson if needed for API.
class DownloadableVideoModel extends DownloadableVideo {
  const DownloadableVideoModel({
    required super.videoId,
    required super.downloadUrl,
    required super.title,
    super.thumbnailUrl,
    super.durationSeconds,
  });

  factory DownloadableVideoModel.fromEntity(DownloadableVideo entity) {
    return DownloadableVideoModel(
      videoId: entity.videoId,
      downloadUrl: entity.downloadUrl,
      title: entity.title,
      thumbnailUrl: entity.thumbnailUrl,
      durationSeconds: entity.durationSeconds,
    );
  }
}
