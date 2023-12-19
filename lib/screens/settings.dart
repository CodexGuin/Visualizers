import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:visualizer/widgets/header.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Headers().backgroundColorDark,
      appBar: Headers().defaultBar(leading: Headers().subpageButton(context)),
      body: Column(
        children: [
          Headers().headerOne('Settings'),
          Headers().headerTwo(
              'Fiddle with the settings and view version logs here!'),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(50),
              child: ListView(
                children: const [
                  Column(
                    children: [
                      VersionLog(
                          versionNum: 'Version 0.0.1',
                          subtitle: 'Project creation',
                          information: 'Information here'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VersionLog extends StatelessWidget {
  final String versionNum, subtitle, information;
  const VersionLog(
      {super.key,
      required this.versionNum,
      required this.subtitle,
      required this.information});

  @override
  Widget build(BuildContext context) {
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
              child: Text(versionNum,
                  style: const TextStyle(fontSize: 30, color: Colors.white))),
          Center(
              child: Text(subtitle,
                  style: const TextStyle(fontSize: 20, color: Colors.white38))),
          const Gap(10),
          Center(
              child: Text(information,
                  style: const TextStyle(color: Colors.white38)))
        ]));
  }
}
