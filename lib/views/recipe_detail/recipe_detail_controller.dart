import 'package:get/get.dart';
import '../../data/models/explore_recipe_model.dart';
import '../../data/models/recipe_detail_model.dart';
import '../../data/services/recipe_api_service.dart';

/// Controller for Recipe Detail Screen
/// Fetches full recipe details from API when user clicks on a recipe card
class RecipeDetailController extends GetxController {
  // Observable recipe detail
  var recipeDetail = Rxn<RecipeDetail>();
  
  // Loading and error states
  var isLoading = true.obs;
  var errorMessage = Rxn<String>();
  
  // Favorite state (from explore recipe)
  var isFavorite = false.obs;
  
  // Recipe ID to fetch
  late int recipeId;
  
  // Recipe title from explore (for display while loading)
  String? initialTitle;
  String? initialImageUrl;

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
      _processArguments();
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to initialize: $e';
    }
  }

  /// Process navigation arguments and fetch recipe details
  void _processArguments() {
    if (Get.arguments != null) {
      // Handle ExploreRecipe from recipe card click
      if (Get.arguments is ExploreRecipe) {
        final exploreRecipe = Get.arguments as ExploreRecipe;
        recipeId = exploreRecipe.id;
        isFavorite.value = exploreRecipe.isFavorite;
        initialTitle = exploreRecipe.title;
        initialImageUrl = exploreRecipe.imageUrl;
        fetchRecipeDetail();
        return;
      }
      
      // Handle recipe ID only (int)
      if (Get.arguments is int) {
        recipeId = Get.arguments as int;
        fetchRecipeDetail();
        return;
      }
    }
    
    // No valid arguments - go back
    Get.back();
  }

  /// Fetch recipe details from API
  /// Endpoint: GET $baseUrl/recipes/{id}
  Future<void> fetchRecipeDetail() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _recipeApiService.getRecipeDetail(recipeId);

      if (result.isSuccess && result.data != null) {
        recipeDetail.value = result.data;
        isFavorite.value = result.data!.isFavorite;
      } else {
        errorMessage.value = result.error ?? 'Failed to load recipe details';
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle favorite status
  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    
    // Update local recipe detail if available
    if (recipeDetail.value != null) {
      final current = recipeDetail.value!;
      recipeDetail.value = current.copyWith(
        isFavorite: isFavorite.value,
        favoritesCount: isFavorite.value 
            ? current.favoritesCount + 1 
            : current.favoritesCount - 1,
      );
    }
    
    // TODO: Sync with backend via API call
    // await _recipeApiService.toggleFavorite(recipeId);
  }

  /// Refresh recipe details
  Future<void> refreshRecipe() async {
    await fetchRecipeDetail();
  }
}
