import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/recipe_mock_data.dart';
import '../../data/models/recipe_model.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var recipes = <Recipe>[].obs;
  var isOnline = true.obs;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnectivity();
    loadRecipes();
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
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

  Future<void> loadRecipes() async {
    isLoading.value = true;

    // Simulating 2s delay as requested
    await Future.delayed(const Duration(seconds: 2));

    // Load recipes from mock data provider (backend compatible)
    recipes.value = RecipeMockData.getRecipes();

    isLoading.value = false;
  }

  void toggleFavorite(String id) {
    // FIXME: Update local state and sync with backend
    int index = recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      recipes[index] = recipes[index].copyWith(
        isFavorite: !recipes[index].isFavorite,
      );
    }
  }
}
