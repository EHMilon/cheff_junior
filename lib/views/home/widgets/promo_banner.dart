import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 20.w, right: 0.w, top: 20.h, bottom: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB359),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150.w,
                child: Text(
                  'learn_cook_enjoy'.tr,
                  style: GoogleFonts.baloo2(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: 130.w,
                child: Text(
                  'banner_desc'.tr,
                  style: GoogleFonts.baloo2(
                    fontSize: 12.sp,
                    color: AppColors.secondary.withOpacity(0.8),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -10.w,
            bottom: -10.h,
            child: Image.asset(
              'assets/images/cooking.png',
              height: 160.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
