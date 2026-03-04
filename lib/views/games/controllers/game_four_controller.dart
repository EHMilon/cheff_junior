import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

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

  void toggleLetter(int index) {
    if (isError.value) {
      isError.value = false;
      selectedIndices.clear();
    }

    // Logic for multiple same letters:
    // If we tap a box, we add it to the sequence.
    // If we tap the SAME box that we just added, we treat it as an undo/remove.
    if (selectedIndices.isNotEmpty && selectedIndices.last == index) {
      selectedIndices.removeLast();
    } else {
      selectedIndices.add(index);
    }
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
        // All words found
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
