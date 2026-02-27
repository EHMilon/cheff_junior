import 'package:chef_junior/core/models/crossword_models.dart';
import 'package:chef_junior/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameOneController extends GetxController {
  final RxMap<String, CrosswordCell> grid = <String, CrosswordCell>{}.obs;
  final RxList<CrosswordWord> words = <CrosswordWord>[].obs;

  final RxBool isGameComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeGame();
  }

  void _initializeGame() {
    // Colors based on design (approximate)
    const orangeBorder = Color(0xFFFFB257);
    const brownBorder = Color(0xFFC09C76);
    const magentaBorder = Color(0xFFF062F0);
    const oliveBorder = Color(0xFFD4E157);

    // Define Words
    // 1. ONION (Horizontal)
    final onionCells = <CrosswordCell>[];
    const onionRow = 5;
    const onionWordStr = "ONION";
    for (int i = 0; i < onionWordStr.length; i++) {
      onionCells.add(
        _getOrCreateCell(
          onionRow,
          i,
          onionWordStr[i],
          magentaBorder,
          isPrefilled: i == 0 || i == 2 || i == 3,
        ),
      );
    }
    final onionWord = CrosswordWord(
      word: onionWordStr,
      cells: onionCells,
      clueImagePath: "assets/images/fruites/onion.png",
      orientation: CrosswordOrientation.horizontal,
    );

    // 2. GARLIC (Vertical)
    final garlicCells = <CrosswordCell>[];
    const garlicCol = 2;
    const garlicWordStr = "GARLIC";
    const garlicStartRow = 1;
    for (int i = 0; i < garlicWordStr.length; i++) {
      garlicCells.add(
        _getOrCreateCell(
          garlicStartRow + i,
          garlicCol,
          garlicWordStr[i],
          orangeBorder,
          isPrefilled: i == 0 || (garlicStartRow + i == onionRow),
        ),
      );
    }
    final garlicWord = CrosswordWord(
      word: garlicWordStr,
      cells: garlicCells,
      clueImagePath: "assets/images/fruites/garlic.png",
      orientation: CrosswordOrientation.vertical,
    );

    // 3. MUSHROOM (Vertical)
    final mushroomCells = <CrosswordCell>[];
    const mushroomCol = 3;
    const mushroomWordStr = "MUSHROOM";
    const mushroomStartRow = 0;
    for (int i = 0; i < mushroomWordStr.length; i++) {
      mushroomCells.add(
        _getOrCreateCell(
          mushroomStartRow + i,
          mushroomCol,
          mushroomWordStr[i],
          brownBorder,
          isPrefilled: mushroomStartRow + i == onionRow,
        ),
      );
    }
    final mushroomWord = CrosswordWord(
      word: mushroomWordStr,
      cells: mushroomCells,
      clueImagePath: "assets/images/fruites/mushroom.png",
      orientation: CrosswordOrientation.vertical,
    );

    // 4. OLIVE (Vertical)
    final oliveCells = <CrosswordCell>[];
    const oliveCol = 0;
    const oliveWordStr = "OLIVE";
    const oliveStartRow = 5; // Intersects with Onion at (5,0)
    for (int i = 0; i < oliveWordStr.length; i++) {
      oliveCells.add(
        _getOrCreateCell(
          oliveStartRow + i,
          oliveCol,
          oliveWordStr[i],
          oliveBorder,
          isPrefilled: i == 0,
        ),
      );
    }
    final oliveWord = CrosswordWord(
      word: oliveWordStr,
      cells: oliveCells,
      clueImagePath: "assets/images/fruites/olive.png",
      orientation: CrosswordOrientation.vertical,
    );

    words.assignAll([onionWord, garlicWord, mushroomWord, oliveWord]);
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
      // Intersection! Use existing cell but update border color if it's horizontal?
      // For now, magenta (onion) takes precedence if it's horizontal
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
