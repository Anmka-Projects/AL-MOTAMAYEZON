import 'package:elmotamizon/core/error/offline_video_failures.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';
import 'package:elmotamizon/features/offline_video/domain/repository/offline_video_repository.dart';

/// Use case: list all offline (encrypted) videos for the current user.
abstract class GetOfflineVideosUseCase {
  Future<List<EncryptedVideoMetadata>> call();
}

class GetOfflineVideosUseCaseImpl implements GetOfflineVideosUseCase {
  GetOfflineVideosUseCaseImpl(this._repository);

  final OfflineVideoRepository _repository;

  @override
  Future<List<EncryptedVideoMetadata>> call() {
    return _repository.getOfflineVideos();
  }
}
