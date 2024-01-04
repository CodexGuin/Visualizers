// ignore_for_file: must_be_immutable, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visualizer/widgets/header.dart';

class NeuralNetwork extends StatefulWidget {
  const NeuralNetwork({super.key});

  @override
  State<NeuralNetwork> createState() => _NeuralNetworkState();
}

class _NeuralNetworkState extends State<NeuralNetwork> {
  // * Variables
  int numberOfInputs = 3;
  int numberOfHiddenLayers = 1;
  int numberOfHiddenNeurons = 3;
  int numberOfOutputs = 1;
  int totalNumberOfNeurons = 0;
  late int totalColumnsToGenerate;

  // * Positions for neurons
  GlobalKey? _key;
  RenderBox? renderBoxSize;
  int upperBound = 0;
  int lowerBound = 0;

  void calculateNeuronPositions() {
    // Assuming a fixed width and height for the container
    double containerWidth = MediaQuery.of(context).size.width;
    double containerHeight = MediaQuery.of(context).size.height;

    // Margins and spacing
    double horizontalMargin = 50;
    //double verticalMargin = 50;
    double neuronSize = 50; // Diameter of each neuron
    double verticalSpacing = 20; // Vertical spacing between neurons

    // Calculate the width available for each layer
    double layerWidth =
        (containerWidth - 2 * horizontalMargin) / totalColumnsToGenerate;

    // Calculate positions
    List<Neuron> neurons = [];
    for (int layerIndex = 0;
        layerIndex < totalColumnsToGenerate;
        layerIndex++) {
      int numberOfNeuronsInLayer = getNumberOfNeuronsInLayer(layerIndex);
      double layerHeight = (numberOfNeuronsInLayer * neuronSize) +
          ((numberOfNeuronsInLayer - 1) * verticalSpacing);
      double startY =
          (containerHeight - layerHeight) / 2; // Center the layer vertically

      for (int neuronIndex = 0;
          neuronIndex < numberOfNeuronsInLayer;
          neuronIndex++) {
        double x = horizontalMargin + layerIndex * layerWidth;
        double y = startY + neuronIndex * (neuronSize + verticalSpacing);
        Offset position = Offset(x, y);

        NeuronType type =
            getNeuronType(layerIndex); // Implement this based on your logic
        neurons.add(
            Neuron(position: position, type: type, layerIndex: layerIndex));
      }
    }

    // Update your state or class variable with the calculated neurons
  }

  int getNumberOfNeuronsInLayer(int layerIndex) {
    if (layerIndex == 0) return numberOfInputs;
    if (layerIndex == totalColumnsToGenerate - 1) return numberOfOutputs;
    return numberOfHiddenNeurons;
  }

  NeuronType getNeuronType(int layerIndex) {
    if (layerIndex == 0) return NeuronType.input;
    if (layerIndex == totalColumnsToGenerate - 1) return NeuronType.output;
    return NeuronType.hidden;
  }

  // * Get container size using GlobalKey
  void getContainerSize() {
    // renderBoxSize = _key!.currentContext?.findRenderObject() as RenderBox?;
    if (renderBoxSize != null) {
      print('Size of container: ${renderBoxSize!.size}');
    } else {
      print('RenderBox is null');
    }
  }

  // ! Initializer
  @override
  void initState() {
    super.initState();
    totalNumberOfNeurons = numberOfInputs +
        (numberOfHiddenLayers * numberOfHiddenNeurons) +
        numberOfOutputs;
    totalColumnsToGenerate = numberOfHiddenLayers + 2;
    // * Then call getContainerSize in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) => getContainerSize());
  }

  // * Update variables, ft func ptr
  void updateVariableInputAction(Function(int) updateFunc, int newValue) {
    setState(() {
      updateFunc(newValue.clamp(1, 7));
      totalColumnsToGenerate = numberOfHiddenLayers + 2;

      getContainerSize();
    });
  }

  // * Reset all variables to original
  void resetAllVariables() {
    setState(() {
      numberOfInputs = 3;
      numberOfHiddenLayers = 1;
      numberOfHiddenNeurons = 3;
      numberOfOutputs = 1;

      getContainerSize();
    });
  }

  // * Update variables
  void updateNumberOfInputs(int newValue) {
    numberOfInputs = newValue;
  }

  void updateNumberOfOutputs(int newValue) {
    numberOfOutputs = newValue;
  }

  void updateNumberOfHiddenLayers(int newValue) {
    numberOfHiddenLayers = newValue;
  }

  void updateNumberOfHiddenNeurons(int newValue) {
    numberOfHiddenNeurons = newValue;
  }

  @override
  Widget build(BuildContext context) {
    calculateNeuronPositions();
    return Scaffold(
        backgroundColor: Headers().backgroundColorDark,
        appBar: Headers().defaultBar(
            leading: Headers().subpageButton(context),
            headerOne: 'Neural Network',
            headerTwo: 'Visualize how neural networks work'),
        body: Column(children: [
          Flexible(
              child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  //color: Colors.white.withOpacity(0.1), // ! Debugging
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                            flex: 3,
                            child: Container(
                                //color: Colors.white.withOpacity(0.1), // ! Debugging
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: List.generate(
                                        totalColumnsToGenerate,
                                        (index) => Flexible(
                                            child: Container(
                                                //color: Colors.white.withOpacity(0.01), // ! Debugging
                                                child: Center(
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Column(
                                                            children: [
                                                              Text(
                                                                  index == 0
                                                                      ? 'Input'
                                                                      : index ==
                                                                              totalColumnsToGenerate -
                                                                                  1
                                                                          ? 'Output'
                                                                          : totalColumnsToGenerate >
                                                                                  7
                                                                              ? 'HL $index'
                                                                              : 'Hidden Layer $index',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                              // * Display neurons
                                                              Flexible(
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          50),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: List
                                                                        .generate(
                                                                      index == 0
                                                                          ? numberOfInputs
                                                                          : index == totalColumnsToGenerate - 1
                                                                              ? numberOfOutputs
                                                                              : numberOfHiddenNeurons,
                                                                      (index2) {
                                                                        return Expanded(
                                                                          child:
                                                                              Container(
                                                                            /* key: (index == 0 && _key != null)
                                                                                ? _key
                                                                                : null, */
                                                                            width:
                                                                                50,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.transparent,
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(color: Colors.pinkAccent, width: 5),
                                                                            ),
                                                                          ).animate().fade(delay: ((index2 * 100) + (index * 100)).ms),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ]))))))))),
                        // * Action row
                        Flexible(
                            child: Container(
                                //color: Colors.white.withOpacity(0.01),
                                child: Center(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // * Inputs
                                    VariableInputsAction(
                                        text: 'Inputs',
                                        value: numberOfInputs,
                                        onIncrement: (val) =>
                                            updateVariableInputAction(
                                                updateNumberOfInputs, val),
                                        onDecrement: (val) =>
                                            updateVariableInputAction(
                                                updateNumberOfInputs, val)),
                                    // * Outputs
                                    VariableInputsAction(
                                        text: 'Outputs',
                                        value: numberOfOutputs,
                                        onIncrement: (val) =>
                                            updateVariableInputAction(
                                                updateNumberOfOutputs, val),
                                        onDecrement: (val) =>
                                            updateVariableInputAction(
                                                updateNumberOfOutputs, val)),
                                    // * Hidden layer
                                    VariableInputsAction(
                                        text: 'Hidden Layers',
                                        value: numberOfHiddenLayers,
                                        onIncrement: (val) =>
                                            updateVariableInputAction(
                                                updateNumberOfHiddenLayers,
                                                val),
                                        onDecrement: (val) =>
                                            updateVariableInputAction(
                                                updateNumberOfHiddenLayers,
                                                val)),
                                    // * Hidden neurons
                                    VariableInputsAction(
                                        text: 'Hidden Neurons',
                                        value: numberOfHiddenNeurons,
                                        onIncrement: (val) =>
                                            updateVariableInputAction(
                                                updateNumberOfHiddenNeurons,
                                                val),
                                        onDecrement: (val) =>
                                            updateVariableInputAction(
                                                updateNumberOfHiddenNeurons,
                                                val))
                                  ]),
                              IconButton(
                                  onPressed: resetAllVariables,
                                  icon: const Icon(Icons.undo_rounded,
                                      size: 50, color: Colors.white))
                            ])))),
                        CustomPaint(
                          painter: NeuralNetworkPainter(neurons: [
                            Neuron(
                                position: const Offset(950, -350),
                                type: NeuronType.input,
                                layerIndex: 0),
                            Neuron(
                                position: const Offset(100, 10),
                                type: NeuronType.hidden,
                                layerIndex: 1),
                            Neuron(
                                position: const Offset(0, 0),
                                type: NeuronType.output,
                                layerIndex: 3),
                          ]),
                          child: Container(),
                        )
                      ])))
        ]));
  }
}

class VariableInputsAction extends StatelessWidget {
  final String text;
  final int value;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  Color color;

  VariableInputsAction({
    super.key,
    required this.text,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(text,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: color)),
      IconButton(
          onPressed: () => onDecrement(value - 1),
          icon: const Icon(Icons.remove_rounded, color: Colors.purpleAccent)),
      Text(value.toString(),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      IconButton(
          onPressed: () => onIncrement(value + 1),
          icon: const Icon(Icons.add_rounded, color: Colors.purpleAccent))
    ]);
  }
}

class Neuron {
  Offset position; // Represents the x, y position of the neuron on the screen
  NeuronType type; // Type of the neuron (Input, Hidden, Output)
  int layerIndex; // The index of the layer this neuron belongs to

  Neuron(
      {required this.position, required this.type, required this.layerIndex});
}

enum NeuronType { input, hidden, output }

class NeuralConnectionPainter extends CustomPainter {
  final List<Neuron> layerOneNeurons;
  final List<Neuron> layerTwoNeurons;

  NeuralConnectionPainter(this.layerOneNeurons, this.layerTwoNeurons);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    for (var neuronOne in layerOneNeurons) {
      for (var neuronTwo in layerTwoNeurons) {
        canvas.drawLine(neuronOne.position, neuronTwo.position, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Can optimize by determining if repainting is necessary
  }
}

class NeuralNetworkPainter extends CustomPainter {
  final List<Neuron> neurons;
  final double neuronSize;

  NeuralNetworkPainter({required this.neurons, this.neuronSize = 50});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // Draw connections
    for (var neuron in neurons) {
      for (var connectedNeuron in getConnectedNeurons(neuron)) {
        paint.color = Colors.grey; // Connection line color
        paint.strokeWidth = 2;
        canvas.drawLine(neuron.position, connectedNeuron.position, paint);
      }
    }

    // Draw neurons
    for (var neuron in neurons) {
      paint.color =
          getNeuronColor(neuron.type); // Different color based on neuron type
      canvas.drawCircle(neuron.position, neuronSize / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // In a real app, you would optimize this
  }

  List<Neuron> getConnectedNeurons(Neuron neuron) {
    // Example logic, adjust based on your neural network structure
    return neurons.where((n) => n.layerIndex == neuron.layerIndex + 1).toList();
  }

  Color getNeuronColor(NeuronType type) {
    switch (type) {
      case NeuronType.input:
        return Colors.blue;
      case NeuronType.hidden:
        return Colors.green;
      case NeuronType.output:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
