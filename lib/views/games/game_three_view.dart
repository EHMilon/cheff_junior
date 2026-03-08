import 'package:chef_junior/data/models/crossword_models.dart';
import 'package:chef_junior/shared/utils/app_images.dart';
import 'package:chef_junior/views/games/widgets/game_header_widget.dart';
import 'package:chef_junior/views/games/controllers/game_three_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EmptyGameThreeView extends GetView<GameThreeController> {
  const EmptyGameThreeView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<GameThreeController>()) {
      Get.put(GameThreeController());
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset:
          true, // Allow scaffold to resize when keyboard shows
      body: Stack(
        children: [
          // Background
          Positioned.fill(child: Image.asset(AppImages.bg, fit: BoxFit.fill)),

          SafeArea(
            child: Column(
              children: [
                GameHeaderWidget(title: "name_the_image".tr),
                Expanded(
                  child: SingleChildScrollView(
                    // Make content scrollable when keyboard appears
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      height: 0.7.sh,
                      child: InteractiveViewer(
                        boundaryMargin: const EdgeInsets.all(20.0),
                        minScale: 0.1,
                        maxScale: 2.0,
                        child: Center(
                          child: SizedBox(
                            width: 1.sw,
                            height: 0.7.sh,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Clue Images
                                _buildClueImages(),

                                // Grid Cells
                                ...controller.grid.values.map(
                                  (cell) => _buildCell(cell),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Done Button - Hidden when keyboard is visible
                Obx(() {
                  // Hide button when keyboard is visible
                  if (controller.isKeyboardVisible.value) {
                    return const SizedBox.shrink();
                  }
                  final bool isComplete = controller.isGameComplete.value;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: ElevatedButton(
                      onPressed: controller.onDoneTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isComplete
                            ? const Color(0xFFFF8F0F)
                            : const Color(0xFFC4C4C4),
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "done".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Baloo 2',
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(CrosswordCell cell) {
    final double cellSize = 45.w;
    final double gridOriginX = 0.5.sw - (3.0 * cellSize);
    final double gridOriginY = 0.15.sh;

    return Positioned(
      left: gridOriginX + (cell.col * cellSize),
      top: gridOriginY + (cell.row * cellSize),
      child: Container(
        width: cellSize,
        height: cellSize,
        decoration: BoxDecoration(
          border: Border.all(color: cell.borderColor, width: 2.0),
          color: Colors.white.withOpacity(0.8),
        ),
        child: Center(
          child: cell.isPrefilled
              ? Text(
                  cell.correctLetter,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Baloo 2',
                  ),
                )
              : TextField(
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  onChanged: (value) => controller.onLetterInput(
                    cell.row,
                    cell.col,
                    value.toUpperCase(),
                  ),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Baloo 2',
                  ),
                  decoration: const InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildClueImages() {
    final double cellSize = 45.w;
    final double gridOriginX = 0.5.sw - (3.0 * cellSize);
    final double gridOriginY = 0.15.sh;

    return Stack(
      children: [
        // Garlic (Above R0, C0)
        Positioned(
          left: gridOriginX + (0 * cellSize) - 5,
          top: gridOriginY + (-1 * cellSize) - 10,
          child: Image.asset("assets/images/fruites/garlic.png", width: 50.w),
        ),
        // Cheese (Right of R5, C5)
        Positioned(
          left: gridOriginX + (6 * cellSize) + 5,
          top: gridOriginY + (5 * cellSize) - 5,
          child: Image.asset("assets/images/fruites/cheese.png", width: 50.w),
        ),
        // Egg (Below R7, C2)
        Positioned(
          left: gridOriginX + (2 * cellSize) - 5,
          top: gridOriginY + (8 * cellSize) + 0,
          child: Image.asset("assets/images/fruites/egg.png", width: 45.w),
        ),
      ],
    );
  }
}
