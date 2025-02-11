import 'dart:async';
import 'package:a5er_elshare3/core/utils/Constants/constants.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final Duration expiryDuration;

  const TimerWidget({super.key, required this.expiryDuration});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Stream<int> _timerStream;

  Stream<int> _countdownTimer(Duration duration) async* {
    int remainingSeconds = duration.inSeconds;

    while (remainingSeconds >= 0) {
      await Future.delayed(const Duration(seconds: 1));
      yield remainingSeconds--;
    }
  }

  @override
  void initState() {
    super.initState();
    _timerStream = _countdownTimer(widget.expiryDuration);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timerStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Starting timer...");
        }
        if (!snapshot.hasData || snapshot.data == 0) {
          return const Text("Expired", style: TextStyle(color: Colors.red));
        }
        final remainingTime = snapshot.data!;
        return Text(
          "Time remaining: ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}",
          style: const TextStyle(fontSize: 16, color: kDarkBlueColor, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
