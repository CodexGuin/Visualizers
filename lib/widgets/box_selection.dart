import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BoxSelection extends StatefulWidget {
  final Icon childIcon;
  final String pageRoute;
  const BoxSelection(
      {super.key, required this.childIcon, required this.pageRoute});

  @override
  State<BoxSelection> createState() => _BoxSelectionState();
}

class _BoxSelectionState extends State<BoxSelection> {
  // * Variables
  double initialSize = 75;
  double initialIconSize = 40;
  bool isHovering = false;
  Color? hoveredColor = Colors.transparent;
  final _overlayController = OverlayPortalController();
  late String text;
  int randomDuration = 2;

  // * List of colors
  List<Color> colList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
  ];

  // * Function to return random color
  Color getRandomColor() {
    return colList[Random().nextInt(colList.length)].withOpacity(0.2);
  }

  // * Map of route to text strings
  final Map<String, String> routeToText = {
    // * Visualizers
    '/pathfinder': 'Pathfinder',
    '/floodfill': 'Flood fill',
    '/sort': 'Sorting',
    '/chess': 'Chess',
    '/neural_network': 'Neural Network',
    '/cellular_automata': 'Cellular Automata',

    // * Settings
    '/settings': 'Settings',
    '/testing': 'Testing',
  };

  // * Function to handle hover
  void handleHover(bool hovering) {
    text = routeToText[widget.pageRoute] ?? 'NOTHING';

    if (hovering && !isHovering) {
      // Change color only when hover starts
      hoveredColor = getRandomColor();
      _overlayController.toggle();
      randomDuration = Random().nextInt(4) + 2;
    }
    if (!hovering) {
      // Reset color when hover ends
      hoveredColor = Colors.transparent;
      _overlayController.toggle();
    }
    setState(() {
      isHovering = hovering;
    });
  }

  // * Box decorations
  BoxDecoration get normalDecoration => BoxDecoration(
      color: const Color(0xFF242529),
      border: Border.all(color: Colors.white, width: 3),
      borderRadius: BorderRadius.circular(10));

  // * Actual overlay widget
  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) {
          return Animate(
              effects: const [FadeEffect()],
              child: Positioned(
                  top: MediaQuery.sizeOf(context).height / 5,
                  left: MediaQuery.sizeOf(context).width / 2 - 150,
                  child: Container(
                      height: 100,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(color: Colors.white54, width: 3)),
                      child: Center(
                          child: Text(text,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200))))));
        },
        child: Animate(
            effects: [
              ShimmerEffect(duration: 1.seconds, delay: randomDuration.seconds)
            ],
            onPlay: (controller) => controller.repeat(),
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (_) => handleHover(true),
                onExit: (_) => handleHover(false),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, widget.pageRoute);
                    },
                    child: Animate(
                        target: isHovering ? 1 : 0,
                        effects: [
                          ScaleEffect(
                              begin: const Offset(1, 1),
                              end: const Offset(1.1, 1.1),
                              curve: Curves.easeInOut,
                              duration: 150.ms),
                          TintEffect(color: hoveredColor, duration: 100.ms)
                        ],
                        child: Container(
                            height: initialSize,
                            width: initialSize,
                            margin: const EdgeInsets.all(15),
                            decoration: normalDecoration,
                            child: Center(
                                child: Icon(widget.childIcon.icon,
                                    color: Colors.white,
                                    size: initialIconSize))))))));
  }
}
