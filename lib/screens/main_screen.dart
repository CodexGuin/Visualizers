import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
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
            easterEgg: true,
            ctx: context),
        body: Column(children: [
          Flexible(
              child: Stack(children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // * Visualizers
              Row(
                  // * Header
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        flex: 4,
                        child: Container(
                            margin: const EdgeInsets.only(right: 35),
                            height: 1,
                            width: MediaQuery.of(context).size.width / 5,
                            color: Colors.white70)),
                    const Flexible(
                        child: Text('Visualizers',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                letterSpacing: 2))),
                    Flexible(
                        flex: 4,
                        child: Container(
                            margin: const EdgeInsets.only(left: 35),
                            height: 1,
                            width: MediaQuery.of(context).size.width / 5,
                            color: Colors.white70))
                  ]),
              const Gap(20),
              const Row(
                  // * Row 1
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoxSelection(
                        childIcon: Icon(Icons.search),
                        pageRoute: '/pathfinder'),
                    BoxSelection(
                        childIcon: Icon(Icons.brush_rounded),
                        pageRoute: '/floodfill'),
                    BoxSelection(
                        childIcon: Icon(Icons.sort), pageRoute: '/sort')
                  ]),
              const Row(
                  // * Row 2
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoxSelection(
                        childIcon: Icon(Icons.grid_3x3_rounded),
                        pageRoute: '/chess'),
                    BoxSelection(
                        childIcon: Icon(Icons.circle_outlined),
                        pageRoute: '/neural_network'),
                    BoxSelection(
                        childIcon: Icon(Icons.auto_awesome_mosaic_rounded),
                        pageRoute: '/cellular_automata'),
                  ]),
              const Gap(20),

              // * Misc stuff here
              Row(
                  // * Header
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        flex: 4,
                        child: Container(
                            margin: const EdgeInsets.only(right: 35),
                            height: 1,
                            width: MediaQuery.of(context).size.width / 5,
                            color: Colors.white70)),
                    const Flexible(
                        child: Text('Others',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                letterSpacing: 2))),
                    Flexible(
                        flex: 4,
                        child: Container(
                            margin: const EdgeInsets.only(left: 35),
                            height: 1,
                            width: MediaQuery.of(context).size.width / 5,
                            color: Colors.white70))
                  ]),
              const Gap(20),
              const Row(
                  // * Row 1
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoxSelection(
                        childIcon: Icon(Icons.settings_accessibility_rounded),
                        pageRoute: '/testing'),
                    BoxSelection(
                        childIcon: Icon(Icons.settings), pageRoute: '/settings')
                  ])
            ]),
            Consumer<HoverProvider>(builder: (context, obj, child) {
              int a = obj.tapMoreThanThree;
              //print(a);
              return a > 2
                  ? Center(
                          child: GestureDetector(
                      onTap: () =>
                          Provider.of<HoverProvider>(context, listen: false)
                              .resetTap(),
                      child: Container(
                          height: 500,
                          width: 500,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/whistle.jpg'),
                                  fit: BoxFit.cover))),
                    ))
                      .animate(
                          /* onPlay: (controller) =>
                                controller.repeat(reverse: true) */
                          )
                      .scaleXY(
                          duration: 3.seconds,
                          begin: 0,
                          end: 1,
                          curve: Curves.easeInOutCubicEmphasized)
                  : Container();
            })
          ]))
        ]));
  }
}
