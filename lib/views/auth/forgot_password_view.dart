import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/themes/app_colors.dart';
import '../../shared/widgets/background.dart';
import '../../shared/widgets/custom_text_field.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      showLogo: false,
      title: 'forgot_password'.tr,
      subtitle: 'forgot_password_subtitle'.tr,
      child: Obx(
        () => Form(
          key: controller.forgotPasswordFormKey,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              CustomTextField(
                hintText: 'email'.tr,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email is required';
                  if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 100.h),
              ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.resetPassword,
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('reset_password'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
