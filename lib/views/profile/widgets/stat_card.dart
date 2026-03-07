import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
import 'package:flutter_svg/svg.dart';
=======
>>>>>>> office/main
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
<<<<<<< HEAD
  final Widget icon;
=======
  final IconData icon;
>>>>>>> office/main
  final Color iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155.w,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
<<<<<<< HEAD
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: 28.sp),
              child: Center(child: icon),
            ),
          ),
=======
          Icon(icon, color: iconColor, size: 24.sp),
>>>>>>> office/main
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.baloo2(
<<<<<<< HEAD
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
=======
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBody,
>>>>>>> office/main
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
<<<<<<< HEAD
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
=======
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
>>>>>>> office/main
              color: AppColors.grey200,
            ),
          ),
        ],
      ),
    );
  }
}
