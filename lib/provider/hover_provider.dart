import 'dart:async';
import 'package:flutter/material.dart';

class HoverProvider with ChangeNotifier {
  bool _hoverMoreThanThree = false;

  int _tapCounter = 0;

  bool get hoverMoreThanThree => _hoverMoreThanThree;

  int get tapMoreThanThree => _tapCounter;

  void addTap() {
    _tapCounter++;
    notifyListeners();
    _tapCounter = 0;
  }

  void resetTap() {
    _tapCounter--;
    notifyListeners();
  }

  void setHoverMoreThanThree(bool value) {
    _hoverMoreThanThree = value;
    notifyListeners();
  }

  void startHoverTimer() {
    Timer(const Duration(seconds: 3), () {
      setHoverMoreThanThree(true);
    });
  }

  void cancelHoverTimer() {
    setHoverMoreThanThree(false);
  }
}
