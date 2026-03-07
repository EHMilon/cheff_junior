import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/themes/app_colors.dart';
import '../../data/models/feedback_model.dart';
import '../../data/models/ingredient_detail_model.dart';
import '../../shared/utils/looger_utills.dart';
import '../../shared/widgets/feedback_popup.dart';
import '../../shared/widgets/ingredient_detail_popup.dart';
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
<<<<<<< HEAD
    final imageUrl = controller.recipe.imageUrl;
    final isNetworkImage = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    
=======
>>>>>>> office/main
    return Hero(
      tag: 'recipe_${controller.recipe.id}',
      child: Container(
        height: 179.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(20.r),
          image: DecorationImage(
<<<<<<< HEAD
            image: isNetworkImage
                ? NetworkImage(imageUrl) as ImageProvider
                : AssetImage(imageUrl),
=======
            image: AssetImage(controller.recipe.imageUrl),
>>>>>>> office/main
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
            // Play button center
            Center(
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
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
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.red,
                      ),
                      minHeight: 3.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.volume_up,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            '3.38/30.31',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ],
                      ),
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
            Icon(
              Icons.thumb_up_alt_outlined,
              color: AppColors.primary,
              size: 18.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              '${(controller.recipe.likesCount ?? 0) / 1000}k',
              style: GoogleFonts.baloo2(
                fontSize: 14.sp,
                color: const Color(0xFF505050),
              ),
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
    return Row(
      children: [
        ...List.generate(5, (index) {
          return SvgPicture.asset(
            "assets/images/star_filled.svg",
            width: 16.sp,
            height: 16.sp,
          );
        }),
        SizedBox(width: 8.w),
        Text(
          '(${controller.recipe.reviewsCount ?? 0})',
          style: GoogleFonts.baloo2(fontSize: 14.sp, color: AppColors.grey),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            showFeedbackPopup(
              onSubmit: (FeedbackModel feedback) {
                // TODO: Submit feedback to backend API
                Log.d(
                  'Feedback submitted: ${feedback.rating} stars, Comment: ${feedback.comment}',
                );
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
  }

  Widget _buildIngredientsList() {
    final ingredients = controller.recipe.ingredients ?? [];
    return Column(
      children: ingredients.asMap().entries.map((entry) {
        final index = entry.key;
        final ingredient = entry.value;
        final isSelected = index == 0; // Highlight first one as in image

        return GestureDetector(
          onTap: () {
            // Convert to IngredientDetail and show popup
            final ingredientDetail = IngredientDetail(
              id: '${controller.recipe.id}_ingredient_$index',
              name: ingredient.name,
              amount: ingredient.amount,
              icon: ingredient.icon,
              origin: _getOrigin(ingredient.name),
              history: _getHistory(ingredient.name),
              nutrients: _getNutrients(ingredient.name),
              funFacts: _getFunFacts(ingredient.name),
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

  // TODO: Replace with actual API call when backend is integrated
  String? _getOrigin(String ingredientName) {
    final origins = {
      'Chicken': 'Worldwide',
      'Rice': 'Asia',
      'Onion': 'Central Asia',
      'Garlic': 'Central Asia',
      'Oil': 'Various origins',
      'Salt': 'Worldwide',
      'Pepper': 'India',
      'Pizza dough': 'Italy',
    };
    return origins[ingredientName];
  }

  // TODO: Replace with actual API call when backend is integrated
  String? _getHistory(String ingredientName) {
    final histories = {
      'Chicken':
          'Domesticated thousands of years ago, chickens are now one of the most common and widespread domestic animals.',
      'Rice':
          'Cultivated for over 10,000 years, rice is a staple food for more than half the world population.',
      'Onion':
          'Used in cooking for over 5,000 years, onions have been a fundamental part of cuisines worldwide.',
      'Garlic':
          'Used for both culinary and medicinal purposes for over 7,000 years.',
      'Oil':
          'Humans have been using oil for cooking and lighting for thousands of years.',
      'Salt':
          'An essential mineral used as a seasoning for thousands of years, salt has been historically valuable.',
      'Pepper':
          'One of the most widely used spices in the world, pepper has been a valuable commodity since ancient times.',
      'Pizza dough':
          'Originated in Naples, Italy (18th century). Ancient Egyptians, Greeks, and Romans all had versions of flat, yeasted or unleavened breads topped with herbs and oils.',
    };
    return histories[ingredientName];
  }

  // TODO: Replace with actual API call when backend is integrated
  List<Nutrient>? _getNutrients(String ingredientName) {
    final nutrients = {
      'Pizza dough': [
        Nutrient(name: 'Protein', value: '10g'),
        Nutrient(name: 'Calcium', value: '10g'),
        Nutrient(name: 'Vitamin B12', value: '10g'),
        Nutrient(name: 'Healthy fats', value: '10g'),
      ],
      'Chicken': [
        Nutrient(name: 'Protein', value: '31g'),
        Nutrient(name: 'Calories', value: '165'),
        Nutrient(name: 'Fat', value: '3.6g'),
        Nutrient(name: 'Carbs', value: '0g'),
      ],
      'Rice': [
        Nutrient(name: 'Carbs', value: '28g'),
        Nutrient(name: 'Calories', value: '130'),
        Nutrient(name: 'Protein', value: '2.7g'),
        Nutrient(name: 'Fat', value: '0.3g'),
      ],
    };
    return nutrients[ingredientName];
  }

  // TODO: Replace with actual API call when backend is integrated
  List<String>? _getFunFacts(String ingredientName) {
    final funFacts = {
      'Pizza dough': [
        'Pizza dough stretches because of gluten, which acts like tiny rubber bands.',
        'In Italy, pizza dough is often rested for 24 hours for better flavor.',
      ],
      'Chicken': [
        'Chickens can recognize over 100 different faces.',
        'Chickens have a complex communication system with over 30 different calls.',
      ],
      'Rice': [
        'Rice is grown on every continent except Antarctica.',
        'There are over 10,000 varieties of rice.',
      ],
    };
    return funFacts[ingredientName];
  }
}
