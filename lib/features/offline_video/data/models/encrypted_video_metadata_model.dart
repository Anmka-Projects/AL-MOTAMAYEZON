import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';

/// Data model for stored metadata (e.g. from JSON file or DB).
class EncryptedVideoMetadataModel extends EncryptedVideoMetadata {
  const EncryptedVideoMetadataModel({
    required super.videoId,
    required super.title,
    required super.fileName,
    required super.downloadedAt,
    super.thumbnailUrl,
    super.durationSeconds,
  });

  factory EncryptedVideoMetadataModel.fromEntity(
      EncryptedVideoMetadata entity) {
    return EncryptedVideoMetadataModel(
      videoId: entity.videoId,
      title: entity.title,
      fileName: entity.fileName,
      downloadedAt: entity.downloadedAt,
      thumbnailUrl: entity.thumbnailUrl,
      durationSeconds: entity.durationSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
        'videoId': videoId,
        'title': title,
        'fileName': fileName,
        'downloadedAt': downloadedAt.toIso8601String(),
        'thumbnailUrl': thumbnailUrl,
        'durationSeconds': durationSeconds,
      };

  factory EncryptedVideoMetadataModel.fromJson(Map<String, dynamic> json) {
    return EncryptedVideoMetadataModel(
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      fileName: json['fileName'] as String,
      downloadedAt: DateTime.parse(json['downloadedAt'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      durationSeconds: json['durationSeconds'] as int?,
    );
  }
}
