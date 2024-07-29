import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:polling_timer/src/logger.dart';

/// Polling timer
class PollingTimer {
  Completer<bool>? _delayCompleter;
  Timer? _timer;
  Stopwatch? _watch;

  /// timer delay sec
  final int _delaySec;

  /// timer interval sec
  final int _intervalSec;

  /// timer duration sec
  final int _durationSec;

  /// used to mark async task
  int _tag = 0;

  PollingTimer({
    required int intervalSec,
    required int durationSec,
    int delaySec = 0,
  })  : _durationSec = durationSec,
        _intervalSec = intervalSec,
        _delaySec = delaySec;

  /// Start polling timer
  launch(
    VoidCallback onTick, {
    VoidCallback? onFinish,
  }) async {
    if (_watch?.isRunning == null) {
      // Have not created polling timer.
      if (_delayCompleter == null) {
        final ready = await _makeVerifyPollingTimerDelay().future;
        // Create polling timer after a period of time according to the args.
        if (ready) {
          _buildVerifyPollingTimer(onTick, onFinish: onFinish);
        }
      } else {
        // There is a polling timer creating, skip.
      }
    } else if (_watch?.isRunning == false) {
      // Resume the polling timer if paused.
      _buildVerifyPollingTimer(onTick, onFinish: onFinish);
    } else {
      // The polling timer is working, skip.
    }
  }

  /// Make timer delay
  Completer<bool> _makeVerifyPollingTimerDelay() {
    var c = _delayCompleter;
    if (c != null) {
      return c;
    } else {
      _delayCompleter = c = Completer();
    }
    Future.delayed(Duration(seconds: _delaySec))
        .then((value) => _delayCompleter?.complete(true));
    return _delayCompleter!;
  }

  /// Polling timer implementation
  _buildVerifyPollingTimer(VoidCallback onTick,
      {VoidCallback? onFinish}) async {
    final curTag = DateTime.now().millisecondsSinceEpoch;
    _tag = curTag;
    if (_watch == null) {
      PollingTimerLogger.log(this, 'launch');
      // Trigger the callback immediately when the polling timer is created.
      onTick.call();
      _watch = Stopwatch()..start();
    } else {
      PollingTimerLogger.log(this, 'resume');
      // resume the polling timer.
      _watch?.start();
      int elapsedMilliSec = elapsed.inMilliseconds;
      int remainMilliSec =
          _intervalSec * 1000 - elapsedMilliSec % (_intervalSec * 1000);
      final remainDuration = Duration(milliseconds: remainMilliSec);
      PollingTimerLogger.log(
          this, "remain $remainDuration in previous interval");
      final t = await Future.delayed(remainDuration, () => curTag);
      if (t != _tag) {
        // Discard expired async task.
        return;
      } else {
        // The previous interval has passed, trigger the callback immediately.
        onTick.call();
      }
    }
    _timer = Timer.periodic(Duration(seconds: _intervalSec), (timer) {
      if (elapsed >= Duration(seconds: _durationSec)) {
        release();
        onTick.call();
        onFinish?.call();
      } else {
        onTick.call();
      }
    });
  }

  /// Pause the polling timer
  pause() {
    PollingTimerLogger.log(this, 'stop');
    PollingTimerLogger.log(this, 'work time: $elapsed');
    _timer?.cancel();
    _watch?.stop();
    _tag = DateTime.now().millisecondsSinceEpoch;
    // Fixme: It is better to record the delayed time.
    if (_delayCompleter?.isCompleted == false) {
      _delayCompleter?.complete(false);
    }
    _delayCompleter = null;
  }

  /// Release the polling timer
  release() {
    PollingTimerLogger.log(this, 'release');
    PollingTimerLogger.log(this, 'work time: $elapsed');
    _timer?.cancel();
    _timer = null;
    _watch?.reset();
    _watch = null;
    if (_delayCompleter?.isCompleted == false) {
      _delayCompleter?.complete(false);
    }
    _delayCompleter = null;
  }

  Duration get elapsed {
    final e = _watch?.elapsed ?? Duration.zero;
    return e > Duration(seconds: _durationSec)
        ? Duration(seconds: _durationSec)
        : e;
  }

  bool get isRunning => _watch?.isRunning ?? false;

  Duration get remain => Duration(seconds: _durationSec) - elapsed;
}
