import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:chef_junior/views/profile/profile_controller.dart';
import 'package:chef_junior/views/profile/widgets/profile_header_card.dart';
import 'package:chef_junior/views/profile/widgets/settings_tile.dart';
import 'package:chef_junior/views/profile/widgets/stat_card.dart';
import 'package:chef_junior/shared/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
import 'package:flutter_svg/flutter_svg.dart';
=======
>>>>>>> office/main
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 3, // Profile is index 3
      body: SafeArea(
        child: Obx(
          () => Skeletonizer(
            enabled: controller.isLoading.value,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
<<<<<<< HEAD
                  SizedBox(height: 20.h),
=======
                  SizedBox(height: 50.h),
>>>>>>> office/main
                  _buildHeader(),
                  SizedBox(height: 24.h),
                  _buildProfileCard(),
                  SizedBox(height: 24.h),
                  _buildStatsRow(),
                  SizedBox(height: 24.h),
                  _buildSettingsSection(),
                  SizedBox(height: 100.h), // Bottom nav space
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'my_profile'.tr,
      style: GoogleFonts.baloo2(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textBody,
      ),
    );
  }

  Widget _buildProfileCard() {
    final user = controller.user.value;
    return ProfileHeaderCard(
      name: user?.name ?? "Loading Name...",
      email: user?.email ?? "loading.email@gmail.com",
      joinedDate: user?.joinedDate ?? "2023",
      profilePhoto: user?.profilePhoto ?? "https://i.pravatar.cc/150",
    );
  }

  Widget _buildStatsRow() {
    final user = controller.user.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatCard(
          title: 'games_played'.tr,
          value: "${user?.gamesPlayed ?? 0}",
<<<<<<< HEAD
          icon: SvgPicture.asset(
            'assets/images/thropy.svg',
            width: 28.w,
            height: 28.w,
          ),
          iconColor: AppColors.primary,
=======
          icon: Icons.emoji_events,
          iconColor: Colors.orange,
>>>>>>> office/main
        ),
        StatCard(
          title: 'recipe_completed'.tr,
          value: "${user?.recipesCompleted ?? 0}",
<<<<<<< HEAD
          icon: SvgPicture.asset(
            'assets/images/completed.svg',
            width: 28.w,
            height: 28.w,
          ),
          iconColor: AppColors.success,
=======
          icon: Icons.check_circle,
          iconColor: Colors.green,
>>>>>>> office/main
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
            child: Text(
              'settings'.tr,
              style: GoogleFonts.baloo2(
<<<<<<< HEAD
                fontSize: 18.sp,
                color: AppColors.textBody,
                fontWeight: FontWeight.w600,
                height: 1.25,
=======
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBody,
>>>>>>> office/main
              ),
            ),
          ),
          SettingsTile(
            title: 'account_settings'.tr,
<<<<<<< HEAD
            icon: SvgPicture.asset(
            'assets/images/profile_outline.svg',
            width: 20.w,
            height: 20.w,
          ),
=======
            icon: Icons.person_outline,
>>>>>>> office/main
            onTap: () => Get.toNamed('/account-settings'),
          ),
          SettingsTile(
            title: 'language'.tr,
<<<<<<< HEAD
            icon: SvgPicture.asset(
            'assets/images/translate.svg',
            width: 20.w,
            height: 20.w,
          ),
=======
            icon: Icons.language_outlined,
>>>>>>> office/main
            onTap: () => Get.toNamed('/language'),
          ),
          SettingsTile(
            title: 'logout'.tr,
<<<<<<< HEAD
            icon: SvgPicture.asset(
            'assets/images/logout.svg',
            width: 20.w,
            height: 20.w,
          ),
=======
            icon: Icons.logout,
>>>>>>> office/main
            onTap: _showLogoutDialog,
            isLast: true,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, color: AppColors.error),
                ),
              ),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.secondary,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'logout_msg'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBody,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: BorderSide(color: AppColors.grey300),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: GoogleFonts.baloo2(color: AppColors.textBody),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'logout'.tr,
                        style: GoogleFonts.baloo2(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
