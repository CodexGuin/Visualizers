// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:visualizer/widgets/header.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  String currentCellMode = 'Container';
  int count = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Headers().backgroundColorDark,
      appBar: Headers().defaultBar(
          leading: Headers().subpageButton(context),
          headerOne: 'Testing',
          headerTwo: 'Playground for testings anything'),
      body: Column(
        children: [
          Flexible(
              child: Container(
            //color: Colors.amber.withOpacity(0.05),
            child: const Center(
                child: Text(
              'Currently testing: Using CustomPainter instead of Containers for GridViews to improve performance',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
          )),
          Flexible(
              flex: 6,
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  //color: Colors.white.withOpacity(0.05),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white70)),
                  child: GridView.count(
                      crossAxisCount: 50,
                      //physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(count, (index) {
                        return currentCellMode == 'Container'
                            ? CellContainer(index: index)
                            : CellCustomPainter(index: index);
                      })),
                ),
              )),
          Flexible(
              child: Container(
                  //color: Colors.amber.withOpacity(0.05),
                  child: Center(
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Slider(
                    value: count.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        count = value.toInt();
                      });
                      print(count);
                    },
                    max: 100000,
                    min: 3,
                  ),
                ),
                Flexible(
                  child: Center(
                    child: ElevatedButton(
                        child: const Text('Toggle Container / CustomPainter'),
                        onPressed: () {
                          setState(() {
                            if (currentCellMode == 'Container') {
                              currentCellMode = 'CustomPainter';
                            } else {
                              currentCellMode = 'Container';
                            }
                          });
                        }),
                  ),
                ),
                Flexible(
                    child: Center(
                        child: Text(
                  'Testing: $currentCellMode',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ))),
              ],
            ),
          )))
        ],
      ),
    );
  }
}

class CellContainer extends StatelessWidget {
  final int index;
  const CellContainer({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(2),
        color: Colors.white,
        child: Center(child: FittedBox(child: Text(index.toString()))));
  }
}

class CellCustomPainter extends StatelessWidget {
  final int index;
  const CellCustomPainter({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomPainterTest(index: index),
    );
  }
}

class CustomPainterTest extends CustomPainter {
  final int index;
  CustomPainterTest({required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    // Circle properties
    const Offset circleCenter = Offset(10, 10);
    const double radius = 10;
    final Paint circlePaint = Paint()..color = Colors.red;

    // Draw the circle
    canvas.drawCircle(circleCenter, radius, circlePaint);

    // Style for the text
    final ui.ParagraphStyle paragraphStyle = ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
      maxLines: 1,
    );

    // Building the paragraph
    final ui.ParagraphBuilder paragraphBuilder =
        ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(ui.TextStyle(color: Colors.black))
          ..addText(index.toString());

    // Layout the paragraph
    final ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: radius * 2));

    // Calculate the position to center the text in the circle
    final double textX = circleCenter.dx - (paragraph.maxIntrinsicWidth / 2);
    final double textY = circleCenter.dy - (paragraph.height / 2);

    // Draw the paragraph
    canvas.drawParagraph(paragraph, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
