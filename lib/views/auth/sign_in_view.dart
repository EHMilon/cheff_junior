import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_colors.dart';
import '../../shared/widgets/background.dart';
import '../../shared/widgets/custom_text_field.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      showLogo: true,
      title: 'sign_in'.tr,
      subtitle: 'sign_in_subtitle'.tr,
      child: Obx(
        () => Form(
          key: controller.signInFormKey,
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
                  if (value == null || value.isEmpty)
                    return 'Password is required';
                  if (value.length < 6)
                    return 'Password must be at least 6 characters';
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.FORGOT_PASSWORD),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    'forgot_password'.tr,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.signIn,
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('sign_in'.tr),
              ),
              SizedBox(height: 60.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'dont_have_account'.tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textBody,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.SIGN_UP),
                    child: Text(
                      'sign_up'.tr,
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
