// import 'dart:developer' as developer;

class LogLevel {
  static const int debug = 500;
  static const int info = 800;
  static const int warning = 900;
  static const int error = 1000;
}

void debugLog(String message) {
  // developer.log("🐛 DEBUG: $message", name: 'ScommConnector', level: LogLevel.debug);
  // print("🐛 DEBUG ScommConnector: $message");
}

void infoLog(String message) {
  // developer.log("ℹ️ INFO: $message", name: 'ScommConnector', level: LogLevel.info);
  print("ℹ️ INFO ScommConnector: $message");
}

void warningLog(String message, [Object? error, StackTrace? stackTrace]) {
  // developer.log(
  //   "⚠️ WARNING: $message",
  //   name: 'ScommConnector',
  //   level: LogLevel.warning,
  //   error: error,
  //   stackTrace: stackTrace,
  // );
  print("⚠️ WARNING ScommConnector: $message");
}

void errorLog(String message, [Object? error, StackTrace? stackTrace]) {
  // developer.log(
  //   "❌ ERROR: $message",
  //   name: 'ScommConnector',
  //   level: LogLevel.error,
  //   error: error,
  //   stackTrace: stackTrace,
  // );
  print("❌ ERROR ScommConnector: $message");
}