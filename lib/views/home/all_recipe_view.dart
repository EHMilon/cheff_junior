import 'package:chef_junior/shared/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/themes/app_colors.dart';
import '../../data/models/explore_recipe_model.dart';
import 'all_recipe_controller.dart';
import 'widgets/recipe_card.dart';

/// All Recipe Screen - Displays all available recipes in a list layout
/// Opens when user clicks "See All" button from home screen
class AllRecipeView extends GetView<AllRecipeController> {
  const AllRecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensuring controller is initialized
    if (!Get.isRegistered<AllRecipeController>()) {
      Get.put(AllRecipeController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Widget
            HeaderWidget(title: 'all_recipes'.tr, horizontalPadding: 20.w),
            SizedBox(height: 20.h),
            // Recipe List
            Expanded(
              child: Obx(() {
                if (!controller.isOnline.value) {
                  return _buildNoInternetView();
                }

                return _buildRecipeList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the recipe list with horizontal layout cards (like home screen)
  Widget _buildRecipeList() {
    return Obx(() {
      final List<ExploreRecipe> displayRecipes = controller.isLoading.value
          ? List.generate(
              3,
              (index) => ExploreRecipe(
                id: index,
                title: 'Loading Recipe Title',
                difficulty: 'Easy',
                cookingTime: '0 min',
                category: 'Loading',
                imageUrl: 'assets/images/image.png',
                isFavorite: false,
                favoritesCount: 0,
              ),
            )
          : controller.recipes;

      return Skeletonizer(
        enabled: controller.isLoading.value,
        child: ListView.builder(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          itemCount: displayRecipes.length,
          itemBuilder: (context, index) {
            final recipe = displayRecipes[index];
            // Alternate image position like home screen
            final bool imageLeft = index % 2 == 0;
            return RecipeCard(
              recipe: recipe,
              imageLeft: imageLeft,
              verticalLayout: false, // Horizontal layout like home screen
              onFavoriteToggle: () => controller.toggleFavorite(recipe.id),
            );
          },
        ),
      );
    });
  }

  /// No internet connection view
  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64.sp, color: AppColors.grey),
          SizedBox(height: 16.h),
          Text(
            'no_internet'.tr,
            style: GoogleFonts.baloo2(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBody,
            ),
          ),
          SizedBox(height: 8.h),
          ElevatedButton(
            onPressed: () => controller.loadRecipes(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
