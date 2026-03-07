import 'package:get/get.dart';
import '../controllers/game_one_controller.dart';
import '../controllers/game_two_controller.dart';
import '../controllers/game_three_controller.dart';

class EmptyGameOneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameOneController>(() => GameOneController());
  }
}

class EmptyGameTwoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmptyGameTwoController>(() => EmptyGameTwoController());
  }
}

class EmptyGameThreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmptyGameThreeController>(() => EmptyGameThreeController());
  }
}
