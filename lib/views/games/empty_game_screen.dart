import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/themes/app_colors.dart';
import '../../shared/utils/app_images.dart';
import '../../shared/widgets/game_header_widget.dart';

class EmptyGameScreen extends StatelessWidget {
  final String title;
  final String? screenText;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? child;

  const EmptyGameScreen({
    super.key,
    required this.title,
    this.screenText,
    this.buttonText = 'done',
    this.onButtonPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              AppImages.bg,
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                GameHeaderWidget(
                  title: title,
                ),
                Expanded(
                  child: child ?? Center(
                    child: Text(
                      screenText ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                // Done Button at the bottom
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // Same color as start button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: GoogleFonts.baloo2(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
