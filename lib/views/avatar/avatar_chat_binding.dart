import 'package:get/get.dart';
import 'avatar_chat_controller.dart';

class AvatarChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvatarChatController>(() => AvatarChatController());
  }
}
