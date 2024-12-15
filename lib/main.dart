import 'package:flutter/material.dart';

void main() {
  runApp(PuzzleGameApp());
}

class PuzzleGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PuzzleScreen(),
    );
  }
}

class PuzzleScreen extends StatefulWidget {
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  // Create a 3x3 puzzle
  List<int> puzzle = List.generate(9, (index) => index);

  @override
  void initState() {
    super.initState();
    shufflePuzzle();
  }

  // Shuffle the puzzle pieces
  void shufflePuzzle() {
    puzzle.shuffle();
    setState(() {});
  }

  // Get the position of the empty space
  int getEmptySpaceIndex() {
    return puzzle.indexOf(0);
  }

  // Check if the puzzle is solved
  bool isSolved() {
    for (int i = 0; i < puzzle.length; i++) {
      if (puzzle[i] != i) {
        return false;
      }
    }
    return true;
  }

  // Handle tile click to move it
  void moveTile(int index) {
    int emptyIndex = getEmptySpaceIndex();

    // Check if the tile is adjacent to the empty space
    if (index == emptyIndex - 1 || index == emptyIndex + 1 || index == emptyIndex - 3 || index == emptyIndex + 3) {
      setState(() {
        // Swap the clicked tile with the empty space
        puzzle[emptyIndex] = puzzle[index];
        puzzle[index] = 0;
      });
    }

    if (isSolved()) {
      // Show a dialog if the puzzle is solved
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Puzzle Solved!'),
            content: Text('Congratulations! You have solved the puzzle.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  shufflePuzzle(); // Shuffle puzzle again
                },
                child: Text('Play Again'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Puzzle Game')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Puzzle Grid
          GridView.builder(
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => moveTile(index),
                child: Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: puzzle[index] == 0
                        ? Container()
                        : Text(
                            '${puzzle[index]}',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                  ),
                ),
              );
            },
            shrinkWrap: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: shufflePuzzle,
            child: Text('Shuffle'),
          ),
        ],
      ),
    );
  }
}
