import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

    // Mock data for now, compatible with backend integration later
    recipes.value = [
      Recipe(
        id: '1',
        title: 'Chicken Pizza',
        description:
            'Traditional Italian pizza made by native Italians and with some ...',
        imageUrl: 'assets/images/recipe-k_IgsitMBS0.jpg', // Downloaded from Unsplash
        difficulty: 'Easy',
        timeInMinutes: 30,
        category: 'Fast food',
        servings: 2,
      ),
      Recipe(
        id: '2',
        title: 'Chicken Pizza',
        description:
            'Traditional Italian pizza made by native Italians and with some ...',
        imageUrl: 'assets/images/recipe-w1RkpMjM5Fc.jpg', // Downloaded from Unsplash
        difficulty: 'Medium',
        timeInMinutes: 30,
        category: 'Fast food',
        servings: 2,
      ),
      Recipe(
        id: '3',
        title: 'Chicken Pizza',
        description:
            'Traditional Italian pizza made by native Italians and with some ...',
        imageUrl: 'assets/images/recipe-drd0LG_kYE8.jpg', // Downloaded from Unsplash
        difficulty: 'Hard',
        timeInMinutes: 30,
        category: 'Fast food',
        servings: 2,
      ),
    ];

    isLoading.value = false;
  }

  void toggleFavorite(String id) {
    // FIXME: Update local state and sync with backend
    int index = recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      // Create a new instance because Recipe fields are probably final
      var recipe = recipes[index];
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
      );
    }
  }
}
