import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/themes/app_colors.dart';

/// Common header widget for all game screens with back button, title, and consistent styling
/// Ensures uniform design across all game-related screens
///
/// Example usage:
/// ```dart
/// GameHeaderWidget(
///   title: 'Game Title',
///   onBackPressed: () => Get.back(),
/// )
/// ```
class GameHeaderWidget extends StatelessWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final double? horizontalPadding;
  final double? iconSize;
  final double? iconContainerSize;

  const GameHeaderWidget({
    super.key,
     this.title,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 18.w),
          child: Row(
            children: [
              // Back arrow container
              _buildBackButton(),
              SizedBox(width: 20.w),
              // Title
              _buildTitle(),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the back button with consistent styling for all game screens
  Widget _buildBackButton() {
    return InkWell(
      onTap: onBackPressed ?? () => Get.back(),
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: iconContainerSize ?? 36.w,
        height: iconContainerSize ?? 36.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.15), // Light orange background
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Icon(
          Icons.arrow_back,
          color: AppColors.grey400,
          size: iconSize ?? 20.sp,
        ),
      ),
    );
  }

  /// Builds the title text with consistent styling for all game screens
  Widget _buildTitle() {
    return Text(
      title?.tr ?? '',
      style: GoogleFonts.baloo2(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textBody,
        height: 1.2
      ),
    );
  }
}
