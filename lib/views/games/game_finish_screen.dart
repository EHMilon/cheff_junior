import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import 'empty_game_screen.dart';

class GameFinishView extends StatelessWidget {
  const GameFinishView({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyGameScreen(
      title: "",
      buttonText: 'back_to_games'.tr,
      onButtonPressed: () {
        // Navigate back to games screen
        Get.offAllNamed(AppRoutes.GAMES);
      },
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/congratulate.png", height: 400.h, width: 400.h,),
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
