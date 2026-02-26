import 'package:get/get.dart';
import '../../views/games/controllers/game_four_controller.dart';

class GameFourBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameFourController>(() => GameFourController());
  }
}