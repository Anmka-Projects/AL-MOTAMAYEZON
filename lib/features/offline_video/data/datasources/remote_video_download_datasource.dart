import 'dart:async';

import 'package:dio/dio.dart';

import 'package:elmotamizon/core/error/offline_video_exceptions.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/download_progress.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';

/// Downloads video content as bytes and reports progress via stream.
/// Does not write to disk; caller encrypts and stores.
abstract class RemoteVideoDownloadDatasource {
  /// Downloads [video.downloadUrl] and adds progress to [progressSink].
  /// Returns the full response bytes.
  Future<List<int>> downloadAsBytes(
    DownloadableVideo video,
    StreamController<DownloadProgress> progressSink,
  );
}

class RemoteVideoDownloadDatasourceImpl
    implements RemoteVideoDownloadDatasource {
  RemoteVideoDownloadDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<int>> downloadAsBytes(
    DownloadableVideo video,
    StreamController<DownloadProgress> progressSink,
  ) async {
    try {
      final response = await _dio.get<List<int>>(
        video.downloadUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status != null && status! < 400,
        ),
        onReceiveProgress: (received, total) {
          if (!progressSink.isClosed) {
            progressSink.add(DownloadProgress(
              videoId: video.videoId,
              receivedBytes: received,
              totalBytes: total > 0 ? total : received,
            ));
          }
        },
      );

      final data = response.data;
      if (data == null) throw DownloadException('Empty response');
      return data;
    } on DioException catch (e) {
      throw DownloadException(
        e.response?.statusMessage ?? e.message ?? 'Download failed',
        e,
      );
    }
  }
}
