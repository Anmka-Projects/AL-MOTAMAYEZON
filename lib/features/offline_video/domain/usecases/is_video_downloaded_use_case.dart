import 'package:elmotamizon/features/offline_video/domain/repository/offline_video_repository.dart';

/// Use case: check if a video is already downloaded for offline use.
abstract class IsVideoDownloadedUseCase {
  Future<bool> call(String videoId);
}

class IsVideoDownloadedUseCaseImpl implements IsVideoDownloadedUseCase {
  IsVideoDownloadedUseCaseImpl(this._repository);

  final OfflineVideoRepository _repository;

  @override
  Future<bool> call(String videoId) {
    return _repository.isVideoDownloaded(videoId);
  }
}
