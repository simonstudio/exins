import 'dart:async';

import 'package:flutter/material.dart';

class TFTimer extends StatefulWidget {


  @override
  State<TFTimer> createState() => _TFTimerState();
}

class _TFTimerState extends State<TFTimer> {
  bool isTimer = false;
  late Timer _timer;
  int _start = 0;

  void startTimer() {
    _start = 5 * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start < 1) {
          isTimer = false;
          _start = 5* 60;
          _timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;

    return !isTimer
        ? TextButton(
            onPressed: () {
              setState(() {
                startTimer();
                isTimer = true;
              });
            },
            child: const Text(
              "Send code again",
              style: TextStyle(
                color: Color(0xff385898),
              ),
            ),
          )
        : Text(
            '($minutes:$seconds)',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          );
  }
}
