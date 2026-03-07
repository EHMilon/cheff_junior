import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../routes/app_routes.dart';
import '../controllers/connectivity_controller.dart';
<<<<<<< HEAD
import '../services/auth_service.dart';
import '../../data/models/user_model.dart';
=======
>>>>>>> office/main
import '../../shared/utils/ui_utils.dart';

class AuthController extends GetxController {
  final _logger = Logger();
  final _connectivity = Get.find<ConnectivityController>();
<<<<<<< HEAD
  final _authService = Get.find<AuthService>();
=======
>>>>>>> office/main

  // Form Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final otpController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form Keys
  final signInFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final createPasswordFormKey = GlobalKey<FormState>();

  // Observables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var agreeToTerms = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();
  void toggleTerms() => agreeToTerms.toggle();

  bool _checkConnectivity() {
    if (!_connectivity.isOnline.value) {
      UiUtils.showNoInternet();
      return false;
    }
    return true;
  }

  Future<void> signIn() async {
<<<<<<< HEAD
=======
    if (!signInFormKey.currentState!.validate()) return;
>>>>>>> office/main
    if (!_checkConnectivity()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      _logger.i("Signing in: ${emailController.text}");
<<<<<<< HEAD

      // Save auth data and navigate to home
      final user = UserModel(
        id: '1', // In real app, this comes from backend
        email: emailController.text,
        name: 'User', // In real app, this comes from backend
        profilePhoto: '', // In real app, this comes from backend
        joinedDate: DateTime.now().toIso8601String(),
        gamesPlayed: 0,
        recipesCompleted: 0,
      );

      await _authService.saveAuthData(
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        user: user,
      );

      Get.offAllNamed(AppRoutes.HOME);
=======
      // Get.offAllNamed(AppRoutes.HOME);
>>>>>>> office/main
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;
    if (!agreeToTerms.value) {
      UiUtils.showSnackBar(
        title: 'Error',
        message: 'Please agree to the terms and conditions',
      );
      return;
    }
    if (!_checkConnectivity()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      _logger.i("Signing up: ${nameController.text}");
<<<<<<< HEAD
      Get.toNamed(AppRoutes.SIGN_IN);
=======
      Get.offAllNamed(AppRoutes.SIGN_IN);
>>>>>>> office/main
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;
    if (!_checkConnectivity()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Get.toNamed(AppRoutes.OTP);
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length < 4) return;
    if (!_checkConnectivity()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Get.toNamed(AppRoutes.CREATE_PASSWORD);
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!_checkConnectivity()) return;
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      UiUtils.showSnackBar(
        title: 'Success',
        message: 'OTP resent successfully',
        isError: false,
      );
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNewPassword() async {
    if (!createPasswordFormKey.currentState!.validate()) return;
    if (!_checkConnectivity()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Get.toNamed(AppRoutes.CONGRATULATIONS);
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }
<<<<<<< HEAD

  /// Check if user is already logged in
  /// Returns true if user has valid auth token
  bool checkAuthStatus() {
    return _authService.checkAuthStatus();
  }

  /// Logout user and clear auth data
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authService.clearAuthData();
      Get.offAllNamed(AppRoutes.SIGN_IN);
    } catch (e) {
      _logger.e("Error during logout: $e");
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }
=======
>>>>>>> office/main
}
