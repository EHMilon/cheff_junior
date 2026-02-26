import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../../../core/routes/app_routes.dart';

class EmptyGameOneController extends GetxController {
  void onDoneTap() {
    // Navigate to the second empty game screen
    Get.toNamed(AppRoutes.EMPTY_GAME_TWO);
  }
}
