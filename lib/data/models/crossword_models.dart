import 'package:flutter/material.dart';

class CrosswordCell {
  final int row;
  final int col;
  final String correctLetter;
  String currentLetter;
  final Color borderColor;
  final bool isPrefilled;

  CrosswordCell({
    required this.row,
    required this.col,
    required this.correctLetter,
    this.currentLetter = '',
    required this.borderColor,
    this.isPrefilled = false,
  }) {
    if (isPrefilled) {
      currentLetter = correctLetter;
    }
  }

  bool get isCorrect => currentLetter.toUpperCase() == correctLetter.toUpperCase();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CrosswordCell &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

enum CrosswordOrientation { horizontal, vertical }

class CrosswordWord {
  final String word;
  final List<CrosswordCell> cells;
  final String clueImagePath;
  final CrosswordOrientation orientation;

  CrosswordWord({
    required this.word,
    required this.cells,
    required this.clueImagePath,
    required this.orientation,
  });

  bool get isComplete => cells.every((cell) => cell.isCorrect);
}
