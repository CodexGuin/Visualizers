import 'dart:async';

import 'package:flutter/material.dart';

class HoverProvider with ChangeNotifier {
  int _tapCounter = 0;
  Timer? _timer;

  HoverProvider() {
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) => resetTap());
  }

  int get tapMoreThanThree => _tapCounter;

  void addTap() {
    _tapCounter++;
    if (_tapCounter >= 3) {
      // Pause the timer when counter reaches 3
      _timer?.cancel();
    }
    notifyListeners();
  }

  void resetTap() {
    _tapCounter = 0;
    notifyListeners();
    _startTimer();
  }
}
