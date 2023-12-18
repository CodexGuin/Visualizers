// ignore_for_file: avoid_print, constant_identifier_names
import 'package:flutter/material.dart';

// * Enums for the different states
enum BoxStateColor { OPEN, WALL, START, END, PATH, SEARCHING }

class PathfinderState {
  // * Returns a color based on states
  Color getColorFromState(BoxStateColor state) {
    switch (state) {
      case BoxStateColor.OPEN:
        return Colors.white;
      case BoxStateColor.WALL:
        return Colors.grey.shade800;
      case BoxStateColor.START:
        return Colors.green;
      case BoxStateColor.END:
        return Colors.red;
      case BoxStateColor.PATH:
        return Colors.yellow;
      case BoxStateColor.SEARCHING:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }
}

// * Single cell in maze
class Cell extends StatelessWidget {
  final int idx;
  final Function()? onTap;
  final Color color;

  const Cell({super.key, required this.idx, this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: onTap,
            child: Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: color,
                        border: Border.all(color: Colors.black87))))));
  }
}
