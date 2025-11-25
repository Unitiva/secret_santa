import 'package:get/get.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.SPLASH, page: () => SplashPage()),

    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 1500),
    ),
  ];
}
