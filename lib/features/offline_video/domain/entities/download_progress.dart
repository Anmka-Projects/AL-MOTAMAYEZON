import 'package:equatable/equatable.dart';

/// Progress of a single video download (bytes and percentage).
class DownloadProgress extends Equatable {
  const DownloadProgress({
    required this.videoId,
    required this.receivedBytes,
    required this.totalBytes,
  });

  final String videoId;
  final int receivedBytes;
  final int totalBytes;

  double get progress => totalBytes > 0 ? receivedBytes / totalBytes : 0.0;
  int get percentage => (progress * 100).round();

  @override
  List<Object?> get props => [videoId, receivedBytes, totalBytes];
}
