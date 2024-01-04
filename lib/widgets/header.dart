import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:async';

class Headers {
  Color backgroundColorDark = const Color(0xFF242529);
  Timer? _hoverTimer;

  void _startHoverTimer(String text) {
    _hoverTimer = Timer(3.seconds, () {
      print('Hovered over text: $text for 3 seconds');
    });
  }

  void _cancelHoverTimer() {
    if (_hoverTimer != null) {
      _hoverTimer!.cancel();
      _hoverTimer = null;
    }
  }

  AppBar defaultBar({Widget? leading, String? headerOne, String? headerTwo}) {
    return AppBar(
        backgroundColor: backgroundColorDark,
        elevation: 0,
        centerTitle: true,
        leading: leading,
        title: DragToMoveArea(
            child: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: const Text(''))),
        actions: !kIsWeb
            ? [
                IconButton(
                    icon: const Icon(Icons.close,
                        size: 20, color: Colors.white38),
                    onPressed: () async {
                      await windowManager.close();
                    })
              ]
            : [],
        bottom: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: backgroundColorDark,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 100,
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Headers().headerOne(headerOne ?? ''),
                  Headers().headerTwo(headerTwo ?? '')
                ])));
  }

  Center headerOne(String headerText) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(headerText,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 50))));
  }

  Center headerTwo(String headerText) {
    return Center(
      child: MouseRegion(
        onHover: (event) => _startHoverTimer(headerText),
        onExit: (event) => _cancelHoverTimer(),
        child: Text(
          headerText,
          style: const TextStyle(
              color: Colors.white54, fontWeight: FontWeight.w300, fontSize: 15),
        ),
      ),
    );
  }

  IconButton subpageButton(var context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: Colors.white38,
        ));
  }
}
