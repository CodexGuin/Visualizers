// ignore_for_file: constant_identifier_names, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:visualizer/widgets/header.dart';

enum ChessPieces {
  BLACK_PAWN,
  BLACK_KNIGHT,
  BLACK_BISHOP,
  BLACK_ROOK,
  BLACK_QUEEN,
  BLACK_KING,
  WHITE_PAWN,
  WHITE_KNIGHT,
  WHITE_BISHOP,
  WHITE_ROOK,
  WHITE_QUEEN,
  WHITE_KING,
  EMPTY
}

Color lightSquareColor = Colors.white;
Color darkSquareColor = Colors.grey.shade900;

class Chess extends StatefulWidget {
  const Chess({super.key});

  @override
  State<Chess> createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  // * FEN text controller
  final _fenTextController = TextEditingController();

  final ValueNotifier<List<Widget>> _chessBoardNotifier = ValueNotifier([]);

  // * FEN string validation (Todo)

  // * FEN notation for starting position
  String FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  String returnAssetPath(ChessPieces piece) {
    // Convert the enum value to string and split by '.'
    String enumValue = piece.toString().split('.')[1];

    // Determine the color prefix based on the enum value
    String colorPrefix = enumValue.startsWith('BLACK_') ? 'b' : 'w';

    // Get the piece type (e.g., PAWN, KNIGHT, BISHOP, etc.)
    String pieceType = enumValue.split('_')[1].toLowerCase();

    // Capitalize the first letter of the piece type
    String capitalizedPieceType =
        pieceType[0].toUpperCase() + pieceType.substring(1).toLowerCase();

    // Return the corresponding asset path
    return 'assets/chessPieces/$colorPrefix$capitalizedPieceType.png';
  }

  List<Widget> pieces = [];

  List<Widget> decodeFEN(String fen) {
    // Split the FEN string and take only the board layout part
    String boardLayout = fen.split(' ')[0];

    // If FEN is invalid, return current pieces list (return pieces)

    for (var char in Characters(boardLayout)) {
      if (char == ' ') {
        break;
      }

      if (RegExp(r'\d').hasMatch(char)) {
        int emptySquares = int.parse(char);
        pieces.addAll(List.generate(emptySquares,
            (_) => Container())); // Add empty containers for empty squares
        continue;
      }

      ChessPieces piece;

      // Set each piece
      switch (char) {
        case 'r':
          piece = ChessPieces.BLACK_ROOK;
          break;
        case 'n':
          piece = ChessPieces.BLACK_KNIGHT;
          break;
        case 'b':
          piece = ChessPieces.BLACK_BISHOP;
          break;
        case 'q':
          piece = ChessPieces.BLACK_QUEEN;
          break;
        case 'k':
          piece = ChessPieces.BLACK_KING;
          break;
        case 'p':
          piece = ChessPieces.BLACK_PAWN;
          break;
        case 'R':
          piece = ChessPieces.WHITE_ROOK;
          break;
        case 'N':
          piece = ChessPieces.WHITE_KNIGHT;
          break;
        case 'B':
          piece = ChessPieces.WHITE_BISHOP;
          break;
        case 'Q':
          piece = ChessPieces.WHITE_QUEEN;
          break;
        case 'K':
          piece = ChessPieces.WHITE_KING;
          break;
        case 'P':
          piece = ChessPieces.WHITE_PAWN;
          break;
        default:
          continue;
      }

      pieces.add(Image.asset(returnAssetPath(piece)));
    }

    return pieces;
  }

  @override
  void initState() {
    super.initState();
    decodeFEN(FEN);
  }

  @override
  void dispose() {
    _fenTextController.dispose();
    _chessBoardNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Headers().backgroundColorDark,
      appBar: Headers().defaultBar(
          headerOne: 'Chess',
          headerTwo: 'Simple chess engine',
          leading: Headers().subpageButton(context)),
      body: Column(
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // * FEN text field
                  Flexible(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        SizedBox(
                          width: 500,
                          child: TextField(
                              decoration: const InputDecoration(
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.center,
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter FEN notation',
                                  labelStyle: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              controller: _fenTextController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              onSubmitted: (value) {
                                setState(() {
                                  pieces.clear();
                                  FEN = value;
                                  pieces = decodeFEN(FEN);
                                  for (var a in pieces) {
                                    print(a);
                                  }
                                  print(pieces.length);
                                });
                              }),
                        )
                      ])),
                  // * Chess grid
                  Flexible(
                    flex: 8,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5)),
                      //color: Colors.amber,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ValueListenableBuilder<List<Widget>>(
                          valueListenable: _chessBoardNotifier,
                          builder: (context, value, child) {
                            return GridView.count(
                              crossAxisCount: 8,
                              children: List.generate(
                                64,
                                (index) {
                                  // Calculate row and column from index
                                  int row = index ~/ 8;
                                  int col = index % 8;

                                  // Alternate colors
                                  bool isBlack = (row + col) % 2 == 1;

                                  // * Each cell
                                  return ChessboardCell(
                                    isBlack: isBlack,
                                    child: pieces[index],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // * Action row
                  Flexible(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        //color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ActionButtons(
                              text: 'Debug',
                              onPressed: () {
                                setState(() {
                                  pieces.clear();
                                  FEN =
                                      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR';
                                  pieces = decodeFEN(FEN);
                                  for (var a in pieces) {
                                    print(a);
                                  }
                                  print(pieces.length);
                                });
                              },
                            ),
                            const Gap(10),
                            ActionButtons(
                              text: 'Board State',
                              onPressed: () {
                                print(pieces.length);
                                for (int i = 0; i < pieces.length; i++) {
                                  if (i % 8 == 0) {
                                    print('');
                                  } else {
                                    print(pieces[i]);
                                  }
                                }
                              },
                            ),
                            const Gap(10),
                            ActionButtons(
                                text: 'Clear Board',
                                onPressed: () {
                                  setState(() {
                                    pieces = List.generate(
                                        64, (index) => Container());
                                    FEN = '';
                                  });
                                }),
                            const Gap(10),
                            ActionButtons(text: 'Test', onPressed: () {})
                          ],
                        ),
                      ),
                    ),
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

/* // * Original cell child
Container(
  color: isBlack
      ? darkSquareColor
      : lightSquareColor,
  child: Center(
    child: Stack(
      children: [
        Center(
          child: index % 8 == 0
              ? Padding(
                  padding:
                      const EdgeInsets.all(
                          5),
                  child: Align(
                    alignment:
                        Alignment.topLeft,
                    child: Text(
                      index.toString(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(
                                    context)
                                .size
                                .width *
                            0.01,
                        color: isBlack
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        Center(
          child: Container(
            margin:
                const EdgeInsets.all(10),
            child: Center(
              child: pieces[
                  index], // Directly use the widget from the pieces list
            ),
          ),
        ),
      ],
    ),
  ),
);
*/

class ChessboardCell extends StatefulWidget {
  final bool isBlack;
  final Widget child;
  const ChessboardCell({super.key, required this.isBlack, required this.child});

  @override
  State<ChessboardCell> createState() => _ChessboardCellState();
}

class _ChessboardCellState extends State<ChessboardCell> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Container(
          color: isHovered
              ? Colors.green
              : (widget.isBlack ? darkSquareColor : lightSquareColor),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: widget.child,
          ),
        ));
  }
}

class ActionButtons extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final Color bgColor, textColor;
  const ActionButtons(
      {super.key,
      this.onPressed,
      required this.text,
      this.bgColor = Colors.white,
      this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bgColor),
          foregroundColor: MaterialStateProperty.all(textColor),
          fixedSize: MaterialStateProperty.all(Size(
              MediaQuery.of(context).size.width * 0.1,
              MediaQuery.of(context).size.height * 0.05))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
