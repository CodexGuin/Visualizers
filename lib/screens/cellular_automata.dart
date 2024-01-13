// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:visualizer/widgets/header.dart';

class CellularAutomata extends StatefulWidget {
  const CellularAutomata({super.key});

  @override
  State<CellularAutomata> createState() => _CellularAutomataState();
}

class _CellularAutomataState extends State<CellularAutomata> {
  // * Variables
  int crossAxisCount = 25;
  int sliderMin = 6, sliderMax = 50;

  int aspectDivisor = 10;
  int aspectMin = 2, aspectMax = 10;

  int numberOfRows = 0;
  int totalCells = 0;

  @override
  void initState() {
    super.initState();
    updateGrid();
  }

  void updateGrid() {
    setState(() {
      // Calculate the grid height based on the aspect ratio
      double gridHeight = crossAxisCount / (aspectDivisor.toDouble() / 10);

      // Calculate the number of rows needed to cover this height
      // Assuming each cell's height is 1 unit
      numberOfRows = gridHeight.ceil();

      // Calculate the total number of cells
      totalCells = crossAxisCount * numberOfRows;

      print('Grid height: $gridHeight');
    });
  }

  // * Array to keep track of each individual cell state
  List<int> cellStates = [];

  void tagCells() {
    cellStates.clear();
    for (int i = 0; i < totalCells; i++) {
      cellStates.add(1);
    }

    print(cellStates.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Headers().backgroundColorDark,
      appBar: Headers().defaultBar(
          leading: Headers().subpageButton(context),
          headerOne: 'Cellular Automata',
          headerTwo: 'Simple 1D Cellular Automata visualizer'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              flex: 4,
              child: Container(
                  margin: const EdgeInsets.all(20),
                  //color: Colors.white,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: aspectDivisor.toDouble() / 10,
                      child: Container(
                        color: Colors.black,
                        child: GridView.count(
                          crossAxisCount: crossAxisCount,
                          children: List.generate(
                              totalCells,
                              (index) => Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                  )),
                        ),
                      ),
                    ),
                  ))),
          Flexible(
              child: Container(
            margin: const EdgeInsets.all(20),
            //color: Colors.black,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Slider(
                          label: '$crossAxisCount',
                          min: sliderMin.toDouble(),
                          max: sliderMax.toDouble(),
                          divisions: (sliderMax - sliderMin) ~/ 2,
                          value: crossAxisCount.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              crossAxisCount = value.toInt();
                              updateGrid();
                              tagCells();
                            });
                          })),
                  Flexible(
                      child: Text(
                    'Cross Axis Count: $crossAxisCount',
                    style: const TextStyle(color: Colors.white),
                  )),
                  Flexible(
                      child: Slider(
                          label: '$aspectDivisor',
                          min: aspectMin.toDouble(),
                          max: aspectMax.toDouble(),
                          divisions: (aspectMax - aspectMin),
                          value: aspectDivisor.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              aspectDivisor = value.toInt();
                              updateGrid();
                              tagCells();
                            });
                          })),
                  Flexible(
                      child: Text(
                    'Aspect Divisor: $aspectDivisor',
                    style: const TextStyle(color: Colors.white),
                  )),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
