import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../../core/themes/app_colors.dart';
import '../../shared/widgets/background.dart';
import '../../shared/widgets/custom_text_field.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      showLogo: true,
      title: 'sign_up'.tr,
      subtitle: 'sign_up_subtitle'.tr,
      child: Obx(
        () => Form(
          key: controller.signUpFormKey,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              CustomTextField(
                hintText: 'name'.tr,
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
                controller: controller.nameController,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Name is required'
                    : null,
              ),
              SizedBox(height: 24.h),
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
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 24.h),
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
              SizedBox(height: 16.h),
              Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: Checkbox(
                      value: controller.agreeToTerms.value,
                      onChanged: (v) => controller.toggleTerms(),
                      activeColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'By using the app you agree to our ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textBody,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy-Policy',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.signUp,
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('sign_up'.tr),
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'already_have_account'.tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textBody,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'sign_in'.tr,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
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
