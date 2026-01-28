import 'package:get/get.dart';

import '../../data/models/recipe_mock_data.dart';
import '../../data/models/recipe_model.dart';
import '../../core/controllers/connectivity_controller.dart';

/// Controller for All Recipe Screen
/// Manages recipe data and user interactions
class AllRecipeController extends GetxController {
  // Observable recipe list
  final recipes = <Recipe>[].obs;
  
  // Loading state
  final isLoading = false.obs;
  
  // Online status from connectivity controller
  final isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  /// Initialize data and check connectivity
  void _initializeData() {
    // Check if connectivity controller is registered
    if (Get.isRegistered<ConnectivityController>()) {
      final connectivityController = Get.find<ConnectivityController>();
      isOnline.value = connectivityController.isOnline.value;
      
      // Listen to connectivity changes
      ever(connectivityController.isOnline, (isOnlineVal) {
        isOnline.value = isOnlineVal;
        if (isOnlineVal) {
          loadRecipes();
        }
      });
    }
    
    loadRecipes();
  }

  /// Load recipes from mock data (simulates API call)
  /// TODO: Replace with actual API call when backend is ready
  void loadRecipes() async {
    isLoading.value = true;
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load all recipes from mock data
      recipes.value = RecipeMockData.getRecipes();
      
      // TODO: Replace with actual API call:
      // final response = await apiService.get('/recipes');
      // if (response.success) {
      //   recipes.value = (response.data as List)
      //       .map((json) => Recipe.fromJson(json))
      //       .toList();
      // }
    } catch (e) {
      // Handle error
      Get.snackbar(
        'error'.tr,
        'failed_to_load_recipes'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle favorite status for a recipe
  void toggleFavorite(String recipeId) {
    final index = recipes.indexWhere((r) => r.id == recipeId);
    if (index != -1) {
      final recipe = recipes[index];
      recipes[index] = Recipe(
        id: recipe.id,
        title: recipe.title,
        description: recipe.description,
        imageUrl: recipe.imageUrl,
        difficulty: recipe.difficulty,
        timeInMinutes: recipe.timeInMinutes,
        category: recipe.category,
        servings: recipe.servings,
        isFavorite: !recipe.isFavorite,
        rating: recipe.rating,
        reviewsCount: recipe.reviewsCount,
      );
      
      // TODO: Sync with backend
      // await apiService.post('/recipes/$recipeId/favorite');
    }
  }

  /// Search recipes by query
  void searchRecipes(String query) {
    if (query.isEmpty) {
      loadRecipes();
      return;
    }
    
    recipes.value = RecipeMockData.searchRecipes(query);
  }

  /// Filter recipes by category
  void filterByCategory(String category) {
    if (category.isEmpty) {
      loadRecipes();
      return;
    }
    
    recipes.value = RecipeMockData.getRecipesByCategory(category);
  }
}


