class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

class StorageException extends AppException {
  const StorageException(super.message, {super.code});
}

class DataException extends AppException {
  const DataException(super.message, {super.code});
}

class GameLogicException extends AppException {
  const GameLogicException(super.message, {super.code});
}
