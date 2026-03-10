import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/explore_recipe_model.dart';
import '../../../core/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatelessWidget {
  final ExploreRecipe recipe;
  final bool imageLeft;
  final bool verticalLayout; // New property to control layout direction
  final VoidCallback onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.imageLeft = true,
    this.verticalLayout = false, // Default to horizontal layout
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.RECIPE_DETAIL, arguments: recipe),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: verticalLayout ? EdgeInsets.zero : EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: verticalLayout
            ? _buildVerticalLayout()
            : _buildHorizontalLayout(),
      ),
    );
  }

  /// Build image widget with fallback for empty/invalid URLs
  Widget _buildRecipeImage({required double width, required double height}) {
    // Check if image URL is empty or invalid
    if (recipe.imageUrl.isEmpty) {
      return _buildImagePlaceholder(width: width, height: height);
    }

    // Check if it's a URL (http/https) or local asset
    if (recipe.imageUrl.startsWith('http://') ||
        recipe.imageUrl.startsWith('https://')) {
      return Hero(
        tag: 'recipe_${recipe.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: Image.network(
            recipe.imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildImagePlaceholder(width: width, height: height),
          ),
        ),
      );
    }

    // It's a local asset
    return Hero(
      tag: 'recipe_${recipe.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Image.asset(
          recipe.imageUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildImagePlaceholder(width: width, height: height),
        ),
      ),
    );
  }

  /// Placeholder widget for missing images
  Widget _buildImagePlaceholder({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Icon(Icons.fastfood, size: 40.sp, color: AppColors.grey300),
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Section with difficulty badge and favorite icon
        Stack(
          children: [
            _buildRecipeImage(width: double.infinity, height: 164.h),
            // Difficulty Badge
            Positioned(
              top: 20.h,
              left: 20.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(recipe.difficulty),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  recipe.difficulty,
                  style: GoogleFonts.baloo2(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBody,
                  ),
                ),
              ),
            ),
            // Favorite Button (Heart icon at top right)
            Positioned(
              top: 20.h,
              right: 20.w,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    recipe.isFavorite ? Icons.close : Icons.favorite_border,
                    size: 28.sp,
                    color: recipe.isFavorite ? Colors.red : AppColors.grey300,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Info Section
        Padding(
          padding: EdgeInsets.only(left: 12.w, bottom: 12.w, right: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maxLines: 1,
                recipe.title,
                style: GoogleFonts.baloo2(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                  height: 1.2,
                ),
              ),
              Text(
                recipe.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, height: 1.2, color: AppColors.grey500),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _buildIconText(
                    SvgPicture.asset(
                      'assets/images/time_circle.svg',
                      width: 16.sp,
                    ),
                    recipe.cookingTime,
                  ),
                  SizedBox(width: 12.w),
                  _buildIconText(
                    SvgPicture.asset('assets/images/soup.svg', width: 14.sp),
                    recipe.difficulty,
                  ),
                  SizedBox(width: 12.w),
                  _buildIconText(
                    SvgPicture.asset(
                      'assets/images/chef-hat.svg',
                      width: 14.sp,
                      color: AppColors.primary,
                    ),
                    '${recipe.servings}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      textDirection: imageLeft ? TextDirection.ltr : TextDirection.rtl,
      children: [
        // Image Section
        Stack(
          children: [
            _buildRecipeImage(width: 140.w, height: 110.h),
            // Difficulty Badge
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(recipe.difficulty),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  recipe.difficulty,
                  style: GoogleFonts.baloo2(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBody,
                  ),
                ),
              ),
            ),
            // Favorite Button
            Positioned(
              bottom: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: AppColors.lightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18.sp,
                    color: recipe.isFavorite ? Colors.red : Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 12.w),
        // Info Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.title,
                maxLines: 1,
                style: GoogleFonts.baloo2(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                  height: 1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                recipe.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.grey400,
                  fontWeight: FontWeight.w400,
                  height: 1.36,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _buildIconText(
                    SvgPicture.asset(
                      'assets/images/time_circle.svg',
                      width: 16.sp,
                      color: AppColors.primary,
                    ),
                    recipe.cookingTime,
                  ),
                  SizedBox(width: 12.w),
                  _buildIconText(
                    SvgPicture.asset(
                      'assets/images/soup.svg',
                      width: 16.sp,
                      color: AppColors.primary,
                    ),
                    recipe.difficulty,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              _buildIconText(
                SvgPicture.asset(
                  'assets/images/chef-hat.svg',
                  width: 16.sp,
                  color: AppColors.primary,
                ),
                '${recipe.servings} Servings',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconText(dynamic icon, String text) {
    return Row(
      children: [
        if (icon is IconData)
          Icon(icon, size: 14.sp, color: AppColors.primary)
        else if (icon is Widget)
          icon
        else
          Container(), // fallback
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(fontSize: 14.sp, color: AppColors.grey400),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xD8BFF4BF);
      case 'medium':
        return const Color(0xFFFFE789);
      case 'hard':
        return const Color(0xFFFF7F6F);
      default:
        return AppColors.lightGrey;
    }
  }
}
