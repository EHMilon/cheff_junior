import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:chef_junior/shared/widgets/header_widget.dart';
import 'package:chef_junior/views/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.grey400,
              height: 1.25,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Obx(
                () => Stack(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundImage:
                          controller.user.value?.avatarUrl != null &&
                              controller.user.value!.avatarUrl!.isNotEmpty
                          ? NetworkImage(controller.user.value!.avatarUrl!)
                          : null,
                      child:
                          controller.user.value?.avatarUrl == null ||
                              controller.user.value!.avatarUrl!.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 30.r,
                              color: AppColors.grey400,
                            )
                          : null,
                    ),
                    if (controller.isUpdatingAvatar.value)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
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
                          color: AppColors.grey400,
                          height: 1.67,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Camera icon for editing photo
              GestureDetector(
                onTap: _showAvatarUploadOptions,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAvatarUploadOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Profile Photo',
                style: GoogleFonts.baloo2(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBody,
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.baloo2(fontSize: 16.sp),
                ),
                onTap: () {
                  Get.back();
                  // TODO: Implement image picker and call controller.uploadAvatar(filePath)
                  // You can use image_picker package or file_picker package
                  // Example: controller.uploadAvatar(selectedFilePath);
                  _showUploadPlaceholder();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text(
                  'Take a Photo',
                  style: GoogleFonts.baloo2(fontSize: 16.sp),
                ),
                onTap: () {
                  Get.back();
                  // TODO: Implement camera capture and call controller.uploadAvatar(filePath)
                  _showUploadPlaceholder();
                },
              ),
              if (controller.user.value?.avatarUrl != null &&
                  controller.user.value!.avatarUrl!.isNotEmpty)
                ListTile(
                  leading: Icon(Icons.delete, color: AppColors.error),
                  title: Text(
                    'Remove Photo',
                    style: GoogleFonts.baloo2(
                      fontSize: 16.sp,
                      color: AppColors.error,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    // TODO: Call API to remove avatar
                  },
                ),
              SizedBox(height: 10.h),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.baloo2(
                      fontSize: 16.sp,
                      color: AppColors.grey400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadPlaceholder() {
    Get.snackbar(
      'Info',
      'Please add image_picker package to enable avatar upload. Then call controller.uploadAvatar(filePath)',
      backgroundColor: AppColors.primary.withOpacity(0.1),
      colorText: AppColors.primary,
      duration: const Duration(seconds: 3),
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
              fontSize: 16.sp,
              color: AppColors.textBody,
              fontWeight: FontWeight.w600,
              height: 1.25,
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
          isVisible: controller.isCurrentPasswordVisible,
          onToggle: controller.toggleCurrentPasswordVisibility,
        ),
        SizedBox(height: 12.h),
        _buildPasswordField(
          'new_password'.tr,
          (v) => controller.newPassword.value = v,
          isVisible: controller.isNewPasswordVisible,
          onToggle: controller.toggleNewPasswordVisibility,
        ),
        SizedBox(height: 12.h),
        _buildPasswordField(
          'confirm_password'.tr,
          (v) => controller.confirmPassword.value = v,
          isVisible: controller.isConfirmPasswordVisible,
          onToggle: controller.toggleConfirmPasswordVisibility,
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

  Widget _buildPasswordField(
    String label,
    Function(String) onChanged, {
    required RxBool isVisible,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.baloo2(fontSize: 12.sp, color: AppColors.textBody),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => TextField(
            obscureText: !isVisible.value,
            onChanged: (v) => onChanged(v),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              suffixIcon: IconButton(
                onPressed: onToggle,
                icon: Icon(
                  color: AppColors.grey200,
                  isVisible.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
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
                fontSize: 14.sp,
                color: AppColors.textBody,
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
          icon: SvgPicture.asset(
            'assets/images/edit.svg',
            width: 16.w,
            height: 16.w,
          ),
        ),
      ],
    );
  }
}
