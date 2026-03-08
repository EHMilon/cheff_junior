import 'package:get/get.dart';
import '../../../core/controllers/connectivity_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/local_stoage_service.dart';

class GameModel {
  final String id;
  final String title;
  final String image;
  final double progress;

  GameModel({
    required this.id,
    required this.title,
    required this.image,
    required this.progress,
  });
}

class GamesController extends GetxController {
  final ConnectivityController _connectivityController =
      Get.find<ConnectivityController>();

  var isLoading = true.obs;
  var isOnline = true.obs;
  var games = <GameModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    isOnline.value = _connectivityController.isOnline.value;
    ever(_connectivityController.isOnline, (bool connected) {
      isOnline.value = connected;
    });
    loadGames();
  }

  /// Called when returning to this view - refreshes progress without loading delay
  void refreshProgress() {
    _updateGamesProgress();
  }

  /// Updates game progress from local storage (fast, no loading state)
  void _updateGamesProgress() {
    final crosswordProgress = LocalStorageService.instance.getCrosswordProgress();
    final wordSearchProgress = LocalStorageService.instance.getWordSearchProgress();

    games.value = [
      GameModel(
        id: '1',
        title: 'crossword_puzzle'.tr,
        image: 'assets/images/1st_game_image.png',
        progress: crosswordProgress / 3.0, // 3 games in crossword
      ),
      GameModel(
        id: '2',
        title: 'word_search'.tr,
        image: 'assets/images/2nd_game_image.png',
        progress: wordSearchProgress / 1.0, // 1 game in word search
      ),
    ];
  }

  Future<void> loadGames() async {
    try {
      isLoading.value = true;
      // Add a 1s delay as requested in user_global rules
      await Future.delayed(const Duration(seconds: 1));

      // Get progress from local storage
      // Crossword: 3 games total, progress is 0-3
      // Word Search: 1 game total, progress is 0-1
      _updateGamesProgress();
    } catch (e) {
      Get.snackbar('error'.tr, 'server_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void onGameTap(GameModel game) {
    // Navigate to start game screen with game type
    Get.toNamed(AppRoutes.START_GAME, arguments: {'gameType': game.id});
  }
}
