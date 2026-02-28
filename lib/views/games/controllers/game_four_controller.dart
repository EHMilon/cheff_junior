import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class GameFourController extends GetxController {
  final RxInt _counter = 0.obs;
  
  int get counter => _counter.value;
  
  void incrementCounter() {
    _counter.value++;
    if (_counter.value >= 3) {
      // Navigate to game finish screen after 3 clicks
      Get.toNamed(AppRoutes.GAME_FINISH);
    }
  }
  
  String get counterDisplay => '${_counter.value}/3';
  
  void onDoneTap() {
    // Navigate to the second empty game screen
    Get.toNamed(AppRoutes.GAME_FOUR);
  }
}
