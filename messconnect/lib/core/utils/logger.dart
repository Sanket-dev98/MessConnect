import 'dart:developer' as dev;

/// Lightweight app logger backed by [dart:developer.log].
///
/// Centralised so we can later route logs to crash reporting without
/// touching call sites.
class AppLogger {
  const AppLogger._();

  static void info(String message, {String? name}) =>
      dev.log(message, name: name ?? 'MessConnect');

  static void warn(String message, {Object? error, StackTrace? stackTrace}) =>
      dev.log(message, name: 'MessConnect', error: error, stackTrace: stackTrace);

  static void error(String message, {Object? error, StackTrace? stackTrace}) =>
      dev.log(message,
          name: 'MessConnect', error: error, stackTrace: stackTrace, level: 1000);
}
