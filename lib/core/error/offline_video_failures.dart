import 'package:equatable/equatable.dart';

/// Base class for offline video feature failures (domain layer).
abstract class OfflineVideoFailure extends Equatable {
  const OfflineVideoFailure({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

class DownloadFailure extends OfflineVideoFailure {
  const DownloadFailure({super.message});
}

class StorageFailure extends OfflineVideoFailure {
  const StorageFailure({super.message});
}

class DecryptionFailure extends OfflineVideoFailure {
  const DecryptionFailure({super.message});
}

class PlaybackFailure extends OfflineVideoFailure {
  const PlaybackFailure({super.message});
}

class KeyAccessFailure extends OfflineVideoFailure {
  const KeyAccessFailure({super.message});
}

class SecurityCheckFailure extends OfflineVideoFailure {
  const SecurityCheckFailure({super.message});
}
