import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/themes/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 16.sp,
        color: AppColors.secondary,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: false, // Transparent background
        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.divider, width: 1.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: TextStyle(color: AppColors.textHint, fontSize: 16.sp),
      ),
    );
  }
}
