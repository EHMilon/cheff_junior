import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_colors.dart';
import '../../shared/utils/app_images.dart';
import '../../shared/widgets/background.dart';

class CongratulationsView extends StatelessWidget {
  const CongratulationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      showLogo: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50.h),
          Image.asset(AppImages.shape, height: 200.h),
          SizedBox(height: 30.h),
          Text(
            'congratulations'.tr,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: AppColors.secondary),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'success_msg'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 60.h),
          ElevatedButton(
            onPressed: () => Get.offAllNamed(AppRoutes.SIGN_IN),
            child: Text('sign_in'.tr),
          ),
        ],
      ),
    );
  }
}
