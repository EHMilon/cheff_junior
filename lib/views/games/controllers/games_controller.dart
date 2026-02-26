import 'package:get/get.dart';
import '../../../core/controllers/connectivity_controller.dart';
import '../../../core/routes/app_routes.dart';

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

  Future<void> loadGames() async {
    try {
      isLoading.value = true;
      // Add a 2s delay as requested in user_global rules
      await Future.delayed(const Duration(seconds: 2));

      // Mock data for games
      games.value = [
        GameModel(
          id: '1',
          title: 'crossword_puzzle'.tr,
          image: 'assets/images/1st_game_image.png',
          progress: 0.3,
        ),
        GameModel(
          id: '2',
          title: 'word_search'.tr,
          image: 'assets/images/2nd_game_image.png',
          progress: 0.1,
        ),
      ];
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
