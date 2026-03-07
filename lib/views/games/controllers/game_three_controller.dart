import 'package:chef_junior/data/models/crossword_models.dart';
import 'package:chef_junior/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameThreeController extends GetxController with WidgetsBindingObserver {
  final RxMap<String, CrosswordCell> grid = <String, CrosswordCell>{}.obs;
  final RxList<CrosswordWord> words = <CrosswordWord>[].obs;

  final RxBool isGameComplete = false.obs;
  final RxBool isKeyboardVisible = false.obs;

  double _initialBottomInset = 0;

  @override
  void onInit() {
    super.onInit();
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
    isKeyboardVisible.value = currentBottomInset > _initialBottomInset + 50;
  }

  void _initializeGame() {
    const greenBorder = Color(0xFFC0CA33);
    const orangeBorder = Color(0xFFFFB257);

    // 1. GARLIC (Vertical)
    final garlicCells = <CrosswordCell>[];
    const garlicCol = 0;
    const garlicWordStr = "GARLIC";
    const garlicStartRow = 0;
    for (int i = 0; i < garlicWordStr.length; i++) {
      garlicCells.add(
        _getOrCreateCell(
          garlicStartRow + i,
          garlicCol,
          garlicWordStr[i],
          greenBorder,
          isPrefilled: i == 2 || i == 5, // 'R' at 2, 'C' at 5
        ),
      );
    }
    final garlicWord = CrosswordWord(
      word: garlicWordStr,
      cells: garlicCells,
      clueImagePath: "assets/images/fruites/garlic.png",
      orientation: CrosswordOrientation.vertical,
    );

    // 2. CHEESE (Horizontal)
    final cheeseCells = <CrosswordCell>[];
    const cheeseRow = 5; // Intersects GARLIC at 'C' (row 5, col 0)
    const cheeseWordStr = "CHEESE";
    for (int i = 0; i < cheeseWordStr.length; i++) {
      cheeseCells.add(
        _getOrCreateCell(
          cheeseRow,
          i,
          cheeseWordStr[i],
          orangeBorder,
          isPrefilled: i == 0 || i == 2, // 'C' at 0, 'E' at 2
        ),
      );
    }
    final cheeseWord = CrosswordWord(
      word: cheeseWordStr,
      cells: cheeseCells,
      clueImagePath: "assets/images/fruites/cheese.png",
      orientation: CrosswordOrientation.horizontal,
    );

    // 3. EGG (Vertical)
    final eggCells = <CrosswordCell>[];
    const eggCol = 2; // Intersects CHEESE at 'E' (row 5, col 2)
    const eggWordStr = "EGG";
    const eggStartRow = 5;
    for (int i = 0; i < eggWordStr.length; i++) {
      eggCells.add(
        _getOrCreateCell(
          eggStartRow + i,
          eggCol,
          eggWordStr[i],
          greenBorder,
          isPrefilled: i == 0, // 'E' at 0
        ),
      );
    }
    final eggWord = CrosswordWord(
      word: eggWordStr,
      cells: eggCells,
      clueImagePath: "assets/images/fruites/egg.png",
      orientation: CrosswordOrientation.vertical,
    );

    words.assignAll([garlicWord, cheeseWord, eggWord]);
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
