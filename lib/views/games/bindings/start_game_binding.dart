import 'package:get/get.dart';
import '../controllers/start_game_controller.dart';

class StartGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartGameController>(() => StartGameController());
  }
}
