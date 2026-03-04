import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_images.dart';

class Background extends StatelessWidget {
  final Widget child;
  final bool showLogo;
  final String? title;
  final String? subtitle;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? appBar;
  final bool bottomSafeArea;

  const Background({
    super.key,
    required this.child,
    this.showLogo = false,
    this.title,
    this.subtitle,
    this.isScrollable = true,
    this.padding,
    this.appBar,
    this.bottomSafeArea = false,
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
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: appBar,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(AppImages.bg, fit: BoxFit.fill),
              ),
              SafeArea(bottom: bottomSafeArea, child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    Widget content = Column(
      children: [
        if (showLogo || title != null || subtitle != null)
          SizedBox(height: 40.h),
        if (showLogo) ...[
          Image.asset(AppImages.icon, height: 100.h),
          SizedBox(height: 10.h),
        ],
        if (title != null) ...[
          Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF8C4F08),
              height: 1.20,
              letterSpacing: -1.44,
            ),
          ),
          SizedBox(height: 4.h),
        ],
        if (subtitle != null) ...[
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 30.h),
        ],
        child,
        SizedBox(height: 40.h),
      ],
    );

    if (isScrollable) {
      return SingleChildScrollView(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
        child: content,
      );
    } else {
      return Padding(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
        child: content,
      );
    }
  }
}
