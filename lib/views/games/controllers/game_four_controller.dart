import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/local_stoage_service.dart';

class GameFourController extends GetxController {
  final List<String> wordsToFind = ['Pasta', 'Olive', 'Onion'];

  // Grid containing all necessary letters for the words
  final List<String> gridLetters = [
    'Q',
    'W',
    'E',
    'R',
    'T',
    'Y',
    'U',
    'I',
    'O',
    'P',
    'A',
    'S',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L',
    'Z',
    'X',
    'C',
    'V',
    'B',
    'N',
    'M',
  ];

  final RxList<int> selectedIndices = <int>[].obs;
  final RxInt currentWordIndex = 0.obs;
  final RxList<String> foundWords = <String>[].obs;
  final RxBool isError = false.obs;

  String get currentWordTarget => wordsToFind[currentWordIndex.value];

  String get currentSelectedLetters {
    return selectedIndices.map((index) => gridLetters[index]).join('');
  }

  /// Selects a letter at the given index (always adds, no toggle)
  /// This allows selecting the same letter multiple times for words with duplicate letters
  void selectLetter(int index) {
    if (isError.value) {
      isError.value = false;
      selectedIndices.clear();
    }
    selectedIndices.add(index);
  }

  /// Undo the last selected letter
  void undoLastLetter() {
    if (selectedIndices.isNotEmpty) {
      selectedIndices.removeLast();
    }
  }

  /// Clear all selected letters
  void clearAllLetters() {
    selectedIndices.clear();
    isError.value = false;
  }

  void checkWord() async {
    String selectedWord = currentSelectedLetters.toLowerCase();
    String targetWord = currentWordTarget.toLowerCase();

    if (selectedWord == targetWord) {
      foundWords.add(wordsToFind[currentWordIndex.value]);
      selectedIndices.clear();
      isError.value = false;

      if (currentWordIndex.value < wordsToFind.length - 1) {
        currentWordIndex.value++;
      } else {
        // All words found - save progress for word search game (1 game completed)
        await LocalStorageService.instance.setWordSearchProgress(1);
        await Future.delayed(const Duration(milliseconds: 500));
        Get.toNamed(AppRoutes.GAME_FINISH);
      }
    } else {
      isError.value = true;
      // Keep error state for 1 second, then clear
      await Future.delayed(const Duration(seconds: 1));
      if (isError.value) {
        isError.value = false;
        selectedIndices.clear();
      }
    }
  }

  String get counterDisplay => '${foundWords.length}/${wordsToFind.length}';

  bool isWordFound(String word) {
    return foundWords.contains(word);
  }
}
