import 'package:get/get.dart';
import '../../views/auth/sign_in_view.dart';
import '../../views/auth/sign_up_view.dart';
import '../../views/auth/forgot_password_view.dart';
import '../../views/auth/otp_view.dart';
import '../../views/auth/create_password_view.dart';
import '../../views/auth/congratulations_view.dart';
import '../routes/app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SIGN_IN;

  static final routes = [
    GetPage(name: AppRoutes.SIGN_IN, page: () => const SignInView()),
    GetPage(name: AppRoutes.SIGN_UP, page: () => const SignUpView()),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(name: AppRoutes.OTP, page: () => const OtpView()),
    GetPage(
      name: AppRoutes.CREATE_PASSWORD,
      page: () => const CreatePasswordView(),
    ),
    GetPage(
      name: AppRoutes.CONGRATULATIONS,
      page: () => const CongratulationsView(),
    ),
  ];
}
