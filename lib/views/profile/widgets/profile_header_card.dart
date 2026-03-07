import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String joinedDate;
  final String profilePhoto;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.joinedDate,
    required this.profilePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
<<<<<<< HEAD
=======
      margin: EdgeInsets.symmetric(horizontal: 20.w),
>>>>>>> office/main
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: CircleAvatar(
              radius: 30.r,
              backgroundImage: NetworkImage(profilePhoto),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.baloo2(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBody,
                  ),
                ),
                Text(
                  email,
                  style: GoogleFonts.baloo2(
<<<<<<< HEAD
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey400,
              height: 1.20,
                  ),
                ),
                SizedBox(height: 12.h),
=======
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey200,
                  ),
                ),
                SizedBox(height: 8.h),
>>>>>>> office/main
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14.sp,
<<<<<<< HEAD
                      color: AppColors.grey400,
=======
                      color: AppColors.grey200,
>>>>>>> office/main
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "${'joined_since'.tr} $joinedDate",
                      style: GoogleFonts.baloo2(
<<<<<<< HEAD
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey400,
=======
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey200,
>>>>>>> office/main
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
