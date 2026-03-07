import 'package:chef_junior/core/controllers/connectivity_controller.dart';
import 'package:chef_junior/data/models/user_model.dart';
import 'package:chef_junior/data/services/auth_service.dart';
import 'package:chef_junior/shared/utils/ui_utils.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isUpdatingAvatar = false.obs;

  // Edit mode states
  final RxBool isEditingName = false.obs;
  final RxBool isEditingPassword = false.obs;

  // Form values
  final RxString nameInput = "".obs;
  final RxString currentPassword = "".obs;
  final RxString newPassword = "".obs;
  final RxString confirmPassword = "".obs;

  // Password visibility states
  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  final ConnectivityController _connectivityController =
      Get.find<ConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// Fetch user profile from API
  Future<void> fetchUserProfile() async {
    if (!_connectivityController.isOnline.value) {
      UiUtils.showNoInternet();
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authService.apiClient.getCurrentUser();

      if (result.isSuccess && result.data != null) {
        user.value = result.data;
        nameInput.value = user.value?.name ?? "";
        // Also update auth service's current user
        _authService.updateCurrentUser(result.data!);
      } else {
        UiUtils.showSnackBar(
          title: "Error",
          message: result.error ?? "Failed to load profile",
          isError: true,
        );
      }
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEditName() {
    isEditingName.value = !isEditingName.value;
    if (isEditingName.value) {
      nameInput.value = user.value?.name ?? "";
    }
  }

  void toggleEditPassword() {
    isEditingPassword.value = !isEditingPassword.value;
    if (!isEditingPassword.value) {
      currentPassword.value = "";
      newPassword.value = "";
      confirmPassword.value = "";
    }
  }

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Update user name using PATCH method
  Future<void> updateName() async {
    if (!_connectivityController.isOnline.value) {
      UiUtils.showNoInternet();
      return;
    }

    if (nameInput.value.trim().isEmpty) {
      UiUtils.showSnackBar(
        title: "Error",
        message: "Name cannot be empty",
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    try {
      final result = await _authService.apiClient.updateProfile(
        fullName: nameInput.value.trim(),
      );

      if (result.isSuccess && result.data != null) {
        user.value = result.data;
        _authService.updateCurrentUser(result.data!);
        isEditingName.value = false;
        UiUtils.showSnackBar(
          title: "Success",
          message: "Name updated successfully",
          isError: false,
        );
      } else {
        UiUtils.showSnackBar(
          title: "Error",
          message: result.error ?? "Failed to update name",
          isError: true,
        );
      }
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  /// Change user password using POST method
  Future<void> updatePassword() async {
    if (!_connectivityController.isOnline.value) {
      UiUtils.showNoInternet();
      return;
    }

    // Basic validation
    if (currentPassword.value.isEmpty) {
      UiUtils.showSnackBar(
        title: "Error",
        message: "Current password is required",
        isError: true,
      );
      return;
    }

    if (newPassword.value.length < 6) {
      UiUtils.showSnackBar(
        title: "Error",
        message: "New password must be at least 6 characters",
        isError: true,
      );
      return;
    }

    if (newPassword.value != confirmPassword.value) {
      UiUtils.showSnackBar(
        title: "Error",
        message: "Passwords do not match",
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    try {
      final result = await _authService.apiClient.changePassword(
        currentPassword: currentPassword.value,
        newPassword: newPassword.value,
      );

      if (result.isSuccess) {
        // Reset fields
        currentPassword.value = "";
        newPassword.value = "";
        confirmPassword.value = "";

        isEditingPassword.value = false;
        UiUtils.showSnackBar(
          title: "Success",
          message: result.data ?? "Password updated successfully",
          isError: false,
        );
      } else {
        UiUtils.showSnackBar(
          title: "Error",
          message: result.error ?? "Failed to update password",
          isError: true,
        );
      }
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  /// Upload avatar image using POST method
  /// Call this method with a file path from the file picker
  Future<void> uploadAvatar(String filePath) async {
    if (!_connectivityController.isOnline.value) {
      UiUtils.showNoInternet();
      return;
    }

    isUpdatingAvatar.value = true;

    try {
      final result = await _authService.apiClient.uploadAvatar(filePath);

      if (result.isSuccess && result.data != null) {
        user.value = result.data;
        _authService.updateCurrentUser(result.data!);
        UiUtils.showSnackBar(
          title: "Success",
          message: "Avatar updated successfully",
          isError: false,
        );
      } else {
        UiUtils.showSnackBar(
          title: "Error",
          message: result.error ?? "Failed to upload avatar",
          isError: true,
        );
      }
    } catch (e) {
      UiUtils.showSnackBar(
        title: "Error",
        message: "Failed to upload avatar: ${e.toString()}",
        isError: true,
      );
    } finally {
      isUpdatingAvatar.value = false;
    }
  }

  void logout() {
    // Clear auth data and navigate to sign in
    final authService = Get.find<AuthService>();
    authService.logout().then((_) {
      Get.offAllNamed('/sign-in');
    });
  }
}
