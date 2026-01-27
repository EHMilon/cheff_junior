import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_colors.dart';

class UiUtils {
  static void showSnackBar({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? AppColors.error : AppColors.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  static void showNoInternet() {
    showSnackBar(
      title: 'no_internet'.tr,
      message: 'Please check your connection'.tr,
      isError: true,
    );
  }

  static void showServerError() {
    showSnackBar(
      title: 'server_error'.tr,
      message: 'Something went wrong on our side'.tr,
      isError: true,
    );
  }
}
