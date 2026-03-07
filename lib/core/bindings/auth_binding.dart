import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/connectivity_controller.dart';
<<<<<<< HEAD
import '../services/auth_service.dart';
=======
>>>>>>> office/main

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectivityController>(ConnectivityController(), permanent: true);
<<<<<<< HEAD
    Get.put<AuthController>(AuthController(), permanent: true);
=======
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
>>>>>>> office/main
  }
}
