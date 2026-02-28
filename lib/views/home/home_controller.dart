import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/recipe_model.dart';
import '../../data/services/recipe_api_service.dart';

/// Home Controller - manages home screen state and data loading
///
/// Fetches recipes from API using authenticated access token
class HomeController extends GetxController {
  var isLoading = true.obs;
  var recipes = <Recipe>[].obs;
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
      loadRecipes();
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

  /// Load recipes from API using authenticated access token
  Future<void> loadRecipes() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      // Fetch recipes from API using access token
      final result = await _recipeApiService.getRecipes();

      if (result.isSuccess && result.data != null) {
        recipes.value = result.data!;
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
  void toggleFavorite(String id) {
    // TODO: Implement API call to sync favorite status with backend
    // For now, just update local state
    int index = recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      recipes[index] = recipes[index].copyWith(
        isFavorite: !recipes[index].isFavorite,
      );
    }
  }

  /// Refresh recipes - pull to refresh functionality
  Future<void> refreshRecipes() async {
    await loadRecipes();
  }
}
