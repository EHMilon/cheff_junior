import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'auth_controller.dart';
import '../../core/themes/app_colors.dart';
import '../../shared/widgets/background.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: AppColors.secondary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 2)),
      ),
    );

    return Background(
      showLogo: false,
      title: 'Enter OTP'.tr,
      subtitle: 'otp_subtitle'.tr,
      child: Obx(
        () => Column(
          children: [
            SizedBox(height: 20.h),
            Pinput(
              length: 4,
              controller: controller.otpController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              onCompleted: (pin) => controller.verifyOtp(),
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t get OTP'.tr,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.textBody),
                ),
                TextButton(
                  onPressed: () => controller.resendOtp(),
                  child: Text(
                    'resend'.tr,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.verifyOtp,
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text('verify'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
