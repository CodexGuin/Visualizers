// ignore_for_file: avoid_print, must_be_immutable, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, unnecessary_null_comparison

import 'package:gap/gap.dart';
import 'package:visualizer/provider/pathfinder_state.dart';
import 'package:visualizer/widgets/header.dart';

import 'package:flutter/material.dart';

class Pathfinder extends StatefulWidget {
  const Pathfinder({super.key});

  @override
  State<Pathfinder> createState() => _PathfinderState();
}

class _PathfinderState extends State<Pathfinder> {
  // * Variables
  double maxWidth = 1600, maxHeight = 804;

  // * Current state chosen by user
  BoxStateColor selectedState = BoxStateColor.OPEN;

  // * On state select
  void onStateSelect(BoxStateColor state) {
    setState(() {
      selectedState = state;
    });
    print('Current state is: $selectedState');
  }

  // * Grid variables
  int numBoxInRow = 10;
  late int numBoxInCol;
  List<BoxStateColor> gridState = [];
  late int currentGridSize;

  // * Start and end idx
  int? startIdx, endIdx;

  // * Animation sequence
  List<int> animationSequence = [];

  void onCellClick(int idx) {
    setState(() {
      // Check if it's the start or end index
      if (selectedState == BoxStateColor.START) {
        if (endIdx == idx) return;
        if (startIdx != null) gridState[startIdx!] = BoxStateColor.OPEN;
        startIdx = idx;
      } else if (selectedState == BoxStateColor.END) {
        if (startIdx == idx) return;
        if (endIdx != null) gridState[endIdx!] = BoxStateColor.OPEN;
        endIdx = idx;
      }

      // Check if it's open or wall
      else if (selectedState == BoxStateColor.OPEN ||
          selectedState == BoxStateColor.WALL) {
        if (idx == startIdx) {
          startIdx = null;
        } else if (idx == endIdx) {
          endIdx = null;
        }
        gridState[idx] = selectedState;
      }

      // Set the selected state
      gridState[idx] = selectedState;
    });

    print('Start idx: $startIdx');
    print('End idx: $endIdx');
  }

  // * Clears grid
  void clearGrid() {
    setState(() {
      gridState = List.generate(currentGridSize, (idx) => BoxStateColor.OPEN);
      startIdx = null;
      endIdx = null;
    });
  }

  // * Initializes the grid to all open and start / end to null
  void resetCellStates() {
    // * Resetting the start, end, and clear grid
    setState(() {
      startIdx = null;
      endIdx = null;
      gridState.clear();
    });
  }

  // * Calculate grid variables
  void calculateGridVariables() {
    // * Calculations
    numBoxInCol = numBoxInRow ~/ 2;
    currentGridSize = numBoxInRow * numBoxInCol;
    print('Grid is: $numBoxInRow x $numBoxInCol = $currentGridSize');
  }

  // * BFS path finding
  void bfs() async {
    List<int> queue = [];
    Map<int, int> visited = {};
    List<int> animationSequence = [];

    queue.add(startIdx!);
    visited[startIdx!] = -1;

    while (queue.isNotEmpty) {
      int current = queue.removeAt(0);

      // Add current cell to animation sequence for search animation
      if (current != startIdx && current != endIdx) {
        animationSequence.add(current);
      }

      // If end is found
      if (current == endIdx) {
        break;
      }

      // Check adjacent cells
      for (int nextIdx in getAdjacentCells(current)) {
        if (!visited.containsKey(nextIdx) &&
            nextIdx < currentGridSize &&
            gridState[nextIdx] != BoxStateColor.WALL) {
          visited[nextIdx] = current;
          queue.add(nextIdx);
        }
      }
    }

    // Animate search process
    await animateSearch(animationSequence);

    // Reconstruct the path if end is found
    if (visited.containsKey(endIdx)) {
      await animatePath(visited);
    }
  }

// * Animate the search process
  Future<void> animateSearch(List<int> sequence) async {
    for (int idx in sequence) {
      setState(() {
        gridState[idx] =
            BoxStateColor.SEARCHING; // Use an appropriate color or state
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

// * Animate the path from end to start
  Future<void> animatePath(Map<int, int> visited) async {
    int pathIdx = endIdx!;
    while (pathIdx != startIdx) {
      pathIdx = visited[pathIdx]!;
      if (pathIdx != startIdx) {
        setState(() {
          gridState[pathIdx] = BoxStateColor.PATH;
        });
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  // * Get adjacent cells
  List<int> getAdjacentCells(int idx) {
    List<int> adjacentCells = [];
    if (idx >= currentGridSize) {
      return adjacentCells;
    }

    // * Calculate row and column from index
    int row = idx ~/ numBoxInRow;
    int col = idx % numBoxInRow;

    // * Check adjacent cells
    if (row > 0) {
      adjacentCells.add(idx - numBoxInRow);
    }
    if (row < numBoxInCol - 1) {
      adjacentCells.add(idx + numBoxInRow);
    }
    if (col > 0) {
      adjacentCells.add(idx - 1);
    }
    if (col < numBoxInRow - 1) {
      adjacentCells.add(idx + 1);
    }

    return adjacentCells;
  }

  // * Start from a clean slate
  void cleanSlate() {
    clearGrid();
    resetCellStates();
    calculateGridVariables();
    gridState = List.generate(currentGridSize, (idx) => BoxStateColor.OPEN);
  }

  // * Initializes the widget
  @override
  void initState() {
    super.initState();
    resetCellStates();

    // * Calculate grid variables
    calculateGridVariables();

    // * Generates new grid state
    gridState = List.generate(currentGridSize, (idx) => BoxStateColor.OPEN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Headers().backgroundColorDark,
        appBar: Headers().defaultBar(leading: Headers().subpageButton(context)),
        body: Column(children: [
          Headers().headerOne('Pathfinder'),
          Headers().headerTwo('Choose from a collection of algorithms'),
          Flexible(
              child: Container(
                  //color: Colors.white.withOpacity(0.05), // ! Debugging
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    // * Maze grid
                    Flexible(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: maxWidth / maxHeight,
                        child: Center(
                          child: SizedBox(
                            width: maxWidth,
                            height: maxHeight,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: GridView.count(
                                  crossAxisCount: numBoxInRow,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                    currentGridSize,
                                    (index) => Cell(
                                        onTap: () => onCellClick(index),
                                        color: PathfinderState()
                                            .getColorFromState(
                                                gridState[index]),
                                        idx: index),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // * Action row
                    Flexible(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          // * States (DONE)
                          Flexible(
                            child: Row(
                              children: [
                                StatesBox(
                                    onTap: () =>
                                        onStateSelect(BoxStateColor.OPEN),
                                    color: PathfinderState()
                                        .getColorFromState(BoxStateColor.OPEN),
                                    text: 'Open'),
                                StatesBox(
                                    onTap: () =>
                                        onStateSelect(BoxStateColor.WALL),
                                    color: PathfinderState()
                                        .getColorFromState(BoxStateColor.WALL),
                                    text: 'Wall'),
                                StatesBox(
                                    onTap: () =>
                                        onStateSelect(BoxStateColor.START),
                                    color: PathfinderState()
                                        .getColorFromState(BoxStateColor.START),
                                    text: 'Start'),
                                StatesBox(
                                    onTap: () =>
                                        onStateSelect(BoxStateColor.END),
                                    color: PathfinderState()
                                        .getColorFromState(BoxStateColor.END),
                                    text: 'End'),
                                StatesBox(
                                    color: PathfinderState()
                                        .getColorFromState(BoxStateColor.PATH),
                                    text: 'Path'),
                                StatesBox(
                                    color: PathfinderState().getColorFromState(
                                        BoxStateColor.SEARCHING),
                                    text: 'Search')
                              ],
                            ),
                          ),
                          const Gap(10),

                          // * Slider (DONE)
                          Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('Adjust maze size',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  SizedBox(
                                    width: 250,
                                    child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                            tickMarkShape:
                                                const RoundSliderTickMarkShape(
                                                    tickMarkRadius: 0)),
                                        child: Slider(
                                            value: numBoxInRow.toDouble(),
                                            min: 4,
                                            max: 50,
                                            label: numBoxInRow.toString(),
                                            divisions: 23,
                                            onChanged: (val) {
                                              setState(() {
                                                // Calculate the position of the slider
                                                int position =
                                                    ((val - 4) / 2).round();

                                                // Map the position to the actual value
                                                numBoxInRow =
                                                    4 + (position * 2);
                                                //numBoxInRow = val.toInt();
                                                startIdx = null;
                                                endIdx = null;
                                                animationSequence.clear();
                                                // Calculate grid variables
                                                calculateGridVariables();
                                                // Update grid state based on new grid size
                                                gridState = List.generate(
                                                    currentGridSize,
                                                    (idx) =>
                                                        BoxStateColor.OPEN);
                                              });
                                            })),
                                  )
                                ]),
                          ),
                          const Gap(10),

                          // * Buttons (DONE)
                          Flexible(
                              child: MediaQuery.of(context).size.height > 820
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          ActionButtons(
                                              text: 'Clear grid',
                                              onTap: clearGrid),
                                          const Gap(10),
                                          const ActionButtons(
                                              text: 'Generate maze (Lazy)'),
                                          const Gap(10),
                                          ActionButtons(
                                            text: 'Debug',
                                            onTap: () {
                                              for (int i = 0;
                                                  i < gridState.length;
                                                  i++) {
                                                print(
                                                    'Cell $i: ${gridState[i]}');
                                              }
                                            },
                                          ),
                                          const Gap(10),
                                          ActionButtons(
                                              text: 'BFS',
                                              onTap: () {
                                                if (startIdx != null &&
                                                    endIdx != null) {
                                                  bfs();
                                                } else if (startIdx == null &&
                                                    endIdx == null) {
                                                  customScaffoldMsg(context,
                                                      'Select start and end index!');
                                                } else if (startIdx == null) {
                                                  customScaffoldMsg(context,
                                                      'Select start index!');
                                                } else if (endIdx == null) {
                                                  customScaffoldMsg(context,
                                                      'Select end index!');
                                                }
                                              })
                                        ])
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          Column(
                                            children: [
                                              Expanded(
                                                child: ActionButtons(
                                                    text: 'Clear grid',
                                                    onTap: clearGrid),
                                              ),
                                              const Gap(10),
                                              const Expanded(
                                                child: ActionButtons(
                                                    text:
                                                        'Generate maze (Lazy)'),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Expanded(
                                                child: ActionButtons(
                                                  text: 'Debug',
                                                  onTap: () {
                                                    for (int i = 0;
                                                        i < gridState.length;
                                                        i++) {
                                                      print(
                                                          'Cell $i: ${gridState[i]}');
                                                    }
                                                  },
                                                ),
                                              ),
                                              const Gap(10),
                                              Expanded(
                                                child: ActionButtons(
                                                    text: 'BFS',
                                                    onTap: () {
                                                      if (startIdx != null &&
                                                          endIdx != null) {
                                                        bfs();
                                                      } else if (startIdx ==
                                                              null &&
                                                          endIdx == null) {
                                                        customScaffoldMsg(
                                                            context,
                                                            'Select start and end index!');
                                                      } else if (startIdx ==
                                                          null) {
                                                        customScaffoldMsg(
                                                            context,
                                                            'Select start index!');
                                                      } else if (endIdx ==
                                                          null) {
                                                        customScaffoldMsg(
                                                            context,
                                                            'Select end index!');
                                                      }
                                                    }),
                                              )
                                            ],
                                          ),
                                        ]))
                        ]))
                  ])))
        ]));
  }
}

// * Custom scaffold message
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customScaffoldMsg(
    BuildContext context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(
    child: Text(
      msg,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  )));
}

// * Action row buttons
class ActionButtons extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const ActionButtons({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.purple.shade800),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          fixedSize: MaterialStateProperty.all<Size>(const Size(200, 30)),
        ),
        onPressed: onTap,
        child: Text(text));
  }
}

// * States box selector
class StatesBox extends StatefulWidget {
  final Color color;
  final String text;
  Function()? onTap;
  StatesBox({super.key, required this.color, required this.text, this.onTap});

  @override
  State<StatesBox> createState() => _StatesBoxState();
}

class _StatesBoxState extends State<StatesBox> {
  late Color currentColor;
  double size = 50;

  @override
  void initState() {
    super.initState();
    currentColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.text,
              style: const TextStyle(color: Colors.white, fontSize: 15)),
          const SizedBox(height: 10),
          // Check if the state is not 'Visited'
          if (widget.text != 'Path' && widget.text != 'Search')
            MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (val) {
                  setState(() {
                    currentColor = widget.color.withOpacity(0.5);
                  });
                },
                onExit: (val) {
                  setState(() {
                    currentColor = widget.color;
                  });
                },
                child: GestureDetector(
                    onTap: widget.onTap,
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                            color: currentColor,
                            border:
                                Border.all(color: Colors.white, width: 2)))))
          else
            // If the state is 'Visited', just display the container without MouseRegion and GestureDetector
            Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                    color: currentColor,
                    border: Border.all(color: Colors.white, width: 2)))
        ]);
  }
}
