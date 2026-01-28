import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const SectionHeader({super.key, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.baloo2(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: Text(
            'see_all'.tr,
            style: GoogleFonts.baloo2(
              fontSize: 14.sp,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
