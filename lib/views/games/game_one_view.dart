import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/themes/app_colors.dart';
import '../../shared/utils/app_images.dart';
import '../../shared/widgets/background.dart';
import '../../shared/widgets/game_header_widget.dart';
import '../../core/routes/app_routes.dart';
import 'controllers/game_one_controller.dart';

class EmptyGameOneView extends StatelessWidget {
  const EmptyGameOneView({super.key});

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
                  title: 'empty_game_title'.tr, // Will need to add this to localization
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Container(
                        child: SvgPicture.asset("assets/images/game1.svg"),
                      ),
                    )
                  ),
                ),
                // Done Button at the bottom
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        // Using postFrameCallback to ensure the controller is ready
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Get.toNamed(AppRoutes.EMPTY_GAME_TWO);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // Same color as start button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        'done'.tr,
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
