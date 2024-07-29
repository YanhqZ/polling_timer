import 'package:flutter/foundation.dart';
import 'package:polling_timer/src/polling.dart';

/// Polling timer logger
class PollingTimerLogger {
  PollingTimerLogger._();

  static void log(PollingTimer instance, String msg) {
    debugPrint('[${instance.hashCode}] - $msg');
  }
}
