import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  /// Returns the appropriate greeting based on the current time of day.
  /// - Morning: 5 AM to 12 PM (noon)
  /// - Afternoon: 12 PM to 5 PM
  /// - Evening: 5 PM to 9 PM
  /// - Night: 9 PM to 4 AM
  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'good_morning'.tr;
    } else if (hour >= 12 && hour < 17) {
      return 'good_afternoon'.tr;
    } else if (hour >= 17 && hour < 21) {
      return 'good_evening'.tr;
    } else {
      return 'good_night'.tr;
    }
  }

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
                '${'welcome'.tr} ${Get.find<AuthService>().getUserName()}',
                style: GoogleFonts.baloo2(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey400,
                  height: 1.2,
                ),
              ),
              Text(
                _getTimeBasedGreeting(),
                style: TextStyle(fontSize: 12.sp, color: AppColors.grey200, fontWeight: FontWeight.w400, height: 1.2,)
              ),
            ],
          ),
        ),
        _buildIconContainer(
          SvgPicture.asset('assets/images/love.svg', width: 20.w, height: 20.h),
          () => Get.toNamed(AppRoutes.FAVORITE),
        ),
        SizedBox(width: 12.w),
        _buildIconContainer(SvgPicture.asset('assets/images/search.svg', width: 20.w, height: 20.h), () => Get.toNamed(AppRoutes.SEARCH)),
      ],
    );
  }

  Widget _buildIconContainer(Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 36.w,
          height: 36.h,
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: const Color(0xBFFFCB91),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
        child: icon,
      ),
    );
  }
}
