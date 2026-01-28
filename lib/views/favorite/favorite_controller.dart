import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
import '../../core/controllers/connectivity_controller.dart';
import '../../data/models/recipe_mock_data.dart';
import '../../data/models/recipe_model.dart';
import '../../shared/utils/ui_utils.dart';

class FavoriteController extends GetxController {
  final _logger = Logger();
  late final ConnectivityController _connectivity;

  // Observables
  var isLoading = false.obs;
  var isOnline = true.obs;
  var favorites = <Recipe>[].obs;
  var isEmpty = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<ConnectivityController>()) {
      _connectivity = Get.find<ConnectivityController>();
    }
    checkConnectivity();
    loadFavorites();
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

  Future<void> loadFavorites() async {
    isLoading.value = true;

    // Simulating 1s delay for loading
    await Future.delayed(const Duration(seconds: 1));

    // Load favorites from mock data provider (backend compatible)
    favorites.value = RecipeMockData.getFavoriteRecipes();

    isEmpty.value = favorites.isEmpty;
    isLoading.value = false;
  }

  void removeFavorite(String id) {
    // Remove from favorites list
    favorites.removeWhere((recipe) => recipe.id == id);
    isEmpty.value = favorites.isEmpty;
    _logger.i("Removed recipe $id from favorites");
  }

  void navigateToExplore() {
    // TODO: Navigate to Explore/Search screen
    _logger.i("Navigating to Explore Recipes");
    Get.snackbar('Navigation', 'Navigating to Explore Recipes');
  }
}
