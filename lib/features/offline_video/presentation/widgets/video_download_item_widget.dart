import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/download_progress.dart';
import 'package:elmotamizon/features/offline_video/presentation/cubit/offline_video_cubit.dart';
import 'package:elmotamizon/features/offline_video/presentation/cubit/offline_video_state.dart';

/// A list tile for a video that can be downloaded, with progress indicator
/// when a download is active for this video.
class VideoDownloadItemWidget extends StatelessWidget {
  const VideoDownloadItemWidget({
    super.key,
    required this.video,
    required this.isDownloaded,
    this.downloadProgress,
    this.onPlay,
  });

  final DownloadableVideo video;
  final bool isDownloaded;
  final DownloadProgress? downloadProgress;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final isDownloading = downloadProgress != null;
    return ListTile(
      title: Text(video.title),
      subtitle: isDownloading
          ? LinearProgressIndicator(
              value: downloadProgress!.progress,
              backgroundColor: Colors.grey.shade300,
            )
          : Text(isDownloaded ? 'Downloaded' : 'Tap to download'),
      trailing: isDownloading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: downloadProgress!.progress,
                strokeWidth: 2,
              ),
            )
          : IconButton(
              icon: Icon(
                  isDownloaded ? Icons.play_circle_filled : Icons.download),
              onPressed: isDownloading
                  ? null
                  : () {
                      if (isDownloaded && onPlay != null) {
                        onPlay!();
                      } else if (!isDownloaded) {
                        context.read<OfflineVideoCubit>().downloadVideo(video);
                      }
                    },
            ),
    );
  }
}
