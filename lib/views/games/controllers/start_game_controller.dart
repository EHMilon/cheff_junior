import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class StartGameController extends GetxController {
  /// Game type: '1' for first game (Game 1, 2, 3 flow), '2' for second game (Game 4 flow)
  /// Can be passed via Get.arguments or defaults to '1'
  String get gameType => Get.arguments?['gameType'] ?? '1';
  

  /// Called when Start button is tapped
  void onStartTap() {
    if (gameType == '1') {
      // Navigate to first game (Game 1, 2, 3 flow)
      Get.toNamed(AppRoutes.EMPTY_GAME_ONE);
    } else {
      // Navigate directly to Game 4
      Get.toNamed(AppRoutes.GAME_FOUR);
    }
  }

  /// Called when back button is tapped
  void onBackTap() {
    Get.back();
  }
}
