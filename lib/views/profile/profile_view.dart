import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:chef_junior/views/home/home_controller.dart';
import 'package:chef_junior/views/profile/profile_controller.dart';
import 'package:chef_junior/views/profile/widgets/profile_header_card.dart';
import 'package:chef_junior/views/profile/widgets/settings_tile.dart';
import 'package:chef_junior/views/profile/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:iconsax/iconsax.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the HomeController for bottom navigation
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(
          () => Skeletonizer(
            enabled: controller.isLoading.value,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
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
      bottomNavigationBar: _buildBottomNavigationBar(homeController),
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
          icon: Icons.emoji_events,
          iconColor: Colors.orange,
        ),
        StatCard(
          title: 'recipe_completed'.tr,
          value: "${user?.recipesCompleted ?? 0}",
          icon: Icons.check_circle,
          iconColor: Colors.green,
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
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBody,
              ),
            ),
          ),
          SettingsTile(
            title: 'account_settings'.tr,
            icon: Icons.person_outline,
            onTap: () => Get.toNamed('/account-settings'),
          ),
          SettingsTile(
            title: 'language'.tr,
            icon: Icons.language_outlined,
            onTap: () => Get.toNamed('/language'),
          ),
          SettingsTile(
            title: 'logout'.tr,
            icon: Icons.logout,
            onTap: _showLogoutDialog,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(HomeController homeController) {
    return Obx(
      () => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(homeController, 0, 'home'.tr, Iconsax.home),
            _buildNavItem(homeController, 1, 'games'.tr, Iconsax.game),
            _buildNavItem(homeController, 2, 'avatar'.tr, Iconsax.user),
            _buildNavItem(
              homeController,
              3,
              'profile'.tr,
              Iconsax.profile_2user,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    HomeController homeController,
    int index,
    String label,
    IconData icon,
  ) {
    bool isSelected = homeController.currentIndex.value == index;
    return InkWell(
      onTap: () {
        homeController.changeTabIndex(index);

        if (index == 3) {
          // Already on profile screen
        } else if (index == 2) {
          // TODO: Open Avatar screen
          Get.snackbar('Avatar', 'Avatar screen coming soon');
        } else if (index == 1) {
          // TODO: Open Games screen
          Get.snackbar('Games', 'Games screen coming soon');
        } else if (index == 0) {
          Get.back();
        }
      },
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.grey,
              size: 24.sp,
            ),
            Text(
              label,
              style: GoogleFonts.baloo2(
                fontSize: 12.sp,
                color: isSelected ? AppColors.primary : AppColors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
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
