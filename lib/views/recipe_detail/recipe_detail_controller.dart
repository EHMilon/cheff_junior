import 'package:get/get.dart';
import '../../data/models/recipe_model.dart';

class RecipeDetailController extends GetxController {
  late Recipe recipe;
  var isFavorite = false.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Recipe) {
      recipe = Get.arguments as Recipe;
      isFavorite.value = recipe.isFavorite;
      _loadRecipeDetails();
    } else {
      // For demo purposes, we can use a mock if arguments are null,
      // but ideally we should go back
      Get.back();
      // Get.snackbar('Error', 'Recipe data missing');
    }
  }

  void _loadRecipeDetails() async {
    isLoading.value = true;
    // Simulate API delay as required by user rules (2s)
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    // TODO: Update in backend or main list controller
  }
}
