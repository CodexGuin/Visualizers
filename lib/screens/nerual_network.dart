import 'package:flutter/material.dart';
import 'package:visualizer/widgets/header.dart';

class NeuralNetwork extends StatelessWidget {
  const NeuralNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Headers().backgroundColorDark,
      appBar: Headers().defaultBar(
          leading: Headers().subpageButton(context),
          headerOne: 'Neural Network',
          headerTwo: 'Visualize how neural networks work'),
      body: const Column(children: []),
    );
  }
}
