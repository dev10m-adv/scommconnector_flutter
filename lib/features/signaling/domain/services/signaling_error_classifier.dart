import '../../../../core/errors/errors.dart';

/// Classifies errors to determine if auto-recovery should be attempted.
///
/// Single Responsibility: Determine retry eligibility based on error type.
abstract class ISignalingErrorClassifier {
  /// Determine if [error] is recoverable via auto-reconnect.
  bool shouldAutoReconnect(AppException error);

  /// Convert any exception to AppException.
  AppException toAppError(Object error);
}

/// Default implementation classifying errors by type.
class SignalingErrorClassifier implements ISignalingErrorClassifier {
  @override
  bool shouldAutoReconnect(AppException error) {
    // Recoverable errors: transient network issues
    if (error is NoConnectionException || error is RequestTimeoutException) {
      return true;
    }

    // Non-recoverable: auth/validation failures
    if (error is UnauthorizedException || error is ServerException) {
      return false;
    }

    // Unknown: conservative default is to retry
    return true;
  }

  @override
  AppException toAppError(Object error) {
    if (error is AppException) {
      return error;
    }
    return const UnknownAppException(
      message: 'Signaling failed due to an unexpected error.',
    );
  }
}
