import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/recipe_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';


class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool imageLeft;
  final VoidCallback onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.imageLeft = true,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
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
      child: Row(
        textDirection: imageLeft ? TextDirection.ltr : TextDirection.rtl,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.asset(
                  recipe.imageUrl,
                  width: 140.w,
                  height: 110.h,
                  fit: BoxFit.cover,
                ),
              ),
              // Difficulty Badge
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(recipe.difficulty),
                    borderRadius: BorderRadius.circular(10.r),
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
                right: imageLeft ? 8.w : null,
                left: !imageLeft ? 8.w : null,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 18.sp,
                      color: recipe.isFavorite ? Colors.red : AppColors.grey,
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
                  style: GoogleFonts.baloo2(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  recipe.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.grey200),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _buildIconText(
                      Iconsax.clock,
                      '${recipe.timeInMinutes} ${'min'.tr}',
                    ),
                    SizedBox(width: 12.w),
                    _buildIconText(Iconsax.cake, recipe.category),
                  ],
                ),
                SizedBox(height: 4.h),
                _buildIconText(
                  Iconsax.user,
                  '${recipe.servings} ${'servings'.tr}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: AppColors.primary),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: AppColors.grey400),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFFC8E6C9);
      case 'medium':
        return const Color(0xFFFFF9C4);
      case 'hard':
        return const Color(0xFFFFCDD2);
      default:
        return AppColors.lightGrey;
    }
  }
}
