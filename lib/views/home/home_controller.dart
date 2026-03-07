import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/explore_recipe_model.dart';
import '../../data/services/recipe_api_service.dart';
import '../favorite/favorite_controller.dart';

/// Home Controller - manages home screen state and data loading
///
/// Fetches explore recipes from API using authenticated access token
/// Shows only 3 items on the home screen
class HomeController extends GetxController {
  var isLoading = true.obs;
  var exploreRecipes = <ExploreRecipe>[].obs;
  var isOnline = true.obs;
  var currentIndex = 0.obs;
  var errorMessage = Rxn<String>();

  late RecipeApiService _recipeApiService;

  @override
  void onInit() {
    super.onInit();
    _initRecipeService();
    checkConnectivity();
  }

  /// Initialize the recipe API service
  Future<void> _initRecipeService() async {
    try {
      if (!Get.isRegistered<RecipeApiService>()) {
        _recipeApiService = await Get.putAsync(() => RecipeApiService().init());
      } else {
        _recipeApiService = Get.find<RecipeApiService>();
      }
      // Load recipes after service is initialized
      loadExploreRecipes();
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to initialize: $e';
    }
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  /// Check internet connectivity
  Future<void> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    // Handle newer API that returns List<ConnectivityResult>
    final isConnected = !connectivityResult.contains(ConnectivityResult.none);

    if (!isConnected) {
      isOnline.value = false;
      // Use addPostFrameCallback to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'no_internet'.tr);
      });
    } else {
      isOnline.value = true;
    }
  }

  /// Load explore recipes from API using authenticated access token
  /// Shows only 3 items on the home screen
  Future<void> loadExploreRecipes() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      // Fetch explore recipes from API using access token
      final result = await _recipeApiService.getExploreRecipes();

      if (result.isSuccess && result.data != null) {
        // Show only first 3 items on home screen
        final allRecipes = result.data!;
        exploreRecipes.value = allRecipes.take(3).toList();
      } else {
        // Handle API error - show error message after build
        errorMessage.value = result.error ?? 'Failed to load recipes';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar('Error', errorMessage.value ?? 'Failed to load recipes');
        });
      }
    } catch (e) {
      // Handle network errors after build
      errorMessage.value = 'Network error: ${e.toString()}';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to connect to server');
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle favorite status for a recipe
  /// Calls the API and updates local state
  Future<void> toggleFavorite(int id) async {
    try {
      // Optimistically update local state first
      int index = exploreRecipes.indexWhere((r) => r.id == id);
      if (index != -1) {
        final currentRecipe = exploreRecipes[index];
        exploreRecipes[index] = currentRecipe.copyWith(
          isFavorite: !currentRecipe.isFavorite,
        );
      }

      // Call API to sync with backend
      final result = await _recipeApiService.toggleFavorite(id);

      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        final bool newFavoriteStatus = response['is_favorite'] ?? false;

        // Update local state with server response
        if (index != -1) {
          final currentRecipe = exploreRecipes[index];
          exploreRecipes[index] = currentRecipe.copyWith(
            isFavorite: newFavoriteStatus,
            favoritesCount: newFavoriteStatus
                ? currentRecipe.favoritesCount + 1
                : currentRecipe.favoritesCount - 1,
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
          final currentRecipe = exploreRecipes[index];
          exploreRecipes[index] = currentRecipe.copyWith(
            isFavorite: !currentRecipe.isFavorite,
          );
        }
        Get.snackbar('Error'.tr, 'Failed to update favorite status'.tr);
      }
    } catch (e) {
      Get.snackbar('Error'.tr, 'Something went wrong'.tr);
    }
  }

  /// Refresh recipes - pull to refresh functionality
  Future<void> refreshRecipes() async {
    await loadExploreRecipes();
  }
}
