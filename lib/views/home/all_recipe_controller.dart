import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/explore_recipe_model.dart';
import '../../data/services/recipe_api_service.dart';
import '../../core/controllers/connectivity_controller.dart';
import '../favorite/favorite_controller.dart';

/// Controller for All Recipe Screen
/// Manages recipe data and user interactions using real API
class AllRecipeController extends GetxController {
  // Observable recipe list
  final recipes = <ExploreRecipe>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Online status from connectivity controller
  final isOnline = true.obs;

  // Error message
  final errorMessage = Rxn<String>();

  late RecipeApiService _recipeApiService;

  @override
  void onInit() {
    super.onInit();
    _initRecipeService();
  }

  /// Initialize the recipe API service
  Future<void> _initRecipeService() async {
    try {
      if (!Get.isRegistered<RecipeApiService>()) {
        _recipeApiService = await Get.putAsync(() => RecipeApiService().init());
      } else {
        _recipeApiService = Get.find<RecipeApiService>();
      }
      _initializeData();
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to initialize: $e';
    }
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

  /// Load recipes from API
  void loadRecipes() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      // Fetch all explore recipes from API
      final result = await _recipeApiService.getExploreRecipes();

      if (result.isSuccess && result.data != null) {
        // Show all recipes (no limit)
        recipes.value = result.data!;
      } else {
        errorMessage.value = result.error ?? 'Failed to load recipes';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'error'.tr,
            errorMessage.value ?? 'failed_to_load_recipes'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'error'.tr,
          'failed_to_load_recipes'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle favorite status for a recipe
  /// Calls the API and updates local state
  Future<void> toggleFavorite(int recipeId) async {
    try {
      // Optimistically update local state first
      final index = recipes.indexWhere((r) => r.id == recipeId);
      if (index != -1) {
        final recipe = recipes[index];
        recipes[index] = recipe.copyWith(
          isFavorite: !recipe.isFavorite,
          favoritesCount: recipe.isFavorite
              ? recipe.favoritesCount - 1
              : recipe.favoritesCount + 1,
        );
      }

      // Call API to sync with backend
      final result = await _recipeApiService.toggleFavorite(recipeId);

      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        final bool newFavoriteStatus = response['is_favorite'] ?? false;

        // Update local state with server response
        if (index != -1) {
          final recipe = recipes[index];
          recipes[index] = recipe.copyWith(
            isFavorite: newFavoriteStatus,
            favoritesCount: newFavoriteStatus
                ? recipe.favoritesCount + 1
                : recipe.favoritesCount - 1,
          );
        }

        // Notify FavoriteController to refresh its list
        if (Get.isRegistered<FavoriteController>()) {
          final favoriteController = Get.find<FavoriteController>();
          favoriteController.loadFavorites();
        }
      } else {
        // Revert local state on API failure
        if (index != -1) {
          final recipe = recipes[index];
          recipes[index] = recipe.copyWith(
            isFavorite: !recipe.isFavorite,
            favoritesCount: recipe.isFavorite
                ? recipe.favoritesCount - 1
                : recipe.favoritesCount + 1,
          );
        }
        Get.snackbar('Error'.tr, 'Failed to update favorite status'.tr);
      }
    } catch (e) {
      Get.snackbar('Error'.tr, 'Something went wrong'.tr);
    }
  }

  /// Search recipes by query
  void searchRecipes(String query) {
    if (query.isEmpty) {
      loadRecipes();
      return;
    }

    // Local search on loaded recipes
    final allRecipes = recipes.toList();
    recipes.value = allRecipes
        .where(
          (recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()) ||
              recipe.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Filter recipes by category
  void filterByCategory(String category) {
    if (category.isEmpty) {
      loadRecipes();
      return;
    }

    // Local filter on loaded recipes
    final allRecipes = recipes.toList();
    recipes.value = allRecipes
        .where(
          (recipe) => recipe.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  /// Refresh recipes - pull to refresh functionality
  Future<void> refreshRecipes() async {
    await Future.sync(() => loadRecipes());
  }
}
