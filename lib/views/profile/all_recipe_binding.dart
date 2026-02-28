import 'package:get/get.dart';
import '../home/all_recipe_controller.dart';

/// Binding for All Recipe Screen
/// Initializes dependencies when the screen is navigated to
class AllRecipeBinding extends Bindings {
  @override
  void dependencies() {
    // Put controller here - GetX will auto-dispose
    Get.put<AllRecipeController>(AllRecipeController());
  }
}
