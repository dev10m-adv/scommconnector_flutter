class AppException implements Exception {
  final String message;
  final String code;

  const AppException({required this.message, required this.code});

  @override
  String toString() => message;
}

class NoConnectionException extends AppException {
  const NoConnectionException({
    super.message = 'No internet connection. Please check your network and try again.',
  }) : super(code: 'NO_CONNECTION');
}

class RequestTimeoutException extends AppException {
  const RequestTimeoutException()
      : super(
          message: 'Request timed out. Please try again.',
          code: 'REQUEST_TIMEOUT',
        );
}

class ServerException extends AppException {
  const ServerException({super.message = 'Server error. Please try again later.'})
      : super(code: 'SERVER_ERROR');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'You are not authorized. Please sign in again.',
  }) : super(code: 'UNAUTHORIZED');
}

class UnknownAppException extends AppException {
  const UnknownAppException({
    super.message = 'Something went wrong. Please try again.',
  }) : super(code: 'UNKNOWN_ERROR');
}
