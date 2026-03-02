import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../views/home/widgets/recipe_card.dart';
import 'search_controller.dart';
import '../../core/themes/app_colors.dart';
import '../../data/models/explore_recipe_model.dart';

/// SearchView - Recipe search screen with debounced search functionality
/// Uses GetX for state management and follows project architecture patterns
class SearchView extends GetView<SearchPageController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildHeader(),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                // Handle initial empty state (before search)
                if (!controller.hasSearched.value &&
                    !controller.isLoading.value) {
                  return _buildEmptySearch();
                }

                // Handle no results state
                if (controller.isEmpty.value && !controller.isLoading.value) {
                  return _buildNoResults();
                }

                // Show search results with Skeletonizer
                return _buildSearchResults();
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the header with back button and search bar
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // Custom Back Button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 36.h,
              width: 36.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFFDAB9), // Pale orange/peach circle
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.grey400, // Dark grey icon
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Search Bar
          Expanded(child: _buildSearchBar()),
        ],
      ),
    );
  }

  /// Build the search bar (pill-shaped from Figma design)
  Widget _buildSearchBar() {
    return Container(
      height: 48.h,
      width: 48.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Icon(Icons.search, color: AppColors.grey, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              onChanged: (val) => controller.onSearchQueryChanged(val),
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                hintStyle: GoogleFonts.baloo2(
                  color: AppColors.grey,
                  fontSize: 18.sp,
                ),
                // border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: GoogleFonts.baloo2(
                fontSize: 18.sp,
                color: AppColors.secondary,
              ),
            ),
          ),
          Obx(
            () => controller.searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: controller.clearSearch,
                    icon: Icon(Icons.close, color: AppColors.grey, size: 20.sp),
                  )
                : const SizedBox(width: 12),
          ),
        ],
      ),
    );
  }

  /// Empty state before search - uses localization keys and theme colors
  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64.sp, color: AppColors.grey300),
          SizedBox(height: 16.h),
          Text(
            'search_empty_title'.tr,
            style: GoogleFonts.baloo2(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.grey400,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'search_empty_subtitle'.tr,
            style: GoogleFonts.baloo2(fontSize: 16.sp, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  /// No results found state - shown when search returns empty
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: AppColors.grey300),
          SizedBox(height: 16.h),
          Text(
            'no_results_title'.tr,
            style: GoogleFonts.baloo2(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.grey400,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'no_results_subtitle'.tr,
            style: GoogleFonts.baloo2(fontSize: 16.sp, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  /// Search results list using reusable RecipeCard and Skeletonizer
  Widget _buildSearchResults() {
    return Skeletonizer(
      enabled: controller.isLoading.value,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.isLoading.value
            ? 5
            : controller.searchResults.length,
          itemBuilder: (context, index) {
          final recipe = controller.isLoading.value
              ? ExploreRecipe(
                  id: 0,
                  title: 'Loading...',
                  imageUrl: '',
                  difficulty: '...',
                  cookingTime: '...',
                  category: '...',
                  isFavorite: false,
                  favoritesCount: 0,
                )
              : controller.searchResults[index];
          return RecipeCard(
            recipe: recipe,
            imageLeft: index % 2 == 0,
            verticalLayout: false,
            onFavoriteToggle: () => controller.toggleFavorite(recipe.id),
          );
        },
      ),
    );
  }
}
