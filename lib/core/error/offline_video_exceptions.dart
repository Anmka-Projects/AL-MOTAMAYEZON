/// Exceptions thrown by data layer; mapped to [OfflineVideoFailure] in repository.
class OfflineVideoException implements Exception {
  OfflineVideoException(this.message, [this.cause]);

  final String message;
  final dynamic cause;

  @override
  String toString() =>
      'OfflineVideoException: $message${cause != null ? ' ($cause)' : ''}';
}

class DownloadException extends OfflineVideoException {
  DownloadException(super.message, [super.cause]);
}

class StorageException extends OfflineVideoException {
  StorageException(super.message, [super.cause]);
}

class DecryptionException extends OfflineVideoException {
  DecryptionException(super.message, [super.cause]);
}

class KeyAccessException extends OfflineVideoException {
  KeyAccessException(super.message, [super.cause]);
}
