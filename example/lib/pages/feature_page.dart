import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polling_timer/polling_timer.dart';

/// create by: YanHq
/// create time: 2024/7/30
/// des:
///
class FeaturePage extends StatefulWidget {
  const FeaturePage({super.key});

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  final PollingTimer timer = PollingTimer(
    interval: const Duration(seconds: 5),
    delay: const Duration(seconds: 3),
    duration: const Duration(seconds: 30),
  );

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
            Text(
              '${timer.remain.inSeconds}',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _modify,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _modify() {
    if (timer.isRunning) {
      timer.pause();
    } else {
      timer.launch(
        () {
          setState(() {});
        },
        onFinish: () {},
      );
    }
  }
}
