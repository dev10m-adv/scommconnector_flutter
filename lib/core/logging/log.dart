// import 'dart:developer' as developer;

/// Default **on**; set `--dart-define=INFO_LOG=false` to disable.
const bool infoLogFlag = bool.fromEnvironment('INFO_LOG', defaultValue: false);
const bool debugLogFlag = bool.fromEnvironment(
  'DEBUG_LOG',
  defaultValue: false,
);
const bool warningLogFlag = bool.fromEnvironment(
  'WARNING_LOG',
  defaultValue: true,
);
const bool errorLogFlag = bool.fromEnvironment('ERROR_LOG', defaultValue: true);

class LogLevel {
  static const int debug = 500;
  static const int info = 800;
  static const int warning = 900;
  static const int error = 1000;
}

void debugLog(String message) {
  if (!debugLogFlag) return;
  // developer.log("🐛 DEBUG: $message", name: 'ScommConnector', level: LogLevel.debug);
  print("🐛 DEBUG ScommConnector: $message");
}

void infoLog(String message) {
  if (!infoLogFlag) return;
  // developer.log("ℹ️ INFO: $message", name: 'ScommConnector', level: LogLevel.info);
  print("ℹ️ INFO ScommConnector: $message");
}

void warningLog(String message, [Object? error]) {
  if (!warningLogFlag) return;
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
  if (!errorLogFlag) return;
  // developer.log(
  //   "❌ ERROR: $message",
  //   name: 'ScommConnector',
  //   level: LogLevel.error,
  //   error: error,
  //   stackTrace: stackTrace,
  // );
  print("❌ ERROR ScommConnector: $message");
}
