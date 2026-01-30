import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/themes/app_colors.dart';
import 'recipe_detail_controller.dart';

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
                    controller.recipe.title,
                    style: GoogleFonts.baloo2(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    controller.recipe.description,
                    style: GoogleFonts.baloo2(
                      fontSize: 14.sp,
                      color: AppColors.secondary.withOpacity(0.8),
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
    return Hero(
      tag: 'recipe_${controller.recipe.id}',
      child: Container(
        height: 179.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(20.r),
          image: DecorationImage(
            image: AssetImage(controller.recipe.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Semi-transparent overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            // Play button center
            Center(
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.skip_previous, color: Colors.white, size: 24.sp),
                    SizedBox(width: 10.w),
                    Icon(Icons.play_arrow, color: Colors.white, size: 40.sp),
                    SizedBox(width: 10.w),
                    Icon(Icons.skip_next, color: Colors.white, size: 24.sp),
                  ],
                ),
              ),
            ),
            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Progress bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: LinearProgressIndicator(
                      value: 0.1,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.red,
                      ),
                      minHeight: 3.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 10.w),
                        Icon(Icons.skip_next, color: Colors.white, size: 20.sp),
                        SizedBox(width: 10.w),
                        Icon(Icons.volume_up, color: Colors.white, size: 20.sp),
                        SizedBox(width: 10.w),
                        Text(
                          '3.38/30.31',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ],
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
          '${(controller.recipe.viewsCount ?? 0) ~/ 1000}k ${'views_count'.tr}  ${controller.recipe.postedTime ?? ''}',
          style: GoogleFonts.baloo2(fontSize: 14.sp, color: AppColors.grey),
        ),
        const Spacer(),
        Row(
          children: [
            Icon(
              Icons.thumb_up_alt_outlined,
              color: AppColors.primary,
              size: 18.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              '${(controller.recipe.likesCount ?? 0) / 1000}k',
              style: GoogleFonts.baloo2(fontSize: 14.sp, color: AppColors.grey),
            ),
            SizedBox(width: 12.w),
            Icon(
              Icons.thumb_down_alt_outlined,
              color: Colors.orange.shade300,
              size: 18.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              '${(controller.recipe.dislikesCount ?? 0) / 1000}k',
              style: GoogleFonts.baloo2(fontSize: 14.sp, color: AppColors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(Icons.star, color: Colors.orange, size: 18.sp);
        }),
        SizedBox(width: 8.w),
        Text(
          '(${controller.recipe.reviewsCount ?? 0})',
          style: GoogleFonts.baloo2(fontSize: 14.sp, color: AppColors.grey),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
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
  }

  Widget _buildIngredientsList() {
    final ingredients = controller.recipe.ingredients ?? [];
    return Column(
      children: ingredients.asMap().entries.map((entry) {
        final index = entry.key;
        final ingredient = entry.value;
        final isSelected = index == 0; // Highlight first one as in image

        return Container(
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
                    fontSize: 16.sp,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              Text(
                ingredient.amount,
                style: GoogleFonts.baloo2(
                  fontSize: 14.sp,
                  color: AppColors.secondary.withOpacity(0.6),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
