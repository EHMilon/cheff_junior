import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
import 'package:flutter_svg/flutter_svg.dart';
=======
>>>>>>> office/main
import 'package:google_fonts/google_fonts.dart';

class SettingsTile extends StatelessWidget {
  final String title;
<<<<<<< HEAD
  final Widget icon;
=======
  final IconData icon;
>>>>>>> office/main
  final VoidCallback onTap;
  final bool isLast;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              children: [
<<<<<<< HEAD
                icon,
=======
                Icon(icon, size: 20.sp, color: AppColors.grey200),
>>>>>>> office/main
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.baloo2(
<<<<<<< HEAD
                      fontSize: 16.sp,
                      color: AppColors.grey400,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
=======
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBody,
>>>>>>> office/main
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: AppColors.grey200,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: AppColors.divider.withOpacity(0.3),
            indent: 52.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}
