import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/themes/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/utils/app_images.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: showBottomNav ? _buildBottomNavigationBar() : null,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.background,
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
          _buildNavItem(
            index: 0,
            label: 'home'.tr,
            activeIcon: AppImages.homeFill,
            inactiveIcon: AppImages.homeOutline,
            route: AppRoutes.HOME,
          ),
          _buildNavItem(
            index: 1,
            label: 'games'.tr,
            activeIcon: AppImages.gamepadFill,
            inactiveIcon: AppImages.gamepadOutline,
            route: AppRoutes.GAMES,
          ),
          _buildNavItem(
            index: 2,
            label: 'chat'.tr,
            activeIcon:
                AppImages.chatOutline, // TODO: Add avatar_fill.svg if available
            inactiveIcon: AppImages.chatOutline,
            route: AppRoutes.AVATAR_CHAT,
          ),
          _buildNavItem(
            index: 3,
            label: 'profile'.tr,
            activeIcon: AppImages.profileFill,
            inactiveIcon: AppImages.profileOutline,
            route: AppRoutes.PROFILE,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required String activeIcon,
    required String inactiveIcon,
    required String route,
  }) {
    bool isSelected = currentIndex == index;
    Color itemColor = isSelected ? AppColors.primary : AppColors.grey500;

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
            SvgPicture.asset(
              isSelected ? activeIcon : inactiveIcon,
              width: 24.sp,
              height: 24.sp,
              colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.baloo2(
                fontSize: 12.sp,
                color: itemColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            SizedBox(height: 4.h),
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
