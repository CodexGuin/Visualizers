import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class Headers {
  Color backgroundColorDark = const Color(0xFF242529);

  AppBar defaultBar({Widget? leading}) {
    return AppBar(
      backgroundColor: Colors.transparent,
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
                  icon:
                      const Icon(Icons.close, size: 20, color: Colors.white38),
                  onPressed: () async {
                    await windowManager.close();
                  })
            ]
          : [],
    );
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
        child: Text(headerText,
            style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w300,
                fontSize: 15)));
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
