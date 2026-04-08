import 'dart:async';

import 'package:elmotamizon/core/error/offline_video_failures.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/download_progress.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';

/// Repository contract for offline encrypted video operations.
/// All storage is under application support directory; files are encrypted.
abstract class OfflineVideoRepository {
  /// Downloads [video] as bytes, encrypts, and stores under current user.
  /// Progress is emitted via the returned stream.
  /// Returns path to the stored .bin file on success.
  Future<String> downloadAndEncrypt(
    DownloadableVideo video,
    StreamController<DownloadProgress> progressSink,
  );

  /// Returns metadata of all offline videos for the current user.
  Future<List<EncryptedVideoMetadata>> getOfflineVideos();

  /// Decrypts the video identified by [metadata] to a temporary file and
  /// returns its path. Caller must delete the temp file after playback.
  Future<String> prepareDecryptedTempFile(EncryptedVideoMetadata metadata);

  /// Deletes the encrypted file and any associated metadata for [videoId].
  Future<void> deleteOfflineVideo(String videoId);

  /// Returns true if a downloaded file exists for [videoId].
  Future<bool> isVideoDownloaded(String videoId);
}
