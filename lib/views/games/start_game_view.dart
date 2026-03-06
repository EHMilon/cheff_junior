import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/themes/app_colors.dart';
import '../../shared/utils/app_images.dart';
import '../../shared/widgets/game_header_widget.dart';
import 'controllers/start_game_controller.dart';

class StartGameView extends GetView<StartGameController> {
  const StartGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F2), // Background from Figma
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            GameHeaderWidget(
              // title: 'lets_started'.tr,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    children: [
                      SizedBox(height: 32.h),
                      // Game Image - Kids in Balloon
                      _buildGameImage(),
                      SizedBox(height: 32.h),
                      // Text Content
                      _buildTextContent(),
                      SizedBox(height: 48.h),
                      // Start Button
                      _buildStartButton(),
                      SizedBox(height: 32.h), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  
  Widget _buildGameImage() {
    return SizedBox(
      width: 249.w,
      height: 252.h,
  
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Image.asset(
          AppImages.startGame,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      children: [
        // Title: Let's Started!
        Text(
          'lets_started'.tr,
          style: GoogleFonts.baloo2(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.grey400, // #242424 equivalent
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        // Description
        Text(
          'start_game_description'.tr,
          style: GoogleFonts.baloo2(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.grey400, // #505050 from Figma
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: controller.onStartTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Use primary color for consistency
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
        child: Text(
          'start'.tr,
          style: GoogleFonts.baloo2(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
