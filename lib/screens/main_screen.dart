import 'package:flutter/material.dart';
import 'package:visualizer/widgets/box_selection.dart';
import 'package:visualizer/widgets/header.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Headers().backgroundColorDark,
        appBar: Headers().defaultBar(
            headerOne: 'Visualizers', headerTwo: 'Made by Darren Seah'),
        body: const Column(children: [
          Flexible(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  BoxSelection(
                      childIcon: Icon(Icons.search), pageRoute: '/pathfinder'),
                  BoxSelection(
                      childIcon: Icon(Icons.brush_rounded),
                      pageRoute: '/floodfill'),
                  BoxSelection(childIcon: Icon(Icons.sort), pageRoute: '/sort'),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  BoxSelection(
                      childIcon: Icon(Icons.grid_3x3_rounded),
                      pageRoute: '/chess'),
                  BoxSelection(
                      childIcon: Icon(Icons.circle_outlined),
                      pageRoute: '/neural_network'),
                  BoxSelection(
                      childIcon: Icon(Icons.settings), pageRoute: '/settings')
                ])
              ]))
        ]));
  }
}
