import 'package:elmotamizon/core/error/offline_video_failures.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';
import 'package:elmotamizon/features/offline_video/domain/repository/offline_video_repository.dart';

/// Use case: prepare a decrypted temporary file for playback.
/// Caller is responsible for deleting the temp file after playback (e.g. on dispose).
abstract class PlayOfflineVideoUseCase {
  /// Returns the path to a temporary decrypted video file.
  Future<String> call(EncryptedVideoMetadata metadata);
}

class PlayOfflineVideoUseCaseImpl implements PlayOfflineVideoUseCase {
  PlayOfflineVideoUseCaseImpl(this._repository);

  final OfflineVideoRepository _repository;

  @override
  Future<String> call(EncryptedVideoMetadata metadata) {
    return _repository.prepareDecryptedTempFile(metadata);
  }
}
