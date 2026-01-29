import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:chef_junior/shared/widgets/header_widget.dart';
import 'package:chef_junior/views/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountSettingsView extends GetView<ProfileController> {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              HeaderWidget(title: 'account_settings'.tr),
              SizedBox(height: 24.h),
              _buildProfilePhotoSection(),
              SizedBox(height: 16.h),
              _buildPersonalInfoSection(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'profile_photo'.tr,
            style: GoogleFonts.baloo2(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.grey200,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Obx(
                () => CircleAvatar(
                  radius: 30.r,
                  backgroundImage: NetworkImage(
                    controller.user.value?.profilePhoto ?? "",
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.user.value?.name ?? "",
                        style: GoogleFonts.baloo2(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBody,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.user.value?.email ?? "",
                        style: GoogleFonts.baloo2(
                          fontSize: 12.sp,
                          color: AppColors.grey200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Camera icon for editing photo
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'personal_information'.tr,
            style: GoogleFonts.baloo2(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.grey200,
            ),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => controller.isEditingName.value
                ? _buildNameEdit()
                : _buildNameView(),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => controller.isEditingPassword.value
                ? _buildPasswordEdit()
                : _buildPasswordView(),
          ),
        ],
      ),
    );
  }

  Widget _buildNameView() {
    return _buildInfoRow(
      label: 'name'.tr,
      value: controller.user.value?.name ?? "",
      onEdit: controller.toggleEditName,
    );
  }

  Widget _buildNameEdit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'name'.tr,
          style: GoogleFonts.baloo2(fontSize: 12.sp, color: AppColors.textBody),
        ),
        SizedBox(height: 8.h),
        TextField(
          onChanged: (v) => controller.nameInput.value = v,
          decoration: InputDecoration(
            hintText: controller.user.value?.name,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.toggleEditName,
                child: Text('cancel'.tr),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.updateName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'save'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordView() {
    return _buildInfoRow(
      label: 'your_password'.tr,
      value: "********",
      onEdit: controller.toggleEditPassword,
    );
  }

  Widget _buildPasswordEdit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPasswordField(
          'current_password'.tr,
          (v) => controller.currentPassword.value = v,
        ),
        SizedBox(height: 12.h),
        _buildPasswordField(
          'new_password'.tr,
          (v) => controller.newPassword.value = v,
        ),
        SizedBox(height: 12.h),
        _buildPasswordField(
          'confirm_password'.tr,
          (v) => controller.confirmPassword.value = v,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.toggleEditPassword,
                child: Text('cancel'.tr),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'save'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.baloo2(fontSize: 12.sp, color: AppColors.textBody),
        ),
        SizedBox(height: 8.h),
        TextField(
          obscureText: true,
          onChanged: (v) => onChanged(v),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            suffixIcon: const Icon(Icons.visibility_off_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.baloo2(
                fontSize: 12.sp,
                color: AppColors.grey200,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.baloo2(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textBody,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: onEdit,
          icon: Icon(
            Icons.edit_outlined,
            size: 20.sp,
            color: AppColors.textBody,
          ),
        ),
      ],
    );
  }
}
