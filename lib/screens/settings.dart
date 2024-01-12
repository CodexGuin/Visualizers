import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:visualizer/widgets/header.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Headers().backgroundColorDark,
        appBar: Headers().defaultBar(
            leading: Headers().subpageButton(context),
            headerOne: 'Settings',
            headerTwo: 'Fiddle with the settings and view version logs here!'),
        body: Column(children: [
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(50),
                  child: ListView(children: const [
                    Column(children: [
                      VersionLog(
                          versionNum: 'Version 0.3.8',
                          date: '12 Jan 2024',
                          subtitle: 'Playground Environment',
                          information: [
                            'Added a playground environment for testing purposes',
                            'Added funny easter egg :3',
                            'Main page: Tweaked UI',
                            'Playground: Currently testing if CustomPainter or Container is more efficient',
                            'Chess: Extracted cells into another class for modularity and functionality',
                            'Chess: Added onHover colors for cells that are hovered',
                            'Todo: Function for checking legal moves of each piece',
                            'Fixed: Simple code refactoring'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.3.7',
                          date: '25/12/2023',
                          subtitle: 'Neural Network Page + Bug Fixes',
                          information: [
                            'Fixed Flood Fill and Pathfinding centering issues',
                            'Neural Network: Basic layout and functional implementation',
                            'Todo: Get the constraints of a box using GlobalKey to calculate height of offsets for CustomPainter',
                            'Bug: Calculations runs before the container is instantiated, aka it’s accessing null key'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.3.6',
                          date: '24/12/2023',
                          subtitle: 'Overhauls',
                          information: [
                            'Overhauled how headers and subtitles are implemented',
                            'New feature: Neural Network',
                            'Fully updated logs',
                            'Added responsive action row for Floodfill and Pathfinding',
                            'Tweaked UI'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.3.5',
                          date: '21/12/2023',
                          subtitle: 'Bugs',
                          information: [
                            'Bug: While search is ongoing and user adjusts maze size, it crashes',
                            'Bug: Grey cells not resetting when new Start/End search starts'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.3.4',
                          date: '20/12/2023',
                          subtitle: 'Tweaks',
                          information: [
                            'Added ratio for Flood Fill grid for scallability',
                            'Added new branch: Incremental for GitHub',
                            'Incremental branch is set up for minor updates without triggering CD/CI pipeline',
                            'Learnt more about Git'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.3.3',
                          date: '19/12/2023',
                          subtitle: 'Settings Page',
                          information: [
                            'Added settings page',
                            'Created logging widget',
                            'Tweaked UI'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.3.2',
                          date: '18/12/2023',
                          subtitle: 'Flood Fill Fix',
                          information: ['Fixed Flood Fill not working on web']),
                      VersionLog(
                          versionNum: 'Version 0.3.1',
                          date: '17/12/2023',
                          subtitle: 'Flood Fill Fix',
                          information: ['Documented CD/CI process in Notion']),
                      VersionLog(
                          versionNum: 'Version 0.3',
                          date: '16/12/2023',
                          subtitle: 'GitHub + Pathfinder Fix',
                          information: [
                            'Created repository and pushed to GitHub',
                            'Set up CD/CI pipeline thru GitHub Actions',
                            'Revamped entire Pathfinder page without provider',
                            'Working Pathfinder'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.2.2',
                          date: '15/12/2023',
                          subtitle: 'Pathfinding Tweak',
                          information: [
                            'Unstable Pathfinding visualization',
                            'Animation not working',
                            'BFS not working',
                            'Managing states properly',
                            'Fixed: Start/End cells\' idx will be null when replaced with Open/Wall'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.2.1',
                          date: '13/12/2023',
                          subtitle: 'Code Tweaks',
                          information: [
                            'Added animation speed adjustment for Flood Fill',
                            'Added disposing of state',
                            'Added audio service, only for native desktop application',
                            'Bug: Flood Fill breaks on web',
                            'Bug: User should be prevented from starting another flood while one is running'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.2',
                          date: '12/12/2023',
                          subtitle: 'Flood Fill Implementation',
                          information: [
                            'Completed working prototype of Flood Fill algorithm',
                            'Implemented BFS approach',
                            'Planned for animation',
                            'Features: 5 colors, grid size adjustment, paint/single cell coloring',
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.1.2',
                          date: '9/12/2023',
                          subtitle: 'Firebase Integration',
                          information: [
                            'Firebase hosting integration',
                            'Deployed site on: codexguin-visualizers.web.app',
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.1.1',
                          date: '6/12/2023',
                          subtitle: 'Animation',
                          information: [
                            'Discovered Animation package',
                            'Experiemented with animations on main menu buttons',
                            'Implemented simple animation on sorting visualizer',
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.1',
                          date: '4/12/2023',
                          subtitle: 'Sorting Visualizer',
                          information: [
                            'Implemented sorting visualizer',
                            'Using packaged sorting algorithm for now',
                            'Planned animation for sorting',
                            'Tweaked UI'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.0.2',
                          date: '2/12/2023',
                          subtitle: 'Importing Pathfinder',
                          information: [
                            'Importing pathfinding code from previous codebase',
                            'Layout for subpages implementation'
                          ]),
                      VersionLog(
                          versionNum: 'Version 0.0.1',
                          date: '1/12/2023',
                          subtitle: 'Project creation',
                          information: [
                            'Initial creation of project',
                            'Basic layout creation',
                            'Implemented home screen UI and planned feature (Pathfinder, Floodfill, Settings)'
                          ])
                    ])
                  ])))
        ]));
  }
}

class VersionLog extends StatelessWidget {
  final String versionNum, subtitle, date;
  final List<String> information;
  const VersionLog(
      {super.key,
      required this.versionNum,
      required this.subtitle,
      required this.information,
      required this.date});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double basePadding = 5; // This is 'a', the base padding value
    double growthFactor = 1.05; // This is 'b', the growth factor
    double exponent = screenWidth / 50; // 'x', scaled down to manage growth

    // Calculate exponential padding
    double padding = basePadding * pow(growthFactor, exponent);

    // Apply clamping to ensure padding stays within a usable range
    double minPadding = 5.0;
    double maxPadding = 150.0;
    double responsivePadding = padding.clamp(minPadding, maxPadding);

    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purpleAccent.withOpacity(0.1),
            border: Border.all(
                color: Colors.purpleAccent.withOpacity(0.5), width: 2)),
        child: Column(children: [
          Center(
              child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(versionNum,
                    style: const TextStyle(fontSize: 30, color: Colors.white)),
                const Gap(10),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.purple),
                ),
                const Gap(10),
                Text(subtitle,
                    style: const TextStyle(fontSize: 30, color: Colors.white))
              ],
            ),
          )),
          Center(
              child: Text(date,
                  style: const TextStyle(fontSize: 15, color: Colors.white38))),
          const Gap(10),
          /* Center(
              child: Text(subtitle,
                  style: const TextStyle(fontSize: 25, color: Colors.white))),
          const Gap(5), */
          ...information.map((text) => Padding(
              padding: EdgeInsets.only(
                  left: responsivePadding,
                  right: responsivePadding,
                  top: 10,
                  bottom: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white)),
                    const Gap(15),
                    Expanded(
                        child: Text(text,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white70)))
                  ])))
        ]));
  }
}
