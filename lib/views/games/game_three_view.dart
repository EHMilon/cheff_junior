import 'package:chef_junior/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'empty_game_screen.dart';

class EmptyGameThreeView extends StatelessWidget {
  const EmptyGameThreeView({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyGameScreen(
      title: 'empty_game_title'.tr,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Container(child: SvgPicture.asset("assets/images/game3.svg"),),
          ),
        ),
      ),
      onButtonPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.toNamed(AppRoutes.GAME_FINISH);
        });
      },
    );
  }
}
