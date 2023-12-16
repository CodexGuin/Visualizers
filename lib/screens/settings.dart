import 'package:flutter/material.dart';
import 'package:visualizer/widgets/header.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Headers().backgroundColorDark,
      appBar: Headers().defaultBar(leading: Headers().subpageButton(context)),
      body: Column(children: [
        Headers().headerOne('Settings'),
        Headers().headerTwo('Coming Soon...'),
      ]),
    );
  }
}
