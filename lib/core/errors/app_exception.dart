/// Errors the UI can render without knowing which repository (mock or real)
/// threw them, so a screen only ever needs to switch on this taxonomy.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'No connection']);
}

final class NotFoundException extends AppException {
  NotFoundException(String kind, String id) : super('$kind $id not found');
}

final class ValidationException extends AppException {
  const ValidationException(super.message);
}

final class PaymentFailedException extends AppException {
  const PaymentFailedException([
    super.message = 'Payment could not be recorded',
  ]);
}

final class PrinterException extends AppException {
  const PrinterException([super.message = 'Printer not responding']);
}

final class SyncException extends AppException {
  const SyncException([super.message = 'Sync failed']);
}

final class PermissionException extends AppException {
  const PermissionException(super.message);
}
