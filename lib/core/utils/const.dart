import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import './size_extension.dart';

class AppColors {
  // Background / primary blue
  static const Color backgroundBlue = Color(0xFFfbfbfb); // --background-color

  // Varianti di blu
  static const Color darkBlue = Color(0xFFE6F3F5); // --light-blue
  static const Color cyan = Color(0xFF36B1BD); // --eyebrow-secondary-color

  static const MaterialColor green = MaterialColor(0xFF006400, <int, Color>{
    50: Color(0xFFE8F5E8),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(0xFF006400), // base - dark Christmas green
    600: Color(0xFF4CAF50),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  });

  static const MaterialColor red = MaterialColor(0xFFB22222, <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(0xFFB22222), // base - Santa's red
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  });

  static const MaterialColor primary = MaterialColor(0xFF5062CD, <int, Color>{
    50: Color(0xFFE8EAF6),
    100: Color(0xFFC5CAE9),
    200: Color(0xFF9FA8DA),
    300: Color(0xFF7986CB),
    400: Color(0xFF5C6BC0),
    500: Color(0xFF5062CD), // base
    600: Color(0xFF455A64),
    700: Color(0xFF3949AB),
    800: Color(0xFF303F9F),
    900: Color(0xFF283593),
  });

  static const Color lightText = Color(0xFF4260d1);
  static const Color darkText = Color(0xFF000000);
  static const Color darkTextWeb = Color(0xFF37474F);
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
}

TextTheme getAppTextTheme() {
  return TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      fontSize: 30.sp,
      height: 41.h / 30.sp,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      fontSize: 26.sp,
      height: 19.h / 26.sp,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      fontSize: 24.sp,
      height: 19.h / 24.sp,
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      fontSize: 20.sp,
      height: 20.h / 20.sp,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,

      fontSize: 22.sp,
      height: 30.h / 22.sp,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      fontSize: 20.sp,
      height: 28.h / 20.sp,
    ),
    titleSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,

      fontSize: 16.sp,
      height: 26.h / 20.sp,
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      fontSize: 18.sp,
      height: 21.h / 18.sp,
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      fontSize: 16.sp,
      height: 21.h / 16.sp,
    ),
    bodySmall: TextStyle(
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
      height: 18.h / 14.sp,
    ),
    labelSmall: TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      fontSize: 12.sp,
      height: 14.h / 12.sp,
    ),
  );
}

ThemeData getAppTheme() {
  return ThemeData(
    primarySwatch: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primary,
    fontFamily: GoogleFonts.nunitoSans().fontFamily,
    textTheme: getAppTextTheme(),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(color: Colors.black, size: 24.sp),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primary,
      surface: AppColors.white,
      error: AppColors.error,
    ),
  );
}

class AppAssets {
  static const images = {
    'logo': 'assets/images/logo.png',
    'logo_esteso': 'assets/images/logo_esteso.png',
  };

  static const svg = {};
}
