import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/themes/app_colors.dart';
import '../../data/models/feedback_model.dart';
import '../../data/models/ingredient_detail_model.dart';
import '../../data/models/recipe_detail_model.dart';
import '../../shared/utils/looger_utills.dart';
import '../../shared/widgets/feedback_popup.dart';
import '../../shared/widgets/ingredient_detail_popup.dart';
import '../../shared/widgets/video_player_widget.dart';
import 'recipe_detail_controller.dart';

/// Helper extension to safely access recipe detail
extension SafeRecipeAccess on RecipeDetailController {
  String get safeTitle =>
      recipeDetail.value?.title ?? initialTitle ?? 'Loading...';
  String get safeDescription => recipeDetail.value?.description ?? '';
  String get safeImageUrl =>
      recipeDetail.value?.imageUrl ?? initialImageUrl ?? '';
  int get safeId => recipeDetail.value?.id ?? recipeId;
  int get safeViewsCount => recipeDetail.value?.viewsCount ?? 0;
  int get safeFavoritesCount => recipeDetail.value?.favoritesCount ?? 0;
  double get safeAverageRating => recipeDetail.value?.averageRating ?? 0.0;
  int get safeTotalReviews => recipeDetail.value?.totalReviews ?? 0;
  List get safeIngredients => recipeDetail.value?.ingredients ?? [];
}

class RecipeDetailView extends GetView<RecipeDetailController> {
  const RecipeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Obx(() {
          return Skeletonizer(
            enabled: controller.isLoading.value,

            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 20.h),
                  _buildVideoPlayer(),
                  SizedBox(height: 12.h),
                  _buildMetadataRow(),
                  SizedBox(height: 12.h),
                  _buildRatingRow(),
                  SizedBox(height: 20.h),
                  Text(
                    controller.safeTitle,
                    style: GoogleFonts.baloo2(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    controller.safeDescription,
                    style: GoogleFonts.baloo2(
                      fontSize: 14.sp,
                      color: AppColors.secondary.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'ingredients_header'.tr,
                    style: GoogleFonts.baloo2(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildIngredientsList(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: AppColors.lightOrange,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.secondary,
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    final videoUrl = controller.recipeDetail.value?.videoUrl;
    final imageUrl = controller.safeImageUrl;
    final isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    // Show video player if video URL is available
    if (videoUrl != null && videoUrl.isNotEmpty) {
      return Hero(
        tag: 'recipe_${controller.safeId}',
        child: VideoPlayerWidget(
          videoUrl: videoUrl,
          thumbnailUrl: imageUrl.isNotEmpty ? imageUrl : null,
          height: 179.h,
          borderRadius: BorderRadius.circular(20.r),
        ),
      );
    }

    // Fallback to image placeholder when no video URL
    return Hero(
      tag: 'recipe_${controller.safeId}',
      child: Container(
        height: 179.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(20.r),
          image: DecorationImage(
            image: isNetworkImage
                ? NetworkImage(imageUrl) as ImageProvider
                : AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Semi-transparent overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.black.withValues(alpha: 0.2),
              ),
            ),
            // Play button center (disabled - no video)
            Center(
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.videocam_off,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 32.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow() {
    return Row(
      children: [
        Text(
          '${controller.safeViewsCount} ${'views_count'.tr}',
          style: GoogleFonts.baloo2(
            fontSize: 14.sp,
            color: const Color(0xFF505050),
            fontWeight: FontWeight.w400,
            height: 1.20.h,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Icon(Icons.favorite_outline, color: AppColors.primary, size: 18.sp),
            SizedBox(width: 4.w),
            Text(
              '${controller.safeFavoritesCount}',
              style: GoogleFonts.baloo2(
                fontSize: 14.sp,
                color: const Color(0xFF505050),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Obx(() {
      final averageRating = controller.averageRating.value;
      final totalReviews = controller.totalReviews.value;

      return Row(
        children: [
          // Display stars based on average rating
          ...List.generate(5, (index) {
            final starValue = index + 1;
            final isFilled = starValue <= averageRating;
            final isHalfFilled =
                starValue > averageRating && starValue - 0.5 <= averageRating;

            return SvgPicture.asset(
              isFilled || isHalfFilled
                  ? "assets/images/star_filled.svg"
                  : "assets/images/star_outline.svg",
              width: 16.sp,
              height: 16.sp,
            );
          }),
          SizedBox(width: 8.w),
          // Show reviews count
          if (totalReviews > 0)
            Text(
              '($totalReviews)',
              style: GoogleFonts.baloo2(
                fontSize: 14.sp,
                color: const Color(0xFF505050),
              ),
            ),
          const Spacer(),
          TextButton(
            onPressed: () {
              showFeedbackPopup(
                onSubmit: (FeedbackModel feedback) async {
                  Log.d(
                    'Feedback submitted: ${feedback.rating} stars, Comment: ${feedback.comment}',
                  );
                  // Submit review to backend API
                  final success =
                      await controller.submitReview(feedback.rating);
                  if (success) {
                    Log.d('Review submitted successfully');
                  }
                },
              );
            },
            style: TextButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            child: Text(
              'review_button'.tr,
              style: GoogleFonts.baloo2(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildIngredientsList() {
    final ingredients = controller.safeIngredients;
    return Column(
      children: ingredients.asMap().entries.map((entry) {
        final index = entry.key;
        final ingredient = entry.value;
        final isSelected = index == 0; // Highlight first one as in image

        return GestureDetector(
          onTap: () {
            // Convert to IngredientDetail and show popup using actual API data
            final ingredientDetail = IngredientDetail(
              id: '${controller.safeId}_ingredient_$index',
              name: ingredient.name,
              amount: ingredient.quantity,
              icon: ingredient.icon,
              origin: ingredient.origin,
              history: ingredient.history,
              nutrients: _buildNutrientsFromIngredient(ingredient),
              funFacts: _parseFunFacts(ingredient.funFacts),
            );
            showIngredientDetailPopup(ingredientDetail);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.cardBackground : Colors.transparent,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Text(
                    ingredient.icon ?? '🍲',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    ingredient.name,
                    style: GoogleFonts.baloo2(
                      fontSize: 14.sp,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                Text(
                  ingredient.amount,
                  style: GoogleFonts.baloo2(
                    fontSize: 14.sp,
                    color: AppColors.secondary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper method to build nutrients list from ingredient API data
  List<Nutrient>? _buildNutrientsFromIngredient(
    RecipeDetailIngredient ingredient,
  ) {
    final nutrients = <Nutrient>[];

    if (ingredient.protein != null && ingredient.protein!.isNotEmpty) {
      nutrients.add(Nutrient(name: 'Protein', value: ingredient.protein!));
    }
    if (ingredient.carbohydrates != null &&
        ingredient.carbohydrates!.isNotEmpty) {
      nutrients.add(
        Nutrient(name: 'Carbohydrates', value: ingredient.carbohydrates!),
      );
    }
    if (ingredient.fats != null && ingredient.fats!.isNotEmpty) {
      nutrients.add(Nutrient(name: 'Fats', value: ingredient.fats!));
    }
    if (ingredient.others != null && ingredient.others!.isNotEmpty) {
      nutrients.add(Nutrient(name: 'Others', value: ingredient.others!));
    }

    return nutrients.isNotEmpty ? nutrients : null;
  }

  // Helper method to parse fun_facts string to list
  List<String>? _parseFunFacts(String? funFacts) {
    if (funFacts == null || funFacts.isEmpty) return null;
    // Split by common delimiters (comma, pipe, semicolon) or return as single item
    final facts = funFacts
        .split(RegExp(r'[,;|]\s*'))
        .map((f) => f.trim())
        .where((f) => f.isNotEmpty)
        .toList();
    return facts.isNotEmpty ? facts : null;
  }
}
