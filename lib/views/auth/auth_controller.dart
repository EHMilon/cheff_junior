import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../core/routes/app_routes.dart';
import '../../core/controllers/connectivity_controller.dart';
import '../../data/services/auth_service.dart';
import '../../shared/utils/ui_utils.dart';

class AuthController extends GetxController {
  final _logger = Logger();
  final _connectivity = Get.find<ConnectivityController>();
  final _authService = Get.find<AuthService>();

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

  /// Clear all auth controllers to prevent auto-fill of previous values
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    otpController.clear();
    confirmPasswordController.clear();
  }

  /// Clear only OTP controller
  void clearOtpController() {
    otpController.clear();
  }

  /// Clear password controllers
  void clearPasswordControllers() {
    passwordController.clear();
    confirmPasswordController.clear();
  }

  bool _checkConnectivity() {
    if (!_connectivity.isOnline.value) {
      UiUtils.showNoInternet();
      return false;
    }
    return true;
  }

  /// Sign in with email and password
  Future<void> signIn() async {
    if (!_checkConnectivity()) return;

    try {
      isLoading.value = true;
      _logger.i("Signing in: ${emailController.text}");

      final result = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result.isSuccess) {
        _logger.i("Login successful");
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        UiUtils.showSnackBar(
          title: 'Login Failed',
          message: result.error ?? 'Please check your credentials',
        );
      }
    } catch (e) {
      _logger.e("Login error: $e");
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign up a new user
  Future<void> signUp() async {
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
      _logger.i("Signing up: ${nameController.text}");

      final result = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        fullName: nameController.text.trim(),
      );

      if (result.isSuccess) {
        _logger.i("Signup successful");
        UiUtils.showSnackBar(
          title: 'Success',
          message: 'Account created successfully! Please login.',
          isError: false,
        );
        Get.offAllNamed(AppRoutes.SIGN_IN);
      } else {
        UiUtils.showSnackBar(
          title: 'Signup Failed',
          message: result.error ?? 'Please try again',
        );
      }
    } catch (e) {
      _logger.e("Signup error: $e");
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  /// Request password reset OTP
  Future<void> resetPassword() async {
    if (!_checkConnectivity()) return;

    try {
      isLoading.value = true;
      _logger.i("Requesting password reset for: ${emailController.text}");

      final result = await _authService.forgotPassword(
        email: emailController.text.trim(),
      );

      if (result.isSuccess) {
        _logger.i("OTP sent successfully");
        clearOtpController(); // Clear previous OTP before navigating
        Get.toNamed(AppRoutes.OTP);
      } else {
        UiUtils.showSnackBar(
          title: 'Failed',
          message: result.error ?? 'Please try again',
        );
      }
    } catch (e) {
      _logger.e("Forgot password error: $e");
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP entered by user
  Future<void> verifyOtp() async {
    if (otpController.text.length < 4) {
      UiUtils.showSnackBar(
        title: 'Invalid OTP',
        message: 'Please enter a valid OTP',
      );
      return;
    }
    if (!_checkConnectivity()) return;

    try {
      isLoading.value = true;
      _logger.i("Verifying OTP for: ${emailController.text}");

      final result = await _authService.verifyOtp(
        email: emailController.text.trim(),
        otp: otpController.text.trim(),
      );

      if (result.isSuccess) {
        _logger.i("OTP verified successfully");
        clearPasswordControllers(); // Clear previous passwords before navigating
        Get.toNamed(AppRoutes.CREATE_PASSWORD);
      } else {
        UiUtils.showSnackBar(
          title: 'Verification Failed',
          message: result.error ?? 'Invalid OTP. Please try again.',
        );
      }
    } catch (e) {
      _logger.e("OTP verification error: $e");
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend OTP to user's email
  Future<void> resendOtp() async {
    if (!_checkConnectivity()) return;
    
    try {
      isLoading.value = true;
      _logger.i("Resending OTP to: ${emailController.text}");

      final result = await _authService.resendOtp(
        email: emailController.text.trim(),
      );

      if (result.isSuccess) {
        UiUtils.showSnackBar(
          title: 'Success',
          message: 'OTP resent successfully',
          isError: false,
        );
      } else {
        UiUtils.showSnackBar(
          title: 'Failed',
          message: result.error ?? 'Please try again',
        );
      }
    } catch (e) {
      _logger.e("Resend OTP error: $e");
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  /// Create new password after OTP verification
  Future<void> createNewPassword() async {
    // Validate password match
    if (passwordController.text != confirmPasswordController.text) {
      UiUtils.showSnackBar(
        title: 'Error',
        message: 'Passwords do not match',
      );
      return;
    }

    if (!_checkConnectivity()) return;

    try {
      isLoading.value = true;
      _logger.i("Creating new password for: ${emailController.text}");

      final result = await _authService.resetPassword(
        email: emailController.text.trim(),
        otp: otpController.text.trim(),
        newPassword: passwordController.text,
      );

      if (result.isSuccess) {
        _logger.i("Password reset successful");
        Get.offAllNamed(AppRoutes.CONGRATULATIONS);
      } else {
        UiUtils.showSnackBar(
          title: 'Failed',
          message: result.error ?? 'Please try again',
        );
      }
    } catch (e) {
      _logger.e("Create password error: $e");
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user is already logged in
  /// Returns true if user has valid auth token
  bool checkAuthStatus() {
    return _authService.checkAuthStatus();
  }

  /// Logout user and clear auth data
  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      // Call logout API
      await _authService.logout();
      
      // Clear all controllers to prevent auto-fill on next login/forgot password
      clearControllers();
      
      Get.offAllNamed(AppRoutes.SIGN_IN);
    } catch (e) {
      _logger.e("Error during logout: $e");
      // Still navigate to sign in even if API fails
      clearControllers();
      Get.offAllNamed(AppRoutes.SIGN_IN);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    otpController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
