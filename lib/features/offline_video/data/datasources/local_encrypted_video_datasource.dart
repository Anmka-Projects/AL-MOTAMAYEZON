import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:elmotamizon/core/error/offline_video_exceptions.dart';
import 'package:elmotamizon/features/offline_video/data/models/encrypted_video_metadata_model.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';

/// Handles encrypted file storage under application support directory
/// and metadata index. Files are stored as .bin (not visible in user file manager
/// when using app support dir on iOS/Android).
abstract class LocalEncryptedVideoDatasource {
  /// Root directory for offline videos (application support).
  Future<Directory> getStorageDirectory();

  /// Saves [encryptedBytes] as [fileName].bin in storage dir.
  Future<String> saveEncryptedFile(String fileName, List<int> encryptedBytes);

  /// Reads encrypted file by [fileName] and returns bytes.
  Future<List<int>> readEncryptedFile(String fileName);

  /// Returns metadata for all stored videos (from index file).
  Future<List<EncryptedVideoMetadata>> listEncryptedVideos();

  /// Appends or updates metadata in index.
  Future<void> saveMetadata(EncryptedVideoMetadata metadata);

  /// Removes metadata and deletes the .bin file for [videoId].
  Future<void> deleteByVideoId(String videoId);

  /// Returns metadata for [videoId] if present.
  Future<EncryptedVideoMetadata?> getMetadataByVideoId(String videoId);
}

class LocalEncryptedVideoDatasourceImpl
    implements LocalEncryptedVideoDatasource {
  LocalEncryptedVideoDatasourceImpl();

  static const String _subDir = 'offline_videos';
  static const String _indexFileName = '_index.json';

  @override
  Future<Directory> getStorageDirectory() async {
    final dir = await getApplicationSupportDirectory();
    final videoDir = Directory(p.join(dir.path, _subDir));
    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
    }
    return videoDir;
  }

  Future<File> _indexFile() async {
    final dir = await getStorageDirectory();
    return File(p.join(dir.path, _indexFileName));
  }

  Future<Map<String, dynamic>> _readIndex() async {
    final file = await _indexFile();
    if (!await file.exists()) return {};
    try {
      final content = await file.readAsString();
      final decoded = jsonDecode(content) as Map<String, dynamic>?;
      return decoded ?? {};
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeIndex(Map<String, dynamic> index) async {
    final file = await _indexFile();
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(index));
  }

  @override
  Future<String> saveEncryptedFile(
      String fileName, List<int> encryptedBytes) async {
    try {
      final dir = await getStorageDirectory();
      final name = fileName.endsWith('.bin') ? fileName : '$fileName.bin';
      final file = File(p.join(dir.path, name));
      await file.writeAsBytes(encryptedBytes);
      return file.path;
    } catch (e) {
      throw StorageException('Failed to save encrypted file', e);
    }
  }

  @override
  Future<List<int>> readEncryptedFile(String fileName) async {
    try {
      final dir = await getStorageDirectory();
      final name = fileName.endsWith('.bin') ? fileName : '$fileName.bin';
      final file = File(p.join(dir.path, name));
      if (!await file.exists()) {
        throw StorageException('File not found: $name');
      }
      return await file.readAsBytes();
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException('Failed to read encrypted file', e);
    }
  }

  @override
  Future<List<EncryptedVideoMetadata>> listEncryptedVideos() async {
    final index = await _readIndex();
    final list = <EncryptedVideoMetadata>[];
    for (final entry in index.entries) {
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        list.add(EncryptedVideoMetadataModel.fromJson(value));
      }
    }
    return list;
  }

  @override
  Future<void> saveMetadata(EncryptedVideoMetadata metadata) async {
    final index = await _readIndex();
    index[metadata.videoId] =
        EncryptedVideoMetadataModel.fromEntity(metadata).toJson();
    await _writeIndex(index);
  }

  @override
  Future<void> deleteByVideoId(String videoId) async {
    final metadata = await getMetadataByVideoId(videoId);
    if (metadata != null) {
      final dir = await getStorageDirectory();
      final file = File(p.join(dir.path, metadata.fileName));
      if (await file.exists()) await file.delete();
    }
    final index = await _readIndex();
    index.remove(videoId);
    await _writeIndex(index);
  }

  @override
  Future<EncryptedVideoMetadata?> getMetadataByVideoId(String videoId) async {
    final index = await _readIndex();
    final data = index[videoId];
    if (data is Map<String, dynamic>) {
      return EncryptedVideoMetadataModel.fromJson(data);
    }
    return null;
  }
}
