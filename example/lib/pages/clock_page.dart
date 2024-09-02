import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polling_timer/polling_timer.dart';

/// create by: YanHq
/// create time: 2024/7/30
/// des:
///
class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  final PollingTimer timer = PollingTimer(
    interval: const Duration(seconds: 5),
    duration: const Duration(seconds: 60),
  );

  @override
  void initState() {
    super.initState();
    timer.setOnTickListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('PollingTimer Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomPaint(
              painter: ClockPaint(
                context: context,
                radius: 80,
                duration: const Duration(seconds: 60),
                current: timer.elapsed,
              ),
              size: const Size(160, 160),
            ),
            const SizedBox(height: 16),
            Text('${timer.remain.inSeconds}',
                style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _modify,
              child: Container(
                alignment: Alignment.center,
                width: 160,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  timer.isRunning ? 'Pause' : 'Start',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _modify() {
    if (timer.isRunning) {
      timer.pause();
    } else {
      timer.start();
    }
  }
}

class ClockPaint extends CustomPainter {
  final BuildContext context;
  final double radius;
  final Duration duration;
  final Duration current;

  const ClockPaint({
    required this.context,
    required this.radius,
    required this.duration,
    required this.current,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).colorScheme.inversePrimary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
    paint.color = Theme.of(context).colorScheme.primary;
    paint.strokeWidth = 3;
    paint.strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);
    canvas.drawArc(
        rect,
        -pi / 2,
        current.inMilliseconds / duration.inMilliseconds * pi * 2,
        false,
        paint);
  }

  @override
  shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
