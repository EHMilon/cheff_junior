import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/themes/app_colors.dart';
import '../../data/models/recipe_model.dart';
import 'home_controller.dart';
import 'widgets/home_header.dart';
import 'widgets/promo_banner.dart';
import 'widgets/section_header.dart';
import 'widgets/recipe_card.dart';
import 'all_recipe_view.dart'; // Add import for AllRecipeView
import '../../shared/widgets/main_scaffold.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensuring controller is initialized
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }

    return MainScaffold(
      currentIndex: 0, // Home is index 0
      body: SafeArea(
        child: Obx(() {
          if (!controller.isOnline.value) {
            return _buildNoInternetView();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                const HomeHeader(),
                SizedBox(height: 25.h),
                const PromoBanner(),
                SizedBox(height: 25.h),
                SectionHeader(
                  title: 'explore_recipes'.tr,
                  onSeeAll: () {
                    // Navigate to All Recipe screen
                    Get.to(() => const AllRecipeView());
                  },
                ),
                _buildRecipeList(),
                SizedBox(height: 80.h), // Space for bottom nav
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecipeList() {
    return Obx(() {
      final List<Recipe> displayRecipes = controller.isLoading.value
          ? List.generate(
              3,
              (index) => Recipe(
                id: 'loading_$index',
                title: 'Loading Recipe Title',
                description:
                    'This is a long description placeholder for the shimmer effect',
                imageUrl: 'assets/images/image.png',
                difficulty: 'Easy',
                timeInMinutes: 0,
                category: 'Loading',
                servings: 0,
              ),
            )
          : controller.recipes;

      return Skeletonizer(
        enabled: controller.isLoading.value,
        child: Column(
          children: displayRecipes.asMap().entries.map((entry) {
            int idx = entry.key;
            var recipe = entry.value;
            return RecipeCard(
              recipe: recipe,
              imageLeft: idx % 2 == 0,
              verticalLayout: false, // Explicitly set to horizontal layout
              onFavoriteToggle: () => controller.toggleFavorite(recipe.id),
            );
          }).toList(),
        ),
      );
    });
  }

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
