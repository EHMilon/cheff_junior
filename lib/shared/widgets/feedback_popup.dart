import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/themes/app_colors.dart';
import '../../data/models/feedback_model.dart';

/// Feedback popup widget
/// Shows a feedback form with star rating and comment field
class FeedbackPopup extends StatelessWidget {
  final Function(FeedbackModel) onSubmit;

  const FeedbackPopup({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20.w),
      child: Container(
        width: 335.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCloseButton(),
              SizedBox(height: 43.h),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () => Get.back(),
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Icon(Icons.close, color: AppColors.error, size: 24.sp),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final TextEditingController commentController = TextEditingController();
    final RxInt rating = 0.obs;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(),
        SizedBox(height: 32.h),
        _buildRating(rating),
        SizedBox(height: 48.h),
        _buildCommentField(commentController),
        SizedBox(height: 48.h),
        _buildButtons(rating, commentController),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'We appreciate your feedback.',
          textAlign: TextAlign.center,
          style: GoogleFonts.baloo2(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF242424),
            height: 1.6,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'We are always looking for ways to improve your experience.',
          textAlign: TextAlign.center,
          style: GoogleFonts.baloo2(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6C6C6C),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildRating(RxInt rating) {
    return Obx(() {
      return RatingBar.builder(
        initialRating: rating.value.toDouble(),
        minRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
        itemBuilder: (context, _) => SvgPicture.asset(
          'assets/images/star_outline.svg',
          color: rating.value > 0 ? AppColors.primary : const Color(0xFF505050),
          width: 24.sp,
          height: 24.sp,
        ),
        onRatingUpdate: (value) {
          rating.value = value.toInt();
        },
      );
    });
  }

  Widget _buildCommentField(TextEditingController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: const Color(0xFFE9E9E9)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'What can we do to improve your experience?',
          hintStyle: GoogleFonts.baloo2(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9A9A9A),
            height: 1.6,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: GoogleFonts.baloo2(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF242424),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildButtons(RxInt rating, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              if (rating.value == 0) {
                Get.snackbar(
                  'Error',
                  'Please select a rating',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                );
                return;
              }

              final feedback = FeedbackModel(
                rating: rating.value,
                comment: controller.text.isEmpty ? null : controller.text,
              );

              onSubmit(feedback);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            child: Text(
              'Submit My Feedback',
              style: GoogleFonts.baloo2(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
        ),
        SizedBox(width: 18.w),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            child: Text(
              'Skip',
              style: GoogleFonts.baloo2(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Show feedback popup
void showFeedbackPopup({required Function(FeedbackModel) onSubmit}) {
  Get.dialog(
    FeedbackPopup(onSubmit: onSubmit),
    barrierDismissible: true,
    barrierColor: Colors.black54,
  );
}
