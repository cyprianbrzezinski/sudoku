import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SudokuGame(),
    );
  }
}

class SudokuGame extends StatefulWidget {
  const SudokuGame({super.key});

  @override
  _SudokuGameState createState() => _SudokuGameState();
}

class _SudokuGameState extends State<SudokuGame> {
  List<List<int>> board = List.generate(
    9,
    (_) => List.filled(9, 0),
  );

  
  List<List<TextEditingController>> controllers = List.generate(
    9,
    (_) => List.generate(9, (_) => TextEditingController()),
  );


  void generateBoard() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        int value = (row * 3 + row ~/ 3 + col) % 9 + 1;
        board[row][col] = value;
        controllers[row][col].text = value.toString();
      }
    }


  }

  bool solveSudoku() {
    return solve(0, 0);
  }

  bool solve(int row, int col) {
    if (row == 9) {
      return true;
    }

    if (board[row][col] != 0) {
      if (col == 8) {
        return solve(row + 1, 0);
      } else {
        return solve(row, col + 1);
      }
    }

    for (int num = 1; num <= 9; num++) {
      if (isValid(row, col, num)) {
        board[row][col] = num;
        controllers[row][col].text = num.toString();
        if (col == 8) {
          if (solve(row + 1, 0)) {
            return true;
          }
        } else {
          if (solve(row, col + 1)) {
            return true;
          }
        }

        board[row][col] = 0;
        controllers[row][col].text = '';
      }
    }

    return false;
  }

  bool isValid(int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == num) {
        return false;
      }
    }

    for (int i = 0; i < 9; i++) {
      if (board[i][col] == num) {
        return false;
      }
    }

    int subgridRow = row - row % 3;
    int subgridCol = col - col % 3;
    for (int i = subgridRow; i < subgridRow + 3; i++) {
      for (int j = subgridCol; j < subgridCol + 3; j++) {
        if (board[i][j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  void resetBoard() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        board[row][col] = 0;
        controllers[row][col].text = '';
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text('Sudoku Solve'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
        
            const SizedBox(height: 16.0),
            GridView.count(
              crossAxisCount: 9,
              shrinkWrap: true,
              children: List.generate(81, (index) {
                final row = index ~/ 9;
                final col = index % 9;
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: TextFormField(
                      controller: controllers[row][col],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // Aktualizuj wartość w tablicy planszy
                        board[row][col] = int.tryParse(value) ?? 0;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                solveSudoku();
              },
              child: const Text('Solve Sudoku'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                resetBoard();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}