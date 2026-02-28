import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../../core/themes/app_colors.dart';
import '../../shared/widgets/background.dart';
import '../../shared/widgets/custom_text_field.dart';

class CreatePasswordView extends GetView<AuthController> {
  const CreatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      showLogo: false,
      title: 'Create new password'.tr,
      subtitle: 'Create a new unique password'.tr,
      child: Obx(
        () => Form(
          key: controller.createPasswordFormKey,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              CustomTextField(
                hintText: 'password'.tr,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
                obscureText: !controller.isPasswordVisible.value,
                controller: controller.passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.divider,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                hintText: 'confirm_password'.tr,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
                obscureText: !controller.isConfirmPasswordVisible.value,
                controller: controller.confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != controller.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: controller.toggleConfirmPasswordVisibility,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.divider,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(height: 100.h),
              ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.createNewPassword,
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
