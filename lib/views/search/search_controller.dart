import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/recipe_model.dart';
import '../../data/models/recipe_mock_data.dart';

/// SearchPageController - Manages search functionality with debouncing
/// and connectivity checking
class SearchPageController extends GetxController {
  // Text controller for search input - prevents recreation on every rebuild
  late final TextEditingController searchTextController;

  // Observables
  var searchQuery = ''.obs;
  var searchResults = <Recipe>[].obs;
  var isLoading = false.obs;
  var isEmpty = true.obs;
  var hasSearched = false.obs;
  var isOnline = true.obs;

  // Debounce timer for search - using Timer for proper cancellation
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    searchTextController = TextEditingController();
    checkConnectivity();
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

  /// Perform search with mock data
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

    try {
      // Simulate network delay of 2 seconds as per requirements
      await Future.delayed(const Duration(seconds: 2));

      // Search using mock data provider
      searchResults.value = RecipeMockData.searchRecipes(query.trim());
      isEmpty.value = searchResults.isEmpty;
    } catch (e) {
      // Handle search errors
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
    _debounceTimer?.cancel();
  }

  /// Toggle favorite status for a recipe
  void toggleFavorite(String id) {
    int index = searchResults.indexWhere((r) => r.id == id);
    if (index != -1) {
      searchResults[index] = searchResults[index].copyWith(
        isFavorite: !searchResults[index].isFavorite,
      );
    }
  }
}
