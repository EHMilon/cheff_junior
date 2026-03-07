import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../games/controllers/game_four_controller.dart';
import '../../shared/widgets/game_header_widget.dart';
import '../../shared/utils/app_images.dart';

class GameFourView extends StatelessWidget {
  const GameFourView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GameFourController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(child: Image.asset(AppImages.bg, fit: BoxFit.fill)),
          SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                const GameHeaderWidget(
                  title: 'Name the Image:', // Empty as the title is inside the content
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Obx(
                            () => Center(
                              child: Text(
                                'Find: ${controller.currentWordTarget}',
                                style: TextStyle(
                                  color: const Color(0xFF927AFF),
                                  fontSize: 18.sp,
                                  fontFamily: 'Baloo 2',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          // Currently selected letters display
                          Center(
                            child: Obx(
                              () => Container(
                                height: 40.h,
                                child: Text(
                                  controller.currentSelectedLetters,
                                  style: TextStyle(
                                    color: controller.isError.value
                                        ? Colors.red
                                        : const Color(0xFFFF8F0F),
                                    fontSize: 28.sp,
                                    fontFamily: 'Baloo 2',
                                    fontWeight: FontWeight.bold,
                                    decoration: controller.isError.value
                                        ? TextDecoration.underline
                                        : null,
                                    decorationStyle: TextDecorationStyle.wavy,
                                    decorationColor: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // The Grid
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFFF8F0F),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: controller.gridLetters.length,
                              itemBuilder: (context, index) {
                                return Obx(() {
                                  // In duplicate selection mode, we highlight if the index is in the list
                                  final isSelected = controller.selectedIndices
                                      .contains(index);
                                  return GestureDetector(
                                    onTap: () => controller.toggleLetter(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFFFF8F0F)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: const Color(0xFFFF8F0F),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          controller.gridLetters[index],
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF242424),
                                            fontSize: 18.sp,
                                            fontFamily: 'Baloo 2',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),

                          SizedBox(height: 30.h),

                          Text(
                            'Find the Words:',
                            style: TextStyle(
                              color: const Color(0xFF242424),
                              fontSize: 18.sp,
                              fontFamily: 'Baloo 2',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Dynamic Word List
                          Obx(
                            () => Column(
                              children: controller.wordsToFind.map((word) {
                                final isFound = controller.isWordFound(word);
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: ShapeDecoration(
                                          color: isFound
                                              ? Colors.green
                                              : const Color(0xFF927AFF),
                                          shape: const OvalBorder(),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        word,
                                        style: TextStyle(
                                          color: isFound
                                              ? Colors.green
                                              : const Color(0xFF505050),
                                          fontSize: 16.sp,
                                          fontFamily: 'Baloo 2',
                                          fontWeight: isFound
                                              ? FontWeight.bold
                                              : FontWeight.w400,
                                          decoration: isFound
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      if (isFound) ...[
                                        SizedBox(width: 8.w),
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Button
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Obx(
                    () => InkWell(
                      onTap: () {
                        if (controller.selectedIndices.isNotEmpty) {
                          controller.checkWord();
                        }
                      },
                      child: Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8F0F),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            controller.counterDisplay,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Baloo 2',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Background decoration as seen in image (veggies)
          Positioned(
            right: -20,
            bottom: 120,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                "assets/images/onion_bg.png", // Assuming this exists or similar decoration
                width: 150.w,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
