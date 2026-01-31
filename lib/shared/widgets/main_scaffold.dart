import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/themes/app_colors.dart';
import '../../core/routes/app_routes.dart';

/// Main scaffold widget that provides consistent bottom navigation
/// across all main screens (Home, Games, Avatar, Profile)
class MainScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final PreferredSizeWidget? appBar;
  final bool showBottomNav;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const MainScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.appBar,
    this.showBottomNav = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: showBottomNav ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
          _buildNavItem(0, 'home'.tr, Iconsax.home, AppRoutes.HOME),
          _buildNavItem(1, 'games'.tr, 'assets/images/gamepad.svg', AppRoutes.GAMES),
          _buildNavItem(2, 'avatar'.tr, Iconsax.user, AppRoutes.AVATAR_CHAT),
          _buildNavItem(
            3,
            'profile'.tr,
            Iconsax.profile_2user,
            AppRoutes.PROFILE,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, dynamic icon, String route) {
    bool isSelected = currentIndex == index;
    Color itemColor = isSelected ? AppColors.primary : AppColors.grey;

    return InkWell(
      onTap: () => _handleNavigation(index, route),
      borderRadius: BorderRadius.circular(15.r),
      splashColor: AppColors.primary.withOpacity(0.1),
      highlightColor: AppColors.primary.withOpacity(0.05),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon is String)
              SvgPicture.asset(
                icon,
                width: 24.sp,
                height: 24.sp,
                colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
              )
            else if (icon is IconData)
              Icon(icon, color: itemColor, size: 24.sp),
            Text(
              label,
              style: GoogleFonts.baloo2(
                fontSize: 12.sp,
                color: itemColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index, String route) {
    // Don't navigate if already on the same screen
    if (currentIndex == index) {
      return;
    }

    // Navigate to the selected route
    switch (route) {
      case AppRoutes.HOME:
        Get.offAllNamed(AppRoutes.HOME);
        break;
      case AppRoutes.GAMES:
        Get.offAllNamed(AppRoutes.GAMES);
        break;
      case AppRoutes.AVATAR_CHAT:
        Get.toNamed(AppRoutes.AVATAR_CHAT);
        break;
      case AppRoutes.PROFILE:
        Get.toNamed(AppRoutes.PROFILE);
        break;
      default:
        Get.toNamed(route);
    }
  }
}
