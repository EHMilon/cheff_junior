import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/explore_recipe_model.dart';
import '../../data/services/recipe_api_service.dart';
import '../favorite/favorite_controller.dart';

/// SearchPageController - Manages search functionality with debouncing
/// and connectivity checking. Uses API for searching recipes.
class SearchPageController extends GetxController {
  // Text controller for search input - prevents recreation on every rebuild
  late final TextEditingController searchTextController;

  // Observables
  var searchQuery = ''.obs;
  var searchResults = <ExploreRecipe>[].obs;
  var isLoading = false.obs;
  var isEmpty = true.obs;
  var hasSearched = false.obs;
  var isOnline = true.obs;
  var errorMessage = Rxn<String>();

  // Debounce timer for search - using Timer for proper cancellation
  Timer? _debounceTimer;

  // Recipe API Service
  late RecipeApiService _recipeApiService;

  @override
  void onInit() {
    super.onInit();
    searchTextController = TextEditingController();
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
    } catch (e) {
      errorMessage.value = 'Failed to initialize: $e';
    }
  }

  @override
  void onClose() {
    // Cancel debounce timer to prevent memory leaks
    _debounceTimer?.cancel();
    // Dispose text controller
    searchTextController.dispose();
    super.onClose();
  }

  /// Check network connectivity before performing search
  Future<void> checkConnectivity() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        isOnline.value = false;
        Get.snackbar('error'.tr, 'no_internet'.tr);
      } else {
        isOnline.value = true;
      }
    } catch (e) {
      // Handle connectivity check errors gracefully
      isOnline.value = false;
      Get.snackbar('error'.tr, 'connectivity_check_failed'.tr);
    }
  }

  /// Update search query with debounce to reduce API calls
  void onSearchQueryChanged(String query) {
    searchQuery.value = query;

    // Cancel previous timer to prevent multiple searches
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      clearSearch();
      return;
    }

    // Debounce search (500ms delay for better UX)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      performSearch(query);
    });
  }

  /// Perform search using API instead of mock data
  Future<void> performSearch(String query) async {
    // Validate query and connectivity
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    if (!isOnline.value) {
      Get.snackbar('error'.tr, 'no_internet'.tr);
      return;
    }

    isLoading.value = true;
    hasSearched.value = true;
    errorMessage.value = null;

    try {
      // Search using API
      final result = await _recipeApiService.searchRecipes(query.trim());

      if (result.isSuccess && result.data != null) {
        searchResults.value = result.data!;
        isEmpty.value = searchResults.isEmpty;
      } else {
        // Handle API error
        errorMessage.value = result.error ?? 'Failed to search recipes';
        searchResults.clear();
        isEmpty.value = true;
        Get.snackbar('error'.tr, errorMessage.value ?? 'search_failed'.tr);
      }
    } catch (e) {
      // Handle network errors
      errorMessage.value = 'Network error: ${e.toString()}';
      searchResults.clear();
      isEmpty.value = true;
      Get.snackbar('error'.tr, 'search_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear search results and reset state
  void clearSearch() {
    searchQuery.value = '';
    searchTextController.clear();
    searchResults.clear();
    isEmpty.value = true;
    hasSearched.value = false;
    isLoading.value = false;
    errorMessage.value = null;
    _debounceTimer?.cancel();
  }

  /// Toggle favorite status for a recipe
  /// Calls the API and updates local state
  Future<void> toggleFavorite(int id) async {
    try {
      // Optimistically update local state first
      int index = searchResults.indexWhere((r) => r.id == id);
      if (index != -1) {
        final recipe = searchResults[index];
        searchResults[index] = recipe.copyWith(
          isFavorite: !recipe.isFavorite,
          favoritesCount: recipe.isFavorite 
              ? recipe.favoritesCount - 1 
              : recipe.favoritesCount + 1,
        );
      }

      // Call API to sync with backend
      final result = await _recipeApiService.toggleFavorite(id);

      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        final bool newFavoriteStatus = response['is_favorite'] ?? false;

        // Update local state with server response
        if (index != -1) {
          final recipe = searchResults[index];
          searchResults[index] = recipe.copyWith(
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
          final recipe = searchResults[index];
          searchResults[index] = recipe.copyWith(
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
}
