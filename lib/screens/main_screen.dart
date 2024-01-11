import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualizer/provider/hover_provider.dart';
import 'package:visualizer/widgets/box_selection.dart';
import 'package:visualizer/widgets/header.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Headers().backgroundColorDark,
        appBar: Headers().defaultBar(
            headerOne: 'Visualizers',
            headerTwo: 'Made by Darren Seah',
            ctx: context),
        body: Column(children: [
          Flexible(
              child: Stack(children: [
            const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    BoxSelection(
                        childIcon: Icon(Icons.search),
                        pageRoute: '/pathfinder'),
                    BoxSelection(
                        childIcon: Icon(Icons.brush_rounded),
                        pageRoute: '/floodfill'),
                    BoxSelection(
                        childIcon: Icon(Icons.sort), pageRoute: '/sort')
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
                ]),
            Consumer<HoverProvider>(
              builder: (context, obj, child) {
                return Container();
              },
            ),
            Center(
                child: Container(
                    height: 500,
                    width: 1000,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                            image: AssetImage('assets/whistle.jpg'),
                            fit: BoxFit.cover))))
          ]))
        ]));
  }
}
