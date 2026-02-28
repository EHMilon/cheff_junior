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
          Positioned.fill(
            child: Image.asset(
              AppImages.bg,
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                GameHeaderWidget(
                  title: 'empty_game_title'.tr,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Image.asset(
                          "assets/images/game4.png",
                          height: 260.h,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find the Words:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: const Color(0xFF242424),
                                fontSize: 18,
                                fontFamily: 'Baloo 2',
                                fontWeight: FontWeight.w500,
                                height: 1.20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFF927AFF),
                                    shape: OvalBorder(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Pasta',
                                  style: TextStyle(
                                    color: const Color(0xFF505050),
                                    fontSize: 16,
                                    fontFamily: 'Baloo 2',
                                    fontWeight: FontWeight.w400,
                                    height: 1.20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFF927AFF),
                                    shape: OvalBorder(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Olive',
                                  style: TextStyle(
                                    color: const Color(0xFF505050),
                                    fontSize: 16,
                                    fontFamily: 'Baloo 2',
                                    fontWeight: FontWeight.w400,
                                    height: 1.20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFF927AFF),
                                    shape: OvalBorder(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Onion',
                                  style: TextStyle(
                                    color: const Color(0xFF505050),
                                    fontSize: 16,
                                    fontFamily: 'Baloo 2',
                                    fontWeight: FontWeight.w400,
                                    height: 1.20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Counter Circle Button at the bottom
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
                  child: Obx(() =>
                    InkWell(
                      onTap: () {
                        controller.incrementCounter();
                      },
                      child: Container(
                        width: 102.w,
                        height: 102.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8F0F),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
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
        ],
      ),
    );
  }
}
