import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/dependency_injection/injection.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/utils/app_size_util.dart';
import 'core/utils/const.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: true,
    ),
  );

  await EasyLocalization.ensureInitialized();
  
  debugInvertOversizedImages = false;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('it'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('it'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      builder: (context, child) {
        AppSizeUtil.init(context);
        return Theme(data: getAppTheme(), child: child ?? SizedBox.shrink());
      },
    );
  }
}
