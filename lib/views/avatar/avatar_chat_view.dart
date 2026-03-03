import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'avatar_chat_controller.dart';
import '../../core/themes/app_colors.dart';

class AvatarChatView extends GetView<AvatarChatController> {
  const AvatarChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : const Color(0xFFFFE0B2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : AppColors.secondary,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        // actions: [
        //   Obx(
        //     () => Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 16.w),
        //       child: Center(
        //         child: Container(
        //           padding: EdgeInsets.symmetric(
        //             horizontal: 12.w,
        //             vertical: 4.h,
        //           ),
        //           decoration: BoxDecoration(
        //             color: controller.isOnline.value
        //                 ? AppColors.success.withOpacity(0.1)
        //                 : AppColors.error.withOpacity(0.1),
        //             borderRadius: BorderRadius.circular(20.r),
        //           ),
        //           child: Row(
        //             children: [
        //               Container(
        //                 width: 8.w,
        //                 height: 8.w,
        //                 decoration: BoxDecoration(
        //                   color: controller.isOnline.value
        //                       ? AppColors.success
        //                       : AppColors.error,
        //                   shape: BoxShape.circle,
        //                 ),
        //               ),
        //               SizedBox(width: 8.w),
        //               Text(
        //                 controller.isOnline.value ? 'online'.tr : 'offline'.tr,
        //                 style: TextStyle(
        //                   color: controller.isOnline.value
        //                       ? AppColors.success
        //                       : AppColors.error,
        //                   fontSize: 12.sp,
        //                   fontWeight: FontWeight.w600,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Obx(
        () => Skeletonizer(
          enabled: controller.isLoading.value,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.showInitialState.value &&
                      controller.messages.isEmpty) {
                    return _buildInitialState(context);
                  }
                  return _buildChatState(context);
                }),
              ),
              _buildMessageInput(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Container(),
          SizedBox(height: 20.h),
          Hero(
            tag: 'avatar_ai',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: const Color(0xFFC0E1FF),
                backgroundImage: const AssetImage('assets/images/dehreen.png'),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'hello_dehreen'.tr,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'im_dwane'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey),
          ),
          SizedBox(height: 200.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'recommended_topics'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: controller.recommendedTopics
                .map((topic) => _buildTopicCard(context, topic))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, String topic) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectTopic(topic),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                topic.contains('chicken')
                    ? 'assets/images/chicken_fry.svg'
                    : 'assets/images/french_fry.svg',
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(height: 12.h),
              Text(
                topic,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : AppColors.secondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatState(BuildContext context) {
    return ListView.builder(
      controller: controller.scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount:
          controller.messages.length + (controller.isTyping.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.messages.length) {
          return _buildTypingIndicator(context);
        }
        final message = controller.messages[index];
        return _buildMessageBubble(context, message);
      },
    );
  }

  Widget _buildMessageBubble(BuildContext context, MessageModel message) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Row(
          mainAxisAlignment: message.isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) ...[
              CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFFC0E1FF),
                backgroundImage: const AssetImage('assets/images/dehreen.png'),
              ),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? (isDark ? AppColors.primary : Colors.white)
                      : (isDark ? Colors.grey[850] : const Color(0xFFF1F1F1)),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(message.isUser ? 20.r : 0),
                    bottomRight: Radius.circular(message.isUser ? 0 : 20.r),
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: message.isUser && isDark
                        ? const Color(0xFF505050)
                        : theme.colorScheme.secondary,

                    fontFamily: 'Baloo 2',
                    fontWeight: FontWeight.w400,
                    height: 1.50.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: const Color(0xFFC0E1FF),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: const Text("Typing some cool response..."),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'type_message'.tr,
                          border: InputBorder.none,
                          fillColor: Colors.transparent,
                          hintStyle: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14.sp,
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        // Multiline support with max 3 lines
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 3,
                        onSubmitted: (_) => controller.sendMessage(),
                      ),
                    ),
                    Obx(() => IconButton(
                      icon: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.all(controller.isListening.value ? 8.w : 0),
                        decoration: BoxDecoration(
                          color: controller.isListening.value
                              ? AppColors.error.withOpacity(0.1)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          "assets/images/mic.svg",
                          width: 20.w,
                          height: 20.w,
                          colorFilter: controller.isListening.value
                              ? const ColorFilter.mode(
                                  AppColors.error,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                      onPressed: controller.toggleSpeechToText,
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: controller.sendMessage,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/images/send.svg",
                  width: 30.w,
                  height: 30.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
