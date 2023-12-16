// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:visualizer/widgets/header.dart';

class Sort extends StatefulWidget {
  const Sort({super.key});

  @override
  State<Sort> createState() => _SortState();
}

class _SortState extends State<Sort> {
  // * List of random numbers
  List<int> ranNums = [];
  late int maxNumInList;
  late double maxWidth = 700, maxHeight = 500;
  bool isCute = false;
  bool playAnimation = false;

  // * Function to handle the animation state
  void triggerAnimation() {
    setState(() {
      playAnimation = true;
    });

    // Optional: reset the animation state after a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        playAnimation = false;
      });
    });
  }

  // * Steps
  // * 1 - Generate random number list
  // * 2 - Get largest number x
  // * 3 - Max heigh possible will be x normalized to 500
  // * Example x = 100, maxheight will be 500, which represents the value of 100
  // * Each unit is 500/100 = 5
  // * 4 - Every height will be 5 * x
  // * 5 - For width, we take 700 / length of list

  // Todo: Adjustable number of random numbers

  // * Get height function
  double getHeight(int x) {
    return (x / maxNumInList * 500)
        .toDouble(); // Ensure floating-point division
  }

  // * Get width function
  double getWidth(int idx) {
    return 700 / ranNums.length;
  }

  // * Generate random numbers
  void generateRandomNumbers() {
    setState(() {
      ranNums.clear();
      for (int i = 0; i < 20; i++) {
        ranNums.add(Random().nextInt(1000) + 20);
      }
      maxNumInList = ranNums.fold(0, (max, e) => e > max ? e : max);
      triggerAnimation();
    });
  }

  // * Sort algorithm
  void sort() {
    setState(() {
      ranNums.sort((a, b) => a - b);
      triggerAnimation();
    });
  }

  // * Sort with animation
  void sortWithAnimation() {
    setState(() {
      int temp = ranNums[0];
      ranNums[0] = ranNums[1];
      ranNums[1] = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    maxNumInList = ranNums.fold(0,
        (currentMax, element) => element > currentMax ? element : currentMax);
    generateRandomNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Headers().backgroundColorDark,
        appBar: Headers().defaultBar(leading: Headers().subpageButton(context)),
        body: Column(children: [
          Headers().headerOne('Sort'),
          Headers().headerTwo('Visualize sorting algorithms'),
          Flexible(
              child: Column(children: [
            // * Column visualizer
            Flexible(
                flex: 4,
                child: Center(
                    child: Center(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                height: maxHeight,
                                width: maxWidth,
                                child: Row(
                                    children: List.generate(
                                        ranNums.length,
                                        (index) => Animate(
                                            effects:
                                                playAnimation // Conditional animation
                                                    ? [
                                                        ThenEffect(
                                                            delay: (index * 25)
                                                                .ms),
                                                        FadeEffect(
                                                            duration: 100
                                                                .milliseconds,
                                                            curve:
                                                                const ElasticInOutCurve()),
                                                        ScaleEffect(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            begin: const Offset(
                                                                1, 0),
                                                            end: const Offset(
                                                                1, 1),
                                                            curve: Curves
                                                                .easeInOut,
                                                            duration:
                                                                0.5.seconds)
                                                      ]
                                                    : [],
                                            child: RanCol(
                                                isCute: isCute,
                                                value: ranNums[index],
                                                height:
                                                    getHeight(ranNums[index]),
                                                width: getWidth(index)))))))))),

            // * Action bar
            Flexible(
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                  // * Randomize list
                  ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(100, 50)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF6750A4)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                      onPressed: generateRandomNumbers,
                      child: const Text('Random list')),
                  const Gap(10),

                  // * Instantly sort list (no animation)
                  ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(100, 50)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF6750A4)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                      onPressed: sort,
                      child: const Text('Instant Sort')),
                  const Gap(10),

                  // * Test button ()
                  ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(100, 50)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF6750A4)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                      onPressed: sortWithAnimation,
                      child: const Text('Test')),
                  const Gap(10),

                  // * Toggle between cute and normal style
                  ToggleSwitch(
                      minHeight: 40,
                      initialLabelIndex: isCute ? 0 : 1,
                      activeBgColor: const [Color(0xFF6750A4)],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.white60,
                      animate: true,
                      curve: Easing.standard,
                      labels: const ['Cute', 'Normal'],
                      onToggle: (index) {
                        setState(() {
                          isCute = index ==
                              0; // Assuming 'Cute' is at index 0 and 'Normal' at index 1
                        });
                        print(isCute);
                      })
                ])))
          ]))
        ]));
  }
}

// * Individual columns
class RanCol extends StatefulWidget {
  final bool? isCute;
  final double height, width;
  final int value;
  const RanCol(
      {super.key,
      required this.height,
      required this.width,
      required this.value,
      required this.isCute});

  @override
  State<RanCol> createState() => _RanColState();
}

class _RanColState extends State<RanCol> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            child: Center(
                child: widget.isCute == true
                    ?
                    // * Cute style
                    Align(
                        alignment: Alignment.topCenter,
                        child: Column(children: [
                          // * Eyes
                          Row(children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 5, right: 5),
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5))),
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 5, right: 5),
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)))
                          ]),
                          const Gap(5),
                          // * Mouth
                          Container(
                              width: 15,
                              height: 5,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  shape: BoxShape.circle))
                        ]))
                    :
                    // * Normal style
                    Text(widget.value.toString(),
                        style: const TextStyle(color: Colors.white)))));
  }
}
