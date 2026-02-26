import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../shared/utils/ui_utils.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnection() async {
    final List<ConnectivityResult> result = await _connectivity
        .checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      if (isOnline.value) {
        isOnline.value = false;
        UiUtils.showNoInternet();
      }
    } else {
      if (!isOnline.value) {
        isOnline.value = true;
        UiUtils.showSnackBar(
          title: 'Connected',
          message: 'Your internet connection has been restored',
          isError: false,
        );
      }
    }
  }
}
