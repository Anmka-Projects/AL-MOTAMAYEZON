import 'package:equatable/equatable.dart';

import 'package:elmotamizon/core/error/offline_video_failures.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/download_progress.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';

/// UI state for offline videos list and download progress.
sealed class OfflineVideoState extends Equatable {
  const OfflineVideoState();

  @override
  List<Object?> get props => [];
}

/// Initial / loading list.
class OfflineVideoInitial extends OfflineVideoState {
  const OfflineVideoInitial();
}

/// List of offline videos loaded.
class OfflineVideoLoaded extends OfflineVideoState {
  const OfflineVideoLoaded(this.videos);

  final List<EncryptedVideoMetadata> videos;

  @override
  List<Object?> get props => [videos];
}

/// A download is in progress for [videoId]; [progress] is the latest progress.
class OfflineVideoDownloading extends OfflineVideoState {
  const OfflineVideoDownloading({
    required this.videoId,
    required this.progress,
    this.videos = const [],
  });

  final String videoId;
  final DownloadProgress progress;
  final List<EncryptedVideoMetadata> videos;

  @override
  List<Object?> get props => [videoId, progress, videos];
}

/// Download completed for [videoId]; updated [videos] list.
class OfflineVideoDownloadCompleted extends OfflineVideoState {
  const OfflineVideoDownloadCompleted({
    required this.videoId,
    required this.videos,
  });

  final String videoId;
  final List<EncryptedVideoMetadata> videos;

  @override
  List<Object?> get props => [videoId, videos];
}

/// Operation failed.
class OfflineVideoError extends OfflineVideoState {
  const OfflineVideoError(this.failure);

  final OfflineVideoFailure failure;

  @override
  List<Object?> get props => [failure];
}
