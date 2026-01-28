import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/hi.png',
          width: 32.w,
          height: 41.h,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${'welcome'.tr} Reen',
                style: GoogleFonts.baloo2(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBody,
                ),
              ),
              Text(
                'good_morning'.tr,
                style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
              ),
            ],
          ),
        ),
        _buildIconContainer(
          Icons.favorite_border,
          () => Get.snackbar('Action', 'Opening Favorites'),
        ),
        SizedBox(width: 12.w),
        _buildIconContainer(
          Icons.search,
          () => Get.snackbar('Action', 'Opening Search'),
        ),
      ],
    );
  }

  Widget _buildIconContainer(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB359).withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 24.sp, color: AppColors.primary),
      ),
    );
  }
}
