import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
import '../../core/controllers/connectivity_controller.dart';
import '../../data/models/explore_recipe_model.dart';
import '../../data/services/recipe_api_service.dart';
import '../../shared/utils/ui_utils.dart';

class FavoriteController extends GetxController {
  final _logger = Logger();
  late final ConnectivityController _connectivity;
  late RecipeApiService _recipeApiService;

  // Observables
  var isLoading = false.obs;
  var isOnline = true.obs;
  var favorites = <ExploreRecipe>[].obs;
  var isEmpty = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initServices();
  }

  Future<void> _initServices() async {
    try {
      if (!Get.isRegistered<RecipeApiService>()) {
        _recipeApiService = await Get.putAsync(() => RecipeApiService().init());
      } else {
        _recipeApiService = Get.find<RecipeApiService>();
      }
      
      if (Get.isRegistered<ConnectivityController>()) {
        _connectivity = Get.find<ConnectivityController>();
      }
      
      checkConnectivity();
      loadFavorites();
    } catch (e) {
      _logger.e('Failed to initialize services: $e');
    }
  }

  bool _checkConnectivity() {
    if (!_connectivity.isOnline.value) {
      UiUtils.showNoInternet();
      return false;
    }
    return true;
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      isOnline.value = false;
      Get.snackbar('Error', 'no_internet'.tr);
    } else {
      isOnline.value = true;
    }
  }

  /// Load favorites from API
  Future<void> loadFavorites() async {
    isLoading.value = true;

    try {
      // TODO: Replace with actual API call when backend has favorites endpoint
      // For now, fetch all recipes and filter favorites locally
      final result = await _recipeApiService.getExploreRecipes();
      
      if (result.isSuccess && result.data != null) {
        // Filter only favorite recipes
        favorites.value = result.data!.where((r) => r.isFavorite).toList();
      } else {
        _logger.w('Failed to load favorites: ${result.error}');
        favorites.clear();
      }
    } catch (e) {
      _logger.e('Error loading favorites: $e');
      favorites.clear();
    } finally {
      isEmpty.value = favorites.isEmpty;
      isLoading.value = false;
    }
  }

  /// Remove a recipe from favorites
  void removeFavorite(int id) {
    favorites.removeWhere((recipe) => recipe.id == id);
    isEmpty.value = favorites.isEmpty;
    _logger.i("Removed recipe $id from favorites");
  }

  /// Toggle favorite status
  void toggleFavorite(int id) {
    final index = favorites.indexWhere((r) => r.id == id);
    if (index != -1) {
      final recipe = favorites[index];
      favorites[index] = recipe.copyWith(
        isFavorite: !recipe.isFavorite,
        favoritesCount: recipe.isFavorite 
            ? recipe.favoritesCount - 1 
            : recipe.favoritesCount + 1,
      );
      
      // Remove from list if unfavorited
      if (!favorites[index].isFavorite) {
        favorites.removeAt(index);
        isEmpty.value = favorites.isEmpty;
      }
    }
  }

  void navigateToExplore() {
    // TODO: Navigate to Explore/Search screen
    _logger.i("Navigating to Explore Recipes");
    Get.snackbar('Navigation', 'Navigating to Explore Recipes');
  }
}
