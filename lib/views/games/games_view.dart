import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/themes/app_colors.dart';
import '../../shared/widgets/main_scaffold.dart';
import 'games_controller.dart';

class GamesView extends GetView<GamesController> {
  const GamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1, // Games is index 1
      body: SafeArea(
        child: Obx(() {
          if (!controller.isOnline.value) {
            return _buildNoInternetView();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 20.h),
                // _buildHeader(),
                SizedBox(height: 30.h),
                Text(
                  'explore_all_games'.tr,
                  style: GoogleFonts.baloo2(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildGamesGrid(),
                SizedBox(height: 80.h), // Space for bottom nav
              ],
            ),
          );
        }),
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Row(
  //     children: [
  //       Text(
  //         'games'.tr,
  //         style: GoogleFonts.baloo2(
  //           fontSize: 22.sp,
  //           fontWeight: FontWeight.bold,
  //           color: AppColors.textBody,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildGamesGrid() {
    return Obx(() {
      final List<GameModel> displayGames = controller.isLoading.value
          ? [
              GameModel(
                id: 'loading_1',
                title: 'Loading Game Name',
                image: 'assets/images/1st_game_image.png',
                progress: 0.5,
              ),
              GameModel(
                id: 'loading_2',
                title: 'Loading Game Name',
                image: 'assets/images/2nd_game_image.png',
                progress: 0.5,
              ),
            ]
          : controller.games;

      return Skeletonizer(
        enabled: controller.isLoading.value,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.w,
            childAspectRatio: 0.8,
          ),
          itemCount: displayGames.length,
          itemBuilder: (context, index) {
            final game = displayGames[index];
            return _buildGameCard(game);
          },
        ),
      );
    });
  }

  Widget _buildGameCard(GameModel game) {
    return InkWell(
      onTap: () => controller.onGameTap(game),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.asset(
                  game.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              game.title,
              style: GoogleFonts.baloo2(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBody,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            _buildProgressBar(game.progress),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 6.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF9181F2), // Purple progress bar from image
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
      ),
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64.sp, color: AppColors.grey),
          SizedBox(height: 16.h),
          Text(
            'no_internet'.tr,
            style: GoogleFonts.baloo2(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBody,
            ),
          ),
          SizedBox(height: 8.h),
          ElevatedButton(
            onPressed: () => controller.loadGames(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
