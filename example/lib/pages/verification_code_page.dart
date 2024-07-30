import 'package:flutter/material.dart';
import 'package:polling_timer/polling_timer.dart';

/// create by: YanHq
/// create time: 2024/7/29
/// des:
///
class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final PollingTimer timer = PollingTimer(
    interval: const Duration(seconds: 1),
    duration: const Duration(seconds: 60),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Verify Code Page'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Text(
                'Verification code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              const SizedBox(
                width: 75,
                height: 36,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: '...',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  maxLength: 6,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  if (timer.isRunning) return;
                  timer.launch(() {
                    setState(() {});
                  });
                },
                child: Container(
                  width: 95,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    timer.isRunning
                        ? 'Resend (${timer.remain.inSeconds}S)'
                        : 'Send Code',
                    style: TextStyle(
                      fontSize: 14,
                      color: timer.isRunning
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
