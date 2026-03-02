import 'package:chef_junior/core/controllers/connectivity_controller.dart';
import 'package:chef_junior/data/models/user_model.dart';
import 'package:chef_junior/data/services/auth_service.dart';
import 'package:chef_junior/shared/utils/ui_utils.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;

  // Edit mode states
  final RxBool isEditingName = false.obs;
  final RxBool isEditingPassword = false.obs;

  // Form values
  final RxString nameInput = "".obs;
  final RxString currentPassword = "".obs;
  final RxString newPassword = "".obs;
  final RxString confirmPassword = "".obs;

  final ConnectivityController _connectivityController =
      Get.find<ConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (!_connectivityController.isOnline.value) {
      UiUtils.showNoInternet();
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    try {
      // Simulate network delay as requested
      await Future.delayed(const Duration(seconds: 1));

      // Mock data based on the image provided
      user.value = UserModel(
        id: "1",
        name: "Jhon Doe Smith",
        email: "doe.name@gmail.com",
        profilePhoto: "https://i.pravatar.cc/150?u=1",
        joinedDate: "2023",
        gamesPlayed: 2,
        recipesCompleted: 10,
      );

      nameInput.value = user.value?.name ?? "";
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

  Future<void> updateName() async {
    if (!_connectivityController.isOnline.value) {
      UiUtils.showNoInternet();
      return;
    }

    // TODO: Implement backend integration
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (user.value != null) {
        user.value = user.value!.copyWith(name: nameInput.value);
      }

      isEditingName.value = false;
      UiUtils.showSnackBar(
        title: "Success",
        message: "Name updated successfully",
        isError: false,
      );
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword() async {
    if (!_connectivityController.isOnline.value) {
      UiUtils.showNoInternet();
      return;
    }

    // Basic validation
    if (newPassword.value != confirmPassword.value) {
      UiUtils.showSnackBar(
        title: "Error",
        message: "Passwords do not match",
        isError: true,
      );
      return;
    }

    // TODO: Implement backend integration
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));

      // reset fields
      currentPassword.value = "";
      newPassword.value = "";
      confirmPassword.value = "";

      isEditingPassword.value = false;
      UiUtils.showSnackBar(
        title: "Success",
        message: "Password updated successfully",
        isError: false,
      );
    } catch (e) {
      UiUtils.showServerError();
    } finally {
      isLoading.value = false;
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
