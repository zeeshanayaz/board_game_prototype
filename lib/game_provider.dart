import 'dart:math';

import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  List<Color> board = List.generate(25, (index) => Colors.white);
  bool isPlayerOneTurn = true;
  String? winner;
  Random random = Random();

  void placeChip(int index) {
    if (board[index] == Colors.white && winner == null && isPlayerOneTurn) {
      board[index] = Colors.blue;
      isPlayerOneTurn = false;
      checkWin();
      notifyListeners();
      if (winner == null) {
        Future.delayed(const Duration(milliseconds: 500), botMove);
      }
    }
  }

  void botMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == Colors.white) {
        availableMoves.add(i);
      }
    }
    if (availableMoves.isNotEmpty) {
      int botIndex = availableMoves[random.nextInt(availableMoves.length)];
      board[botIndex] = Colors.red;
      checkWin();
      isPlayerOneTurn = true;
      notifyListeners();
    }
  }

  void checkWin() {
    List<List<int>> winPatterns = [
      // Horizontal
      [0, 1, 2, 3, 4], [5, 6, 7, 8, 9], [10, 11, 12, 13, 14], [15, 16, 17, 18, 19], [20, 21, 22, 23, 24],
      // Vertical
      [0, 5, 10, 15, 20], [1, 6, 11, 16, 21], [2, 7, 12, 17, 22], [3, 8, 13, 18, 23], [4, 9, 14, 19, 24],
      // Diagonal
      [0, 6, 12, 18, 24], [4, 8, 12, 16, 20]
    ];

    for (var pattern in winPatterns) {
      Color first = board[pattern[0]];
      if (first != Colors.white && pattern.every((index) => board[index] == first)) {
        winner = first == Colors.blue ? 'Player 1' : 'Bot';
        notifyListeners();
        return;
      }
    }
  }

  void resetGame() {
    board = List.generate(25, (index) => Colors.white);
    isPlayerOneTurn = true;
    winner = null;
    notifyListeners();
  }
}