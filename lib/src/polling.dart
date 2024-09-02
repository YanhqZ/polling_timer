import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:polling_timer/src/logger.dart';

/// Polling timer
class PollingTimer {
  Completer<bool>? _delayCompleter;
  Stopwatch? _delayWatch;
  Timer? _timer;
  Stopwatch? _watch;

  /// timer delay
  final Duration _delay;

  /// timer interval
  final Duration _interval;

  /// timer duration
  final Duration _duration;

  /// used to mark async task
  int _tag = 0;

  VoidCallback? onStart;
  VoidCallback? onFinish;
  VoidCallback? onTick;

  PollingTimer({
    required Duration interval,
    required Duration duration,
    Duration delay = Duration.zero,
  })  : _duration = duration,
        _interval = interval,
        _delay = delay;

  setOnStartListener(VoidCallback onStart) {
    this.onStart = onStart;
  }

  setOnFinishListener(VoidCallback onFinish) {
    this.onFinish = onFinish;
  }

  setOnTickListener(VoidCallback onTick) {
    this.onTick = onTick;
  }

  /// Start polling timer
  start() async {
    if (_watch?.isRunning == null) {
      // Have not created polling timer.
      if (_delayWatch?.isRunning != true) {
        final ready = await _makeVerifyPollingTimerDelay();
        // Create polling timer after a period of time according to the args.
        if (ready) {
          _buildVerifyPollingTimer();
        }
      } else {
        // There is a polling timer creating, skip.
      }
    } else if (_watch?.isRunning == false) {
      // Resume the polling timer if paused.
      _buildVerifyPollingTimer();
    } else {
      // The polling timer is working, skip.
    }
  }

  /// Make timer delay
  Future<bool> _makeVerifyPollingTimerDelay() {
    var c = _delayCompleter;
    if (c != null) {
      _delayWatch?.start();
    } else {
      _delayCompleter = c = Completer();
      _delayWatch = Stopwatch()..start();
    }
    var duration = _delay - (_delayWatch?.elapsed ?? Duration.zero);
    return Future.delayed(duration).then((_) {
      _delayCompleter?.complete(true);
      return true;
    });
  }

  /// Polling timer implementation
  _buildVerifyPollingTimer() async {
    final curTag = DateTime.now().millisecondsSinceEpoch;
    _tag = curTag;
    if (_watch == null) {
      PollingTimerLogger.log(this, 'launch');
      // Trigger the callback immediately when the polling timer is created.
      onStart?.call();
      onTick?.call();
      _watch = Stopwatch()..start();
    } else {
      PollingTimerLogger.log(this, 'resume');
      // resume the polling timer.
      _watch?.start();
      int elapsedMilliSec = elapsed.inMilliseconds;
      int remainMilliSec =
          _interval.inMilliseconds - elapsedMilliSec % _interval.inMilliseconds;
      final remainDuration = Duration(milliseconds: remainMilliSec);
      PollingTimerLogger.log(this, "remain $remainDuration in pre interval");
      final t = await Future.delayed(remainDuration, () => curTag);
      if (t != _tag) {
        // Discard expired async task.
        return;
      } else {
        // The previous interval remain duration overed, trigger the callback immediately.
        onTick?.call();
      }
    }
    _timer = Timer.periodic(_interval, (timer) {
      if (elapsed >= _duration) {
        release();
        onTick?.call();
        onFinish?.call();
      } else {
        onTick?.call();
      }
    });
  }

  /// Pause the polling timer
  pause() {
    PollingTimerLogger.log(this, 'stop. Work time: $elapsed');
    _timer?.cancel();
    _watch?.stop();
    _tag = DateTime.now().millisecondsSinceEpoch;
    if (_delayCompleter?.isCompleted == false) {
      _delayCompleter?.complete(false);
      _delayWatch?.stop();
    }
  }

  /// Release the polling timer
  release() {
    PollingTimerLogger.log(this, 'release. Work time: $elapsed');
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
    return e > _duration ? _duration : e;
  }

  bool get isRunning => _watch?.isRunning ?? false;

  Duration get remain => _duration - elapsed;
}
