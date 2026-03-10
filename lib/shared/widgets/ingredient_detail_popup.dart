import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/themes/app_colors.dart';
import '../../data/models/ingredient_detail_model.dart';

/// Ingredient detail popup widget
/// Shows detailed information about an ingredient when clicked
class IngredientDetailPopup extends StatelessWidget {
  final IngredientDetail ingredient;

  const IngredientDetailPopup({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20.w),
      child: Container(
        width: 335.w,
        constraints: BoxConstraints(maxHeight: Get.height * 0.80),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildOriginSection(),
                SizedBox(height: 20.h),
                _buildHistorySection(),
                SizedBox(height: 20.h),
                _buildNutritionSection(),
                SizedBox(height: 20.h),
                _buildFunFactsSection(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ingredient.name,
          style: GoogleFonts.baloo2(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        InkWell(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Icon(Icons.close, color: Colors.red, size: 24.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildOriginSection() {
    if (ingredient.origin == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              "assets/images/location.svg",
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(width: 12.w),
            Text(
              'Origin:',
              style: GoogleFonts.baloo2(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.only(left: 36.w),
          child: Text(
            ingredient.origin!,
            style: GoogleFonts.baloo2(
              fontSize: 16.sp,
              color: AppColors.grey400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    if (ingredient.history == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              "assets/images/sheet.svg",
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(width: 12.w),
            Text(
              'History:',
              style: GoogleFonts.baloo2(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.only(left: 36.w),
          child: Text(
            ingredient.history!,
            style: GoogleFonts.baloo2(
              fontSize: 16.sp,
              color: AppColors.grey400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionSection() {
    if (ingredient.nutrients == null || ingredient.nutrients!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              "assets/images/cooked_rice.svg",
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(width: 12.w),
            Text(
              'Nutrition:',
              style: GoogleFonts.baloo2(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.only(left: 36.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.w,
              mainAxisExtent: 65.h,
            ),
            itemCount: ingredient.nutrients!.length,
            itemBuilder: (context, index) {
              final nutrient = ingredient.nutrients![index];
              return _buildNutrientCard(nutrient, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientCard(Nutrient nutrient, int index) {
    final colors = [Colors.purple, Colors.green, Colors.orange, Colors.red];

    final color = nutrient.color ?? colors[index % colors.length];

    return Container(
      padding: EdgeInsets.only(left: 12.w, top: 6.h, bottom: 6.h, right: 12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              nutrient.name,
              style: GoogleFonts.baloo2(
                fontSize: 14.sp,
                color: AppColors.secondary.withValues(alpha: 0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              nutrient.value,
              style: GoogleFonts.baloo2(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunFactsSection() {
    if (ingredient.funFacts == null || ingredient.funFacts!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              "assets/images/sparkles.svg",
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(width: 12.w),
            Text(
              'Fun facts:',
              style: GoogleFonts.baloo2(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.only(left: 36.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredient.funFacts!.map((fact) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      margin: EdgeInsets.only(top: 8.h, right: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        fact,
                        style: GoogleFonts.baloo2(
                          fontSize: 16.sp,
                          color: AppColors.secondary.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Show ingredient detail popup
void showIngredientDetailPopup(IngredientDetail ingredient) {
  Get.dialog(
    IngredientDetailPopup(ingredient: ingredient),
    barrierDismissible: true,
    barrierColor: Colors.black54,
  );
}
