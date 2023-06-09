import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku ',
      home: SudokuGame(),
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

  void resetBoard() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        board[row][col] = 0;
        controllers[row][col].text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[600],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade700,
        title: const Text('Sudoku Solve'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                final rowStart = (index ~/ 3) * 3;
                final colStart = (index % 3) * 3;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final row = rowStart + (index ~/ 3);
                    final col = colStart + (index % 3);

                    // Utwórz kontroler tekstowy dla każdego pola
                    final controller = controllers[row][col];

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            int enteredValue = int.tryParse(value) ?? 0;

                            if (enteredValue >= 1 && enteredValue <= 9) {
                              // Aktualizuj wartość w tablicy planszy
                              setState(() {
                                board[row][col] = enteredValue;
                                Colors.black;
                              });
                            } else {
                              // Zeruj wartość w tablicy planszy, jeśli wartość jest niepoprawna
                              setState(() {
                                board[row][col] = 0;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              fontSize: 20.0,
                              color:
                                  (board[row][col] >= 1 && board[row][col] <= 9)
                                      ? Colors.yellowAccent
                                      : Colors.orange),
                        ),
                      ),
                    );
                  },
                  itemCount: 9,
                );
              },
              itemCount: 9,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                solveSudoku();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blueGrey.shade700,
                ),
              ),
              child: const Text('Solve Sudoku'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                resetBoard();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blueGrey.shade700,
                ),
              ),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
