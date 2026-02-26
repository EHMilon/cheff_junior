import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class EmptyGameThreeController extends GetxController {
  void onDoneTap() {
    // Show "Next page coming soon" message since this is the last screen
    Get.snackbar(
      'coming_soon'.tr,
      'next_page_coming_soon'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      colorText: Get.theme.snackBarTheme.actionTextColor,
    );
  }
}
