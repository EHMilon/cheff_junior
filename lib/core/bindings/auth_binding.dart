import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/connectivity_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectivityController>(ConnectivityController(), permanent: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
