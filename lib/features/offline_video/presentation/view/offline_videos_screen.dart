import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/encrypted_video_metadata.dart';
import 'package:elmotamizon/features/offline_video/presentation/cubit/offline_video_cubit.dart';
import 'package:elmotamizon/features/offline_video/presentation/cubit/offline_video_state.dart';
import 'package:elmotamizon/features/offline_video/presentation/widgets/offline_video_player_widget.dart';

/// Example screen: list of downloadable videos and list of offline videos.
/// Tapping download starts encrypted download with progress; tapping play
/// opens a full-screen player that decrypts to temp file and deletes on close.
class OfflineVideosScreen extends StatelessWidget {
  const OfflineVideosScreen({
    super.key,
    required this.cubit,
  });

  final OfflineVideoCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OfflineVideoCubit>.value(
      value: cubit..loadOfflineVideos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.myVideos.tr()),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => cubit.loadOfflineVideos(),
            ),
          ],
        ),
        body: BlocConsumer<OfflineVideoCubit, OfflineVideoState>(
          listener: (context, state) {
            if (state is OfflineVideoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.failure.message ?? 'Error')),
              );
            }
          },
          builder: (context, state) {
            final offlineList = state is OfflineVideoLoaded
                ? state.videos
                : state is OfflineVideoDownloading
                    ? state.videos
                    : state is OfflineVideoDownloadCompleted
                        ? state.videos
                        : <EncryptedVideoMetadata>[];

            if (state is OfflineVideoInitial) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (offlineList.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    AppStrings.noData.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => cubit.loadOfflineVideos(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: offlineList.length,
                itemBuilder: (context, index) {
                  final meta = offlineList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _openPlayer(context, meta),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: meta.thumbnailUrl != null &&
                                      meta.thumbnailUrl!.isNotEmpty
                                  ? Image.network(
                                      meta.thumbnailUrl!,
                                      width: 72,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 72,
                                          height: 56,
                                          color: Colors.blueGrey.shade50,
                                          child: const Icon(
                                            Icons.play_circle_fill,
                                            color: Colors.blueAccent,
                                            size: 32,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 72,
                                      height: 56,
                                      color: Colors.blueGrey.shade50,
                                      child: const Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.blueAccent,
                                        size: 32,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    meta.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat.yMMMd()
                                        .add_Hm()
                                        .format(meta.downloadedAt.toLocal()),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: 'Play',
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () => _openPlayer(context, meta),
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  cubit.deleteOfflineVideo(meta.videoId),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _openPlayer(BuildContext context, EncryptedVideoMetadata metadata) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: OfflineVideoPlayerWidget(
                    metadata: metadata,
                    cubit: cubit,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
