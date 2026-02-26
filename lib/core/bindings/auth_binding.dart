import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/connectivity_controller.dart';
import '../services/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectivityController>(ConnectivityController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
