import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'core/bindings/auth_binding.dart';
import 'core/intl/app_strings.dart';
import 'core/routes/app_routes.dart';
import 'core/themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const ChefJuniorApp());
}

class ChefJuniorApp extends StatelessWidget {
  const ChefJuniorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // standard iPhone size for design
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Chef Junior',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light, // TODO: Implement theme switching logic
          translations: AppTranslations(),
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          initialBinding: AuthBinding(),
        );
      },
    );
  }
}
