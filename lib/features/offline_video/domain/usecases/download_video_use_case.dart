import 'dart:async';

import 'package:elmotamizon/core/error/offline_video_failures.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/download_progress.dart';
import 'package:elmotamizon/features/offline_video/domain/repository/offline_video_repository.dart';

/// Use case: download a video and store it encrypted.
/// Progress is emitted via the returned stream.
abstract class DownloadVideoUseCase {
  /// [progressStream] will receive progress events until download completes.
  /// Returns the local encrypted file path on success.
  Future<String> call(
    DownloadableVideo video,
    StreamController<DownloadProgress> progressSink,
  );
}

class DownloadVideoUseCaseImpl implements DownloadVideoUseCase {
  DownloadVideoUseCaseImpl(this._repository);

  final OfflineVideoRepository _repository;

  @override
  Future<String> call(
    DownloadableVideo video,
    StreamController<DownloadProgress> progressSink,
  ) async {
    return _repository.downloadAndEncrypt(video, progressSink);
  }
}
