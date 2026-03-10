import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
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

  // Observable rating values for reactive UI updates
  var averageRating = 0.0.obs;
  var totalReviews = 0.obs;

  // User's own rating (stored locally after submission)
  var userRating = 0.obs;

  // Selected ingredient index for tracking active selection
  var selectedIngredientIndex = (-1).obs;

  late RecipeApiService _recipeApiService;

  VideoPlayerController? videoPlayerController;

  @override
  void onInit() {
    super.onInit();
    _initRecipeService();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }

  /// Initialize the recipe API service
  Future<void> _initRecipeService() async {
    try {
      if (!Get.isRegistered<RecipeApiService>()) {
        _recipeApiService = await Get.putAsync(() => RecipeApiService().init());
      } else {
        _recipeApiService = Get.find<RecipeApiService>();
      }
      await _processArguments();
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to initialize: $e';
    }
  }

  /// Process navigation arguments and fetch recipe details
  Future<void> _processArguments() async {
    if (Get.arguments != null) {
      // Handle ExploreRecipe from recipe card click
      if (Get.arguments is ExploreRecipe) {
        final exploreRecipe = Get.arguments as ExploreRecipe;
        recipeId = exploreRecipe.id;
        isFavorite.value = exploreRecipe.isFavorite;
        initialTitle = exploreRecipe.title;
        initialImageUrl = exploreRecipe.imageUrl;
        await fetchRecipeDetail();
        return;
      }

      // Handle recipe ID only (int)
      if (Get.arguments is int) {
        recipeId = Get.arguments as int;
        await fetchRecipeDetail();
        return;
      }
    }

    // No valid arguments - go back
    Get.back();
  }

  /// Initialize Video Player
  void _initializeVideoPlayer() {
    final videoUrl = recipeDetail.value?.videoUrl;
    if (videoUrl != null && videoUrl.isNotEmpty) {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
          mixWithOthers: true,
        ),
      )..initialize().then((_) {
          update(); // Update UI when video is initialized
        }).catchError((error) {
          // Handle video loading error silently or log it
        });
    }
  }

  /// Fetch recipe details from API
  /// Endpoint: GET $baseUrl/recipes/{id}
  Future<void> fetchRecipeDetail() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      // Fetch recipe details and reviews in parallel
      final results = await Future.wait([
        _recipeApiService.getRecipeDetail(recipeId),
        _recipeApiService.getRecipeReviews(recipeId),
      ]);

      final recipeResult = results[0] as RecipeApiResult<RecipeDetail>;
      final reviewsResult = results[1] as RecipeApiResult<RecipeReviewResponse>;

      if (recipeResult.isSuccess && recipeResult.data != null) {
        recipeDetail.value = recipeResult.data;
        isFavorite.value = recipeResult.data!.isFavorite;

        // Use reviews data if available, otherwise fallback to recipe detail data
        if (reviewsResult.isSuccess && reviewsResult.data != null) {
          averageRating.value = reviewsResult.data!.averageRating;
          totalReviews.value = reviewsResult.data!.totalReviews;
        } else {
          averageRating.value = recipeResult.data!.averageRating;
          totalReviews.value = recipeResult.data!.totalReviews;
        }

        // Initialize video player after recipe detail is loaded
        _initializeVideoPlayer();
      } else {
        errorMessage.value =
            recipeResult.error ?? 'Failed to load recipe details';
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

  /// Submit a review for this recipe
  /// [rating] - The rating value (1-5)
  /// Returns true if successful, false otherwise
  Future<bool> submitReview(int rating) async {
    try {
      final result = await _recipeApiService.submitReview(recipeId, rating);

      if (result.isSuccess && result.data != null) {
        // Update local recipe detail with new rating info
        final response = result.data!;
        if (recipeDetail.value != null) {
          recipeDetail.value = recipeDetail.value!.copyWith(
            averageRating: response.averageRating,
            totalReviews: response.totalReviews,
          );
        }
        // Update observable values for reactive UI
        averageRating.value = response.averageRating;
        totalReviews.value = response.totalReviews;
        // Store user's rating locally
        userRating.value = rating;
        return true;
      } else {
        Get.snackbar(
          'Error',
          result.error ?? 'Failed to submit review',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit review: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}
