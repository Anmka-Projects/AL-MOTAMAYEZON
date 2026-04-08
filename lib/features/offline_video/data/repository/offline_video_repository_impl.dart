import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:elmotamizon/core/error/offline_video_exceptions.dart';
import 'package:elmotamizon/core/error/offline_video_failures.dart';
import 'package:elmotamizon/core/security/encryption_service.dart';
import 'package:elmotamizon/core/security/key_derivation_service.dart';
import 'package:elmotamizon/core/security/security_check_service.dart';
import 'package:elmotamizon/features/offline_video/data/datasources/local_encrypted_video_datasource.dart';
import 'package:elmotamizon/features/offline_video/data/datasources/remote_video_download_datasource.dart';
import 'package:elmotamizon/features/offline_video/data/datasources/secure_key_datasource.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/download_progress.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';
import 'package:elmotamizon/features/offline_video/domain/repository/offline_video_repository.dart';

/// Implementation of [OfflineVideoRepository]: download → encrypt → store;
/// list; prepare decrypted temp file for playback; delete.
class OfflineVideoRepositoryImpl implements OfflineVideoRepository {
  OfflineVideoRepositoryImpl({
    required RemoteVideoDownloadDatasource remoteDownload,
    required LocalEncryptedVideoDatasource localStorage,
    required SecureKeyDatasource secureKey,
    required KeyDerivationService keyDerivation,
    required EncryptionService encryption,
    required SecurityCheckService securityCheck,
    required String userId,
  })  : _remoteDownload = remoteDownload,
        _localStorage = localStorage,
        _secureKey = secureKey,
        _keyDerivation = keyDerivation,
        _encryption = encryption,
        _securityCheck = securityCheck,
        _userId = userId;

  final RemoteVideoDownloadDatasource _remoteDownload;
  final LocalEncryptedVideoDatasource _localStorage;
  final SecureKeyDatasource _secureKey;
  final KeyDerivationService _keyDerivation;
  final EncryptionService _encryption;
  final SecurityCheckService _securityCheck;
  final String _userId;

  static const String _keyId = 'offline_video_user_key';

  Future<List<int>> _getOrCreateUserKey() async {
    var key = await _secureKey.getEncryptionKey(_keyId);
    if (key == null || key.length != 32) {
      key = _keyDerivation.deriveKey(_userId);
      await _secureKey.saveEncryptionKey(_keyId, key);
    }
    return key;
  }

  @override
  Future<String> downloadAndEncrypt(
    DownloadableVideo video,
    StreamController<DownloadProgress> progressSink,
  ) async {
    try {
      final bytes = await _remoteDownload.downloadAsBytes(video, progressSink);
      final key = await _getOrCreateUserKey();
      final encrypted = _encryption.encrypt(
        Uint8List.fromList(bytes),
        key,
      );
      final fileName = 'video_${video.videoId}.bin';
      final path = await _localStorage.saveEncryptedFile(fileName, encrypted);
      final metadata = EncryptedVideoMetadata(
        videoId: video.videoId,
        title: video.title,
        fileName: fileName,
        downloadedAt: DateTime.now().toUtc(),
        thumbnailUrl: video.thumbnailUrl,
        durationSeconds: video.durationSeconds,
      );
      await _localStorage.saveMetadata(metadata);
      return path;
    } on OfflineVideoException catch (e) {
      if (e is DownloadException) throw DownloadFailure(message: e.message);
      if (e is StorageException) throw StorageFailure(message: e.message);
      if (e is KeyAccessException) throw KeyAccessFailure(message: e.message);
      rethrow;
    }
  }

  @override
  Future<List<EncryptedVideoMetadata>> getOfflineVideos() async {
    try {
      return await _localStorage.listEncryptedVideos();
    } on OfflineVideoException catch (e) {
      throw StorageFailure(message: e.message);
    }
  }

  @override
  Future<String> prepareDecryptedTempFile(
      EncryptedVideoMetadata metadata) async {
    final safe = await _securityCheck.isEnvironmentSafe;
    if (!safe) {
      throw SecurityCheckFailure(message: 'Environment not safe for playback');
    }
    try {
      final key = await _secureKey.getEncryptionKey(_keyId);
      if (key == null) throw KeyAccessFailure(message: 'No encryption key');
      final cipherBytes =
          await _localStorage.readEncryptedFile(metadata.fileName);
      Uint8List plainBytes;
      try {
        plainBytes = _encryption.decrypt(
          Uint8List.fromList(cipherBytes),
          key,
        );
      } catch (e) {
        throw DecryptionException('Decryption failed', e);
      }
      final tempDir = await getTemporaryDirectory();
      final tempFileName =
          'playback_${metadata.videoId}_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final tempFile = File(p.join(tempDir.path, tempFileName));
      await tempFile.writeAsBytes(plainBytes);
      return tempFile.path;
    } on OfflineVideoException catch (e) {
      if (e is DecryptionException) throw DecryptionFailure(message: e.message);
      if (e is KeyAccessException) throw KeyAccessFailure(message: e.message);
      if (e is StorageException) throw StorageFailure(message: e.message);
      rethrow;
    }
  }

  @override
  Future<void> deleteOfflineVideo(String videoId) async {
    try {
      await _localStorage.deleteByVideoId(videoId);
    } on OfflineVideoException catch (e) {
      throw StorageFailure(message: e.message);
    }
  }

  @override
  Future<bool> isVideoDownloaded(String videoId) async {
    final meta = await _localStorage.getMetadataByVideoId(videoId);
    return meta != null;
  }
}
