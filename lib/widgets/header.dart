// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualizer/provider/hover_provider.dart';
import 'package:window_manager/window_manager.dart';

class Headers {
  Color backgroundColorDark = const Color(0xFF242529);

  AppBar defaultBar(
      {Widget? leading,
      String? headerOne,
      String? headerTwo,
      BuildContext? ctx}) {
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
                  Headers().headerTwo(headerTwo ?? '', ctx)
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

  Center headerTwo(String headerText, BuildContext? ctx) {
    return Center(
        child: GestureDetector(
      onTap: () => Provider.of<HoverProvider>(ctx!).addTap(),
      child: MouseRegion(
          onHover: (event) => {},
          onExit: (event) => {},
          child: Text(headerText,
              style: const TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w300,
                  fontSize: 15))),
    ));
  }

  IconButton subpageButton(var context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 20, color: Colors.white38));
  }
}
