import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class EmptyGameTwoController extends GetxController {
  void onDoneTap() {
    // Navigate to the third empty game screen
    Get.toNamed(AppRoutes.EMPTY_GAME_THREE);
  }
}
