import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';

/// Test data for offline video when your API is not available.
/// Uses public sample video URLs so you can test download → encrypt → play.
class OfflineVideoTestData {
  OfflineVideoTestData._();

  /// Public sample video URLs (no API needed). Use these to test the full flow.
  static const String sampleVideoUrl1 =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
  static const String sampleVideoUrl2 =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4';
  static const String sampleVideoUrl3 =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4';

  /// Returns a list of [DownloadableVideo] for testing. Pass to [OfflineVideosScreen].
  static List<DownloadableVideo> getTestDownloadableVideos() => [
        const DownloadableVideo(
          videoId: 'test_big_buck',
          downloadUrl: sampleVideoUrl1,
          title: 'Test: Big Buck Bunny',
          durationSeconds: 596,
        ),
        const DownloadableVideo(
          videoId: 'test_elephants',
          downloadUrl: sampleVideoUrl2,
          title: 'Test: Elephants Dream',
          durationSeconds: 653,
        ),
        const DownloadableVideo(
          videoId: 'test_blazes',
          downloadUrl: sampleVideoUrl3,
          title: 'Test: For Bigger Blazes',
          durationSeconds: 15,
        ),
      ];
}
