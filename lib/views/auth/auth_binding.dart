import 'package:get/get.dart';
import 'auth_controller.dart';
import '../../core/controllers/connectivity_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectivityController>(ConnectivityController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
