import 'dart:async';
import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class MessageModel {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  MessageModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AvatarChatController extends GetxController {
  final Logger _logger = Logger();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  var isOnline = true.obs;
  var isLoading = true.obs;
  var messages = <MessageModel>[].obs;
  var isTyping = false.obs;
  var showInitialState = true.obs;
  String? _pendingMessage;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<String> recommendedTopics = [
    "How to cook chicken fry?",
    "Can you give me the recipe of french fries?",
  ];

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;
    // Simulate initial loading (1s as per rules)
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _checkInitialConnectivity() async {
    final List<ConnectivityResult> results = await _connectivity
        .checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool previouslyOffline = !isOnline.value;
    isOnline.value =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
    _logger.i("Connectivity status updated: ${isOnline.value}");

    if (isOnline.value && previouslyOffline && _pendingMessage != null) {
      _logger.i("Back online, sending pending message");
      _sendToAI(_pendingMessage!);
      _pendingMessage = null;
    }
  }

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    if (!isOnline.value) {
      _pendingMessage = text;
      Get.snackbar(
        "offline".tr,
        "offline_msg".tr,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _sendToAI(text);
  }

  void _sendToAI(String text) async {
    // Clear and hide initial state
    messageController.clear();
    showInitialState.value = false;

    // Add user message if it's not already in the list
    if (messages.isEmpty ||
        messages.last.text != text ||
        !messages.last.isUser) {
      messages.add(
        MessageModel(text: text, isUser: true, timestamp: DateTime.now()),
      );
    }

    _scrollToBottom();

    // Mock AI Response
    isTyping.value = true;
    _logger.i("AI is typing...");

    try {
      // Simulate network delay (1s as requested)
      await Future.delayed(const Duration(seconds: 1));

      // Mock AI response text
      final aiResponse =
          "I'm Dwane, your Chef Junior assistant. That's a great question about $text! Let me help you with some cooking tips.";

      messages.add(
        MessageModel(
          text: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      _logger.e("Error getting AI response: $e");
      Get.snackbar(
        "error".tr,
        "server_error".tr,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isTyping.value = false;
      _scrollToBottom();
    }
  }

  void selectTopic(String topic) {
    messageController.text = topic;
    sendMessage();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
