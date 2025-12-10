import 'package:flutter/foundation.dart';

class LoggingServicePrinter {
  LoggingServicePrinter._();

  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag ?? 'APP';
      print('[$timestamp] [$logTag] $message');
    }
  }

  static void logError(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('[$timestamp] [ERROR] $message');
      if (error != null) {
        print('Error: $error');
      }
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
  }
}
