import 'package:get/get.dart';
<<<<<<< HEAD
import '../../views/games/controllers/games_controller.dart';
=======
import '../../views/games/games_controller.dart';
>>>>>>> office/main

class GamesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GamesController>(() => GamesController());
  }
}
