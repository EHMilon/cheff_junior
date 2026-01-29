import 'package:get/get.dart';
import '../../views/auth/sign_in_view.dart';
import '../../views/auth/sign_up_view.dart';
import '../../views/auth/forgot_password_view.dart';
import '../../views/auth/otp_view.dart';
import '../../views/auth/create_password_view.dart';
import '../../views/auth/congratulations_view.dart';
import '../../views/home/all_recipe_view.dart';
import '../../views/home/home_view.dart';
import '../../views/favorite/favorite_view.dart';
import '../../views/search/search_view.dart';
import '../bindings/home_binding.dart';
import '../bindings/favorite_binding.dart';
import '../bindings/search_binding.dart';
import '../bindings/all_recipe_binding.dart';
import '../../views/profile/profile_view.dart';
import '../../views/profile/account_settings_view.dart';
import '../../views/profile/language_view.dart';
import '../bindings/profile_binding.dart';
import '../../views/avatar/avatar_chat_view.dart';
import '../bindings/avatar_chat_binding.dart';

class AppPages {
  // static const INITIAL = AppRoutes.SIGN_IN;
  static const INITIAL = AppRoutes.HOME;

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
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.FAVORITE,
      page: () => const FavoriteView(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: AppRoutes.ALL_RECIPE,
      page: () => const AllRecipeView(),
      binding: AllRecipeBinding(),
    ),
    GetPage(
      name: AppRoutes.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.ACCOUNT_SETTINGS,
      page: () => const AccountSettingsView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.LANGUAGE,
      page: () => const LanguageView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.AVATAR_CHAT,
      page: () => const AvatarChatView(),
      binding: AvatarChatBinding(),
    ),
  ];
}

class AppRoutes {
  static const String SIGN_IN = '/sign-in';
  static const String SIGN_UP = '/sign-up';
  static const String FORGOT_PASSWORD = '/forgot-password';
  static const String OTP = '/otp';
  static const String CREATE_PASSWORD = '/create-password';
  static const String CONGRATULATIONS = '/congratulations';
  static const String HOME = '/home';
  static const String FAVORITE = '/favorite';
  static const String SEARCH = '/search';
  static const String ALL_RECIPE = '/all-recipe';
  static const String PROFILE = '/profile';
  static const String ACCOUNT_SETTINGS = '/account-settings';
  static const String LANGUAGE = '/language';
  static const String AVATAR_CHAT = '/avatar-chat';
}
