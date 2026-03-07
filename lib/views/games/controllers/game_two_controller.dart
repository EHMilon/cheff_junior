import 'package:chef_junior/data/models/crossword_models.dart';
import 'package:chef_junior/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameTwoController extends GetxController with WidgetsBindingObserver {
  final RxMap<String, CrosswordCell> grid = <String, CrosswordCell>{}.obs;
  final RxList<CrosswordWord> words = <CrosswordWord>[].obs;

  final RxBool isGameComplete = false.obs;
  final RxBool isKeyboardVisible = false.obs;

  double _initialBottomInset = 0;

  @override
  void onInit() {
    super.onInit();
    // Defer to post-frame callback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = Get.context;
      if (ctx != null) {
        _initialBottomInset = View.of(ctx).viewInsets.bottom;
      }
    });
    WidgetsBinding.instance.addObserver(this);
    _initializeGame();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final ctx = Get.context;
    if (ctx == null) return;
    final double currentBottomInset = View.of(ctx).viewInsets.bottom;
    // Keyboard is visible if current inset is significantly larger than initial
    isKeyboardVisible.value = currentBottomInset > _initialBottomInset + 50;
  }

  void _initializeGame() {
    // Colors based on design (approximate)
    const redBorder = Color(0xFFE53935);
    const orangeBorder = Color(0xFFFFB257);
    const yellowBorder = Color(0xFFC0CA33);

    // 1. CHICKEN (Horizontal)
    final chickenCells = <CrosswordCell>[];
    const chickenRow = 4;
    const chickenWordStr = "CHICKEN";
    for (int i = 0; i < chickenWordStr.length; i++) {
      chickenCells.add(
        _getOrCreateCell(
          chickenRow,
          i,
          chickenWordStr[i],
          orangeBorder,
          isPrefilled: i == 0 || i == 2 || i == 6,
        ),
      );
    }
    final chickenWord = CrosswordWord(
      word: chickenWordStr,
      cells: chickenCells,
      clueImagePath: "assets/images/fruites/chicken.png",
      orientation: CrosswordOrientation.horizontal,
    );

    // 2. TOMATO (Horizontal)
    final tomatoCells = <CrosswordCell>[];
    const tomatoRow = 2;
    const tomatoColOffset = 1;
    const tomatoWordStr = "TOMATO";
    for (int i = 0; i < tomatoWordStr.length; i++) {
      tomatoCells.add(
        _getOrCreateCell(
          tomatoRow,
          i + tomatoColOffset,
          tomatoWordStr[i],
          redBorder,
          isPrefilled: i == 0,
        ),
      );
    }
    final tomatoWord = CrosswordWord(
      word: tomatoWordStr,
      cells: tomatoCells,
      clueImagePath: "assets/images/fruites/tomato.png",
      orientation: CrosswordOrientation.horizontal,
    );

    // 3. OLIVE (Vertical)
    final oliveCells = <CrosswordCell>[];
    const oliveCol = 2;
    const oliveWordStr = "OLIVE";
    const oliveStartRow =
        2; // Intersects with Tomato at (2,2) and Chicken at (4,2)
    for (int i = 0; i < oliveWordStr.length; i++) {
      oliveCells.add(
        _getOrCreateCell(
          oliveStartRow + i,
          oliveCol,
          oliveWordStr[i],
          yellowBorder,
          isPrefilled: i == 4, // 'E' at the bottom
        ),
      );
    }
    final oliveWord = CrosswordWord(
      word: oliveWordStr,
      cells: oliveCells,
      clueImagePath: "assets/images/fruites/olive.png",
      orientation: CrosswordOrientation.vertical,
    );

    words.assignAll([tomatoWord, chickenWord, oliveWord]);
  }

  CrosswordCell _getOrCreateCell(
    int row,
    int col,
    String letter,
    Color color, {
    bool isPrefilled = false,
  }) {
    final key = "$row,$col";
    if (grid.containsKey(key)) {
      // If we encounter a cell that already exists (intersection),
      // update its prefilled status if the new pass asks for it.
      if (isPrefilled && !grid[key]!.isPrefilled) {
        final cell = CrosswordCell(
          row: row,
          col: col,
          correctLetter: letter,
          borderColor: grid[key]!.borderColor,
          isPrefilled: true,
        );
        grid[key] = cell;
        return cell;
      }
      return grid[key]!;
    }
    final cell = CrosswordCell(
      row: row,
      col: col,
      correctLetter: letter,
      borderColor: color,
      isPrefilled: isPrefilled,
    );
    grid[key] = cell;
    return cell;
  }

  void onLetterInput(int row, int col, String letter) {
    final key = "$row,$col";
    if (grid.containsKey(key) && !grid[key]!.isPrefilled) {
      grid[key]!.currentLetter = letter;
      grid.refresh();
      _checkGameCompletion();
    }
  }

  void _checkGameCompletion() {
    isGameComplete.value = words.every((word) => word.isComplete);
  }

  void onDoneTap() {
    if (isGameComplete.value) {
      Get.toNamed(AppRoutes.GAME_FINISH);
    } else {
      Get.snackbar(
        "Try Again",
        "Fill all the letters correctly to finish!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
