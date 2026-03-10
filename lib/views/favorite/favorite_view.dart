import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/themes/app_colors.dart';
import '../../shared/utils/app_images.dart';
import '../../shared/widgets/header_widget.dart';
import '../home/widgets/recipe_card.dart';
import 'favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensuring controller is initialized
    if (!Get.isRegistered<FavoriteController>()) {
      Get.put(FavoriteController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (!controller.isOnline.value) {
            return _buildNoInternetView();
          }

          return _buildFavoriteContent();
        }),
      ),
    );
  }

  Widget _buildFavoriteContent() {
    return Column(
      children: [
        SizedBox(width: 16.w),
        HeaderWidget(
          title: 'my_favourites'.tr,
          onBackPressed: () => Get.back(),
        ),
        SizedBox(height: 22.h),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              // Show loading state
              return const Center(child: CircularProgressIndicator());
            } else if (controller.isEmpty.value) {
              // Show empty state
              return _buildEmptyState();
            } else {
              // Show favorite recipes list
              return _buildFavoriteRecipesList();
            }
          }),
        ),
      ],
    );
  }

  Widget _buildFavoriteRecipesList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.builder(
        itemCount: controller.favorites.length,
        itemBuilder: (context, index) {
          final recipe = controller.favorites[index];
          return RecipeCard(
            recipe: recipe,
            verticalLayout: true, // Use vertical layout for favorite screen
            onFavoriteToggle: () => controller.toggleFavorite(recipe.id),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 72.h),

        // Box open icon
        SvgPicture.asset(
          AppImages.boxOpen,
          width: 100.88.w,
          height: 100.88.h,
          color: AppColors.grey200,
        ),
        SizedBox(height: 16.h),
        
        // Empty message
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Text(
                'favourite_empty_title'.tr,
                style: GoogleFonts.baloo2(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'favourite_empty_subtitle'.tr,
                style: GoogleFonts.baloo2(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey200,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 32.h),
        // Explore Recipe button
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20.w),
        //   child: Container(
        //     width: double.infinity,
        //     // TODO: Navigate to Recipe Explorar Screen
        //     height: 48.h,
        //     decoration: BoxDecoration(
        //       color: AppColors.primary,
        //       borderRadius: BorderRadius.circular(50.r),
        //     ),
        //     child: Center(
        //       child: Text(
        //         'explore_recipe'.tr,
        //         style: GoogleFonts.baloo2(
        //           fontSize: 14.sp,
        //           fontWeight: FontWeight.w700,
        //           color: AppColors.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Spacer(),
      ],
    );
  }

  // Note: toggleFavorite is now handled by FavoriteController

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
            onPressed: () => controller.checkConnectivity(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
