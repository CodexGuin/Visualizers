import 'package:flutter/material.dart';
import 'package:visualizer/widgets/box_selection.dart';
import 'package:visualizer/widgets/header.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Headers().backgroundColorDark,
        appBar: Headers().defaultBar(),
        body: Column(children: [
          Headers().headerOne('Visualizers'),
          Headers().headerTwo('Made by Darren Seah'),
          const Flexible(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  BoxSelection(
                      childIcon: Icon(Icons.search), pageRoute: '/pathfinder'),
                  BoxSelection(
                      childIcon: Icon(Icons.filter_alt_rounded),
                      pageRoute: '/floodfill')
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  BoxSelection(childIcon: Icon(Icons.sort), pageRoute: '/sort'),
                  BoxSelection(childIcon: Icon(Icons.terminal), pageRoute: '/'),
                  BoxSelection(
                      childIcon: Icon(Icons.settings), pageRoute: '/settings')
                ])
              ]))
        ]));
  }
}
