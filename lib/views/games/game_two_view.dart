import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import 'empty_game_screen.dart';

class EmptyGameTwoView extends StatelessWidget {
  const EmptyGameTwoView({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyGameScreen(
      title: 'empty_game_title'.tr,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Container(child: SvgPicture.asset("assets/images/game2.svg")),
          ),
        ),
      ),
      onButtonPressed: () {
        // Using postFrameCallback to ensure the navigation happens safely
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.toNamed(AppRoutes.EMPTY_GAME_THREE);
        });
      },
    );
  }
}
