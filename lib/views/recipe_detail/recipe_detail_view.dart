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

class RecipeDetailView extends GetView<RecipeDetailController> {
  const RecipeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final recipe = controller.recipeDetail.value;

          if (controller.isLoading.value && recipe == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                SizedBox(height: 20.h),

                _buildVideoPlayer(),

                SizedBox(height: 12.h),

                _buildMetadataRow(recipe),

                SizedBox(height: 12.h),

                _buildRatingRow(),

                SizedBox(height: 20.h),

                Text(
                  recipe?.title ?? '',
                  style: GoogleFonts.baloo2(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),

                SizedBox(height: 10.h),

                Text(
                  recipe?.description ?? '',
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

                _buildIngredientsList(recipe),
              ],
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
              size: 24.sp,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    if (controller.videoPlayerController != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: VideoPlayerWidget(
          controller: controller.videoPlayerController!,
          aspectRatio: 16 / 9,
          width: 1.sw - 32.w,
        ),
      );
    }

    return Container(
      height: 179.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.grey300,
      ),
      child: const Center(child: Icon(Icons.videocam_off)),
    );
  }

  Widget _buildMetadataRow(RecipeDetail? recipe) {
    return Row(
      children: [
        Text(
          '${recipe?.viewsCount ?? 0} ${'views_count'.tr}',
          style: GoogleFonts.baloo2(fontSize: 14.sp),
        ),

        const Spacer(),

        Row(
          children: [
            Icon(Icons.favorite_outline, size: 18.sp, color: AppColors.primary),

            SizedBox(width: 4.w),

            Text(
              '${recipe?.favoritesCount ?? 0}',
              style: GoogleFonts.baloo2(fontSize: 14.sp),
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
                  final success = await controller.submitReview(
                    feedback.rating,
                  );
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

  Widget _buildIngredientsList(RecipeDetail? recipe) {
    final ingredients = recipe?.ingredients ?? [];

    return Column(
      children: ingredients.map((ingredient) {
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              Text(ingredient.icon ?? '🍲', style: TextStyle(fontSize: 24.sp)),

              SizedBox(width: 12.w),

              Expanded(
                child: Text(
                  ingredient.name,
                  style: GoogleFonts.baloo2(fontSize: 14.sp),
                ),
              ),

              // Text(
              //   ingredient.amount,
              //   style: GoogleFonts.baloo2(fontSize: 14.sp),
              // ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
