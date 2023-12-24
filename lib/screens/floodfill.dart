// ignore_for_file: avoid_print

import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:visualizer/widgets/header.dart';

class AudioService {
  final List<AudioPlayer> _players;
  Uint8List? _audioData;
  int _currentPlayerIndex = 0;

  AudioService(int numberOfPlayers)
      : _players = List.generate(numberOfPlayers, (_) => AudioPlayer());

  Future<void> loadSoundEffect() async {
    // Load the audio file into memory
    final byteData = await rootBundle.load('assets/audio/hitmarker_2.mp3');
    _audioData = byteData.buffer.asUint8List();
  }

  Future<void> playSoundEffect() async {
    if (_audioData != null) {
      // Get the next player in the rotation
      final player = _players[_currentPlayerIndex];

      // Play the audio data from memory
      if (!kIsWeb) {
        // * Only play on non-web platforms
        await player.play(BytesSource(_audioData!));
      }

      // Move to the next player for the next call
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
    }
  }
}

class FloodFill extends StatefulWidget {
  const FloodFill({super.key});

  @override
  State<FloodFill> createState() => _FloodFillState();
}

class _FloodFillState extends State<FloodFill> {
  final AudioService _audioService = AudioService(5);

  // * Slider values
  double gridSize = 10;
  int animationSpeedinMS = 100;

  // * Variables
  List<Color> cellColors = []; // Initial colors
  Color currentColor = Colors.pink;
  bool isBucket = false;

  // * New list to store order of cells for animation
  List<int> animationSequence = [];

  // * Initializer
  @override
  void initState() {
    super.initState();
    initCellStates();
    _audioService.loadSoundEffect();
  }

  // * Flood fill logic (BFS)
  void floodFill(Color oldColor, Color newColor, int currentIndex) {
    if (cellColors[currentIndex] == newColor) {
      return;
    }
    // Process the initial cell
    if (cellColors[currentIndex] == oldColor) {
      setState(() {
        cellColors[currentIndex] = newColor;
      });
    }

    // Stores visited cells
    final visited = HashSet<int>();
    visited.add(currentIndex);

    // Queue for BFS
    final queue = Queue<int>();
    queue.add(currentIndex);

    // While there are still cells in the queue
    while (queue.isNotEmpty) {
      // Remove the first cell from the queue
      final index = queue.removeFirst();

      // Add this cell to the animation sequence
      processCellForAnimation(index, oldColor, visited, queue);

      // Check each adjacent cell individually and call _processCell if it's a valid cell
      if (index % gridSize.toInt() != 0) {
        processCellForAnimation(index - 1, oldColor, visited, queue);
      }
      if ((index + 1) % gridSize.toInt() != 0) {
        processCellForAnimation(index + 1, oldColor, visited, queue);
      }
      if (index - gridSize.toInt() >= 0) {
        processCellForAnimation(
            index - gridSize.toInt(), oldColor, visited, queue);
      }
      if (index + gridSize.toInt() < gridSize.toInt() * gridSize.toInt() ~/ 2) {
        processCellForAnimation(
            index + gridSize.toInt(), oldColor, visited, queue);
      }
    }

    // Start the animation using the populated sequence
    animateColorChanges(newColor);
  }

  // * Private function called by floodFill (BFS) for animation
  void processCellForAnimation(
      int index, Color oldColor, HashSet<int> visited, Queue<int> queue) {
    if (visited.contains(index) || cellColors[index] != oldColor) {
      return;
    }

    // Add the index to the sequence for animation
    animationSequence.add(index);

    // Add the cell to the visited list and queue
    visited.add(index);
    queue.add(index);
  }

  // * Function to animate color changes
  Future<void> animateColorChanges(Color newColor) async {
    for (var index in animationSequence) {
      setState(() {
        cellColors[index] = Colors.grey;
      });

      await _audioService.playSoundEffect();

      await Future.delayed(Duration(milliseconds: animationSpeedinMS));

      setState(() {
        cellColors[index] = newColor;
      });
    }
    animationSequence.clear(); // Reset the animation sequence
  }

  @override
  void dispose() {
    // Dispose of any other AudioPlayer instances you might have in the state
    super.dispose();
  }

  // * On choosing new color
  void onColorChange(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  // * On clicking of individual cell
  void onCellClick(int index) async {
    if (isBucket) {
      floodFill(cellColors[index], currentColor, index);
    } else {
      await _audioService.playSoundEffect();
      setState(() {
        if (index < cellColors.length) {
          cellColors[index] = currentColor;
        } else {
          for (int i = cellColors.length; i <= index; i++) {
            cellColors.add(Colors.white);
          }
          cellColors[index] = currentColor;
        }
      });
    }
  }

  // * Initialize initial cell states in grid
  void initCellStates() {
    // Clear cellColors
    cellColors.clear();

    // Set all cells to white initially
    for (int i = 0; i < gridSize.toInt() * gridSize.toInt() ~/ 2; i++) {
      cellColors.add(Colors.white);
    }

    // ! Debugging only
    for (int i = 0; i < gridSize.toInt() * gridSize.toInt() ~/ 2; i++) {
      print(' Cell $i = ${cellColors[i]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Headers().backgroundColorDark,
        appBar: Headers().defaultBar(
            leading: Headers().subpageButton(context),
            headerOne: 'Flood Fill',
            headerTwo: 'Visualize how painting works'),
        body: Column(children: [
          Flexible(
              child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    // * Painting grid
                    Flexible(
                        flex: 4,
                        child: AspectRatio(
                            aspectRatio: 900 / 452,
                            child: SizedBox(
                                width: 900,
                                height: 452,
                                child: Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black, width: 2)),
                                        child: GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        gridSize.toInt()),
                                            itemCount: gridSize.toInt() *
                                                gridSize.toInt() ~/
                                                2,
                                            itemBuilder: (context, index) {
                                              // Ensures the list has enough colors
                                              if (index >= cellColors.length) {
                                                cellColors.add(Colors.white);
                                              }

                                              return GestureDetector(
                                                  onTap: () =>
                                                      onCellClick(index),
                                                  child: MouseRegion(
                                                      cursor: SystemMouseCursors
                                                          .click,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: cellColors[
                                                                  index],
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)))));
                                            })))))),

                    // * Action row
                    Flexible(
                        child: MediaQuery.of(context).size.width > 900
                            ? Row(
                                // * If width > 900
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    // * Grid size slider
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text('Grid size',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                      tickMarkShape:
                                                          const RoundSliderTickMarkShape(
                                                              tickMarkRadius:
                                                                  0),
                                                      showValueIndicator:
                                                          ShowValueIndicator
                                                              .always),
                                              child: Slider(
                                                  value: gridSize,
                                                  min: 5,
                                                  max: 50,
                                                  label: gridSize
                                                      .toInt()
                                                      .toString(),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      initCellStates();
                                                      gridSize =
                                                          ((val / 2).round() *
                                                              2);
                                                    });
                                                  }))
                                        ]),
                                    const Gap(30),

                                    // * Animation speed slider
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text('Animation speed',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                      tickMarkShape:
                                                          const RoundSliderTickMarkShape(
                                                              tickMarkRadius:
                                                                  0),
                                                      showValueIndicator:
                                                          ShowValueIndicator
                                                              .always),
                                              child: Slider(
                                                  value: animationSpeedinMS
                                                      .toDouble(),
                                                  min: 0,
                                                  max: 1000,
                                                  label: animationSpeedinMS
                                                      .toString(),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      animationSpeedinMS =
                                                          val.toInt();
                                                    });
                                                  }))
                                        ]),
                                    const Gap(30),

                                    // * Colors
                                    ColorChooser(
                                        onColorChange: onColorChange,
                                        text: 'Pink',
                                        color: Colors.pink),
                                    ColorChooser(
                                        onColorChange: onColorChange,
                                        text: 'Green',
                                        color: Colors.green),
                                    ColorChooser(
                                        onColorChange: onColorChange,
                                        text: 'Blue',
                                        color: Colors.blue),
                                    ColorChooser(
                                        onColorChange: onColorChange,
                                        text: 'Black',
                                        color: Colors.black),
                                    ColorChooser(
                                        onColorChange: onColorChange,
                                        text: 'White',
                                        color: Colors.white),
                                    const Gap(30),

                                    // * Toggling between bucket and single
                                    ToggleSwitch(
                                        minHeight: 40,
                                        initialLabelIndex: isBucket ? 0 : 1,
                                        activeBgColor: const [
                                          Color(0xFF6750A4)
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.white60,
                                        animate: true,
                                        curve: Easing.standard,
                                        labels: const ['Bucket', 'Single'],
                                        onToggle: (index) {
                                          setState(() {
                                            isBucket = index == 0;
                                          });
                                        })
                                  ])
                            : Column(
                                // * If width < 900
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // * Grid size slider
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text('Grid size',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                                SliderTheme(
                                                    data: SliderTheme.of(
                                                            context)
                                                        .copyWith(
                                                            tickMarkShape:
                                                                const RoundSliderTickMarkShape(
                                                                    tickMarkRadius:
                                                                        0),
                                                            showValueIndicator:
                                                                ShowValueIndicator
                                                                    .always),
                                                    child: Slider(
                                                        value: gridSize,
                                                        min: 5,
                                                        max: 50,
                                                        label: gridSize
                                                            .toInt()
                                                            .toString(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            initCellStates();
                                                            gridSize = ((val /
                                                                        2)
                                                                    .round() *
                                                                2);
                                                          });
                                                        }))
                                              ]),
                                          const Gap(30),

                                          // * Animation speed slider
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text('Animation speed',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                                SliderTheme(
                                                    data: SliderTheme.of(
                                                            context)
                                                        .copyWith(
                                                            tickMarkShape:
                                                                const RoundSliderTickMarkShape(
                                                                    tickMarkRadius:
                                                                        0),
                                                            showValueIndicator:
                                                                ShowValueIndicator
                                                                    .always),
                                                    child: Slider(
                                                        value:
                                                            animationSpeedinMS
                                                                .toDouble(),
                                                        min: 0,
                                                        max: 1000,
                                                        label:
                                                            animationSpeedinMS
                                                                .toString(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            animationSpeedinMS =
                                                                val.toInt();
                                                          });
                                                        }))
                                              ])
                                        ]),
                                    const Gap(10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // * Colors
                                          ColorChooser(
                                              onColorChange: onColorChange,
                                              text: 'Pink',
                                              color: Colors.pink),
                                          ColorChooser(
                                              onColorChange: onColorChange,
                                              text: 'Green',
                                              color: Colors.green),
                                          ColorChooser(
                                              onColorChange: onColorChange,
                                              text: 'Blue',
                                              color: Colors.blue),
                                          ColorChooser(
                                              onColorChange: onColorChange,
                                              text: 'Black',
                                              color: Colors.black),
                                          ColorChooser(
                                              onColorChange: onColorChange,
                                              text: 'White',
                                              color: Colors.white),
                                          const Gap(50),

                                          // * Toggling between bucket and single
                                          ToggleSwitch(
                                              minHeight: 40,
                                              initialLabelIndex:
                                                  isBucket ? 0 : 1,
                                              activeBgColor: const [
                                                Color(0xFF6750A4)
                                              ],
                                              activeFgColor: Colors.white,
                                              inactiveBgColor: Colors.white60,
                                              animate: true,
                                              curve: Easing.standard,
                                              labels: const [
                                                'Bucket',
                                                'Single'
                                              ],
                                              onToggle: (index) {
                                                setState(() {
                                                  isBucket = index == 0;
                                                });
                                              })
                                        ])
                                  ]))
                  ])))
        ]));
  }
}

// * Color chooser box
class ColorChooser extends StatelessWidget {
  final Function(Color) onColorChange;
  final String text;
  final Color color;
  const ColorChooser(
      {super.key,
      required this.onColorChange,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () {
              onColorChange(color);
            },
            child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: color, border: Border.all(color: Colors.white)))));
  }
}
