import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elmotamizon/core/error/offline_video_failures.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/download_progress.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';
import 'package:elmotamizon/features/offline_video/domain/usecases/delete_offline_video_use_case.dart';
import 'package:elmotamizon/features/offline_video/domain/usecases/download_video_use_case.dart';
import 'package:elmotamizon/features/offline_video/domain/usecases/get_offline_videos_use_case.dart';
import 'package:elmotamizon/features/offline_video/domain/usecases/is_video_downloaded_use_case.dart';
import 'package:elmotamizon/features/offline_video/domain/usecases/play_offline_video_use_case.dart';
import 'package:elmotamizon/features/offline_video/presentation/cubit/offline_video_state.dart';

/// Cubit for offline video list, download progress, and playback preparation.
class OfflineVideoCubit extends Cubit<OfflineVideoState> {
  OfflineVideoCubit({
    required GetOfflineVideosUseCase getOfflineVideosUseCase,
    required DownloadVideoUseCase downloadVideoUseCase,
    required PlayOfflineVideoUseCase playOfflineVideoUseCase,
    required DeleteOfflineVideoUseCase deleteOfflineVideoUseCase,
    required IsVideoDownloadedUseCase isVideoDownloadedUseCase,
  })  : _getOfflineVideos = getOfflineVideosUseCase,
        _downloadVideo = downloadVideoUseCase,
        _playOfflineVideo = playOfflineVideoUseCase,
        _deleteOfflineVideo = deleteOfflineVideoUseCase,
        _isVideoDownloaded = isVideoDownloadedUseCase,
        super(const OfflineVideoInitial());

  final GetOfflineVideosUseCase _getOfflineVideos;
  final DownloadVideoUseCase _downloadVideo;
  final PlayOfflineVideoUseCase _playOfflineVideo;
  final DeleteOfflineVideoUseCase _deleteOfflineVideo;
  final IsVideoDownloadedUseCase _isVideoDownloaded;

  StreamSubscription<DownloadProgress>? _progressSubscription;

  /// Loads the list of offline videos.
  Future<void> loadOfflineVideos() async {
    emit(const OfflineVideoInitial());
    try {
      final videos = await _getOfflineVideos();
      emit(OfflineVideoLoaded(videos));
    } on OfflineVideoFailure catch (e) {
      emit(OfflineVideoError(e));
    }
  }

  /// Starts downloading [video]. Progress is emitted via state [OfflineVideoDownloading].
  /// On success, transitions to [OfflineVideoDownloadCompleted] and refreshes list.
  Future<void> downloadVideo(DownloadableVideo video) async {
    final progressController = StreamController<DownloadProgress>.broadcast();
    _progressSubscription = progressController.stream.listen((progress) {
      if (isClosed) return;
      final current = state;
      final videos = current is OfflineVideoLoaded
          ? current.videos
          : <EncryptedVideoMetadata>[];
      emit(OfflineVideoDownloading(
          videoId: video.videoId, progress: progress, videos: videos));
    });

    try {
      await _downloadVideo(video, progressController);
      await _progressSubscription?.cancel();
      _progressSubscription = null;
      progressController.close();
      final list = await _getOfflineVideos();
      emit(OfflineVideoDownloadCompleted(videoId: video.videoId, videos: list));
    } on OfflineVideoFailure catch (e) {
      await _progressSubscription?.cancel();
      _progressSubscription = null;
      progressController.close();
      emit(OfflineVideoError(e));
    }
  }

  /// Prepares a decrypted temp file for [metadata] and returns its path.
  /// Caller must delete the file after playback.
  Future<String> preparePlaybackPath(EncryptedVideoMetadata metadata) async {
    return _playOfflineVideo(metadata);
  }

  /// Deletes the offline video for [videoId] and refreshes the list.
  Future<void> deleteOfflineVideo(String videoId) async {
    try {
      await _deleteOfflineVideo(videoId);
      final videos = await _getOfflineVideos();
      emit(OfflineVideoLoaded(videos));
    } on OfflineVideoFailure catch (e) {
      emit(OfflineVideoError(e));
    }
  }

  /// Returns whether the video is already downloaded.
  Future<bool> isVideoDownloaded(String videoId) async {
    return _isVideoDownloaded(videoId);
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    return super.close();
  }
}
