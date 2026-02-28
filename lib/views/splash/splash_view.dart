import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../auth/auth_controller.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_colors.dart';

/// Splash screen that checks authentication status and redirects accordingly
///
/// This is the initial route of the app. It:
/// 1. Shows a splash screen with app branding
/// 2. Checks if user is already logged in
/// 3. Redirects to Home if logged in, or Sign In if not
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _checkAuthAndNavigate();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  /// Check auth status and navigate to appropriate screen
  Future<void> _checkAuthAndNavigate() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in
    final isLoggedIn = _authController.checkAuthStatus();

    if (isLoggedIn) {
      // User is logged in, go to home
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      // User is not logged in, go to sign in
      Get.offAllNamed(AppRoutes.SIGN_IN);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  size: 60.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),
              // App Name
              Text(
                'Chef Junior',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(height: 8.h),
              // Tagline
              Text(
                'Learn to cook like a pro',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textBody),
              ),
              SizedBox(height: 48.h),
              // Loading indicator
              SizedBox(
                width: 32.w,
                height: 32.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
