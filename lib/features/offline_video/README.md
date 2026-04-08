# Offline Encrypted Video Feature

Production-ready offline video with AES-256 encryption, per-user keys, and secure storage.

## Folder Structure

```
offline_video/
├── data/
│   ├── datasources/
│   │   ├── local_encrypted_video_datasource.dart   # Encrypted file + index in app support dir
│   │   ├── remote_video_download_datasource.dart     # Dio byte download with progress
│   │   └── secure_key_datasource.dart               # flutter_secure_storage for key
│   ├── models/
│   │   ├── downloadable_video_model.dart
│   │   └── encrypted_video_metadata_model.dart
│   └── repository/
│       └── offline_video_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── downloadable_video.dart
│   │   ├── download_progress.dart
│   │   └── encrypted_video_metadata.dart
│   ├── repository/
│   │   └── offline_video_repository.dart
│   └── usecases/
│       ├── delete_offline_video_use_case.dart
│       ├── download_video_use_case.dart
│       ├── get_offline_videos_use_case.dart
│       ├── is_video_downloaded_use_case.dart
│       └── play_offline_video_use_case.dart
├── presentation/
│   ├── cubit/
│   │   ├── offline_video_cubit.dart
│   │   └── offline_video_state.dart
│   ├── view/
│   │   └── offline_videos_screen.dart
│   └── widgets/
│       ├── offline_video_player_widget.dart   # Decrypt → temp file → play → delete on dispose
│       └── video_download_item_widget.dart
└── README.md
```

## Example Usage

### 1. Navigate to the screen (e.g. from profile or home)

```dart
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/features/offline_video/domain/entities/downloadable_video.dart';
import 'package:elmotamizon/features/offline_video/presentation/view/offline_videos_screen.dart';

// In your widget:
final cubit = instance<OfflineVideoCubit>();
final sampleVideos = [
  DownloadableVideo(
    videoId: '1',
    downloadUrl: 'https://example.com/video1.mp4',
    title: 'Sample Video 1',
    thumbnailUrl: null,
    durationSeconds: 120,
  ),
];

Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => OfflineVideosScreen(
      cubit: cubit,
      downloadableVideos: sampleVideos,
    ),
  ),
);
```

### 2. Use the Cubit directly (e.g. from course details)

```dart
final cubit = instance<OfflineVideoCubit>();
await cubit.loadOfflineVideos();

// Download with progress
cubit.downloadVideo(DownloadableVideo(
  videoId: lessonId,
  downloadUrl: videoUrl,
  title: lessonTitle,
));

// Check if already downloaded
final isDownloaded = await cubit.isVideoDownloaded(videoId);

// Prepare playback path (caller must delete temp file after; use OfflineVideoPlayerWidget which does this)
final tempPath = await cubit.preparePlaybackPath(metadata);
// ... play with video_player, then delete File(tempPath).
```

## Security

- **Key derivation**: `SHA256(userId + secretSalt)` → 32-byte key (AES-256).
- **Key storage**: `flutter_secure_storage` (Android EncryptedSharedPreferences, iOS Keychain).
- **Per-file IV**: Random 16-byte IV per encrypted file, stored with ciphertext.
- **Storage path**: `getApplicationSupportDirectory()/offline_videos/` — not in device file manager.
- **Playback**: Decrypt in memory → write to temp file → play → delete temp on dispose.
- **Debug/root**: `SecurityCheckService` provides `isDebugMode` and `isPossiblyRooted` for gating sensitive flows.

## Dependencies (pubspec.yaml)

- `encrypt` — AES-256
- `crypto` — SHA256
- `flutter_secure_storage` — key storage
- `video_player` — playback
- `path` — path joining
- `path_provider` — app support + temp dirs
- `dio` — download (already in project)
