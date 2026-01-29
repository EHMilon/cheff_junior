import 'package:get/get.dart';
import '../../views/games/games_controller.dart';

class GamesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GamesController>(() => GamesController());
  }
}
