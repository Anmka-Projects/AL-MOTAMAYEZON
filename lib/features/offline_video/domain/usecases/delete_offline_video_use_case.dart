import 'package:elmotamizon/core/error/offline_video_failures.dart';
import 'package:elmotamizon/features/offline_video/domain/repository/offline_video_repository.dart';

/// Use case: delete an offline video (encrypted file + metadata).
abstract class DeleteOfflineVideoUseCase {
  Future<void> call(String videoId);
}

class DeleteOfflineVideoUseCaseImpl implements DeleteOfflineVideoUseCase {
  DeleteOfflineVideoUseCaseImpl(this._repository);

  final OfflineVideoRepository _repository;

  @override
  Future<void> call(String videoId) {
    return _repository.deleteOfflineVideo(videoId);
  }
}
