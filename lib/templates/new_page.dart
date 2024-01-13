import 'package:flutter/material.dart';
import 'package:visualizer/widgets/header.dart';

class ChangeThis extends StatelessWidget {
  const ChangeThis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Headers().backgroundColorDark,
      appBar: Headers().defaultBar(
          leading: Headers().subpageButton(context),
          headerOne: 'Heading One',
          headerTwo: 'Heading Two'),
      body: const Placeholder(),
    );
  }
}
