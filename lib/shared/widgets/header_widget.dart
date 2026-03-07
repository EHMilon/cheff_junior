import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/themes/app_colors.dart';

/// Reusable header widget with back button and title
/// Used across multiple screens for consistent header design
///
/// Example usage:
/// ```dart
/// HeaderWidget(
///   title: 'my_favourites'.tr,
///   onBackPressed: () => Get.back(),
/// )
/// ```
class HeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final double? horizontalPadding;
  final double? iconSize;
  final double? iconContainerSize;

  const HeaderWidget({
    super.key,
    required this.title,
    this.onBackPressed,
    this.horizontalPadding,
    this.iconSize,
    this.iconContainerSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
<<<<<<< HEAD
        Row(
          children: [
            // Back arrow container
            _buildBackButton(),
            SizedBox(width: 20.w),
            // Title
            _buildTitle(),
          ],
=======
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20.w),
          child: Row(
            children: [
              // Back arrow container
              _buildBackButton(),
              SizedBox(width: 20.w),
              // Title
              _buildTitle(),
            ],
          ),
>>>>>>> office/main
        ),
      ],
    );
  }

  /// Builds the back button with consistent styling
  Widget _buildBackButton() {
<<<<<<< HEAD
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: onBackPressed ?? () => Get.back(),
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: iconContainerSize ?? 36.w,
          height: iconContainerSize ?? 36.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.grey400,
            size: iconSize ?? 20.sp,
          ),
=======
    return InkWell(
      onTap: onBackPressed ?? () => Get.back(),
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: iconContainerSize ?? 36.w,
        height: iconContainerSize ?? 36.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Icon(
          Icons.arrow_back,
          color: AppColors.grey400,
          size: iconSize ?? 20.sp,
>>>>>>> office/main
        ),
      ),
    );
  }

  /// Builds the title text with consistent styling
  Widget _buildTitle() {
    return Text(
      title,
      style: GoogleFonts.baloo2(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textBody,
        height: 1.2
      ),
    );
  }
}
