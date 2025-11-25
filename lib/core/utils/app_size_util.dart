import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'dart:math';

enum DeviceType { mobile, tablet, desktop, web, mac, windows, linux, fuchsia }

typedef FontSizeResolver = double Function(num fontSize, AppSizeUtil instance);

class AppSizeUtil {
  static final AppSizeUtil _instance = AppSizeUtil._();
  static AppSizeUtil get instance => _instance;

  late Size _uiSize;
  late MediaQueryData _data;
  late Orientation _orientation;
  late bool _minTextAdapt;
  FontSizeResolver? fontSizeResolver;

  AppSizeUtil._();

  static void init(
    BuildContext context, {
    Size designSize = const Size(360, 690),
    bool splitScreenMode = false,
    bool minTextAdapt = false,
    FontSizeResolver? fontSizeResolver,
  }) {
    final data = MediaQuery.of(context);
    _instance._data = data;
    _instance._uiSize = designSize;
    _instance._orientation = data.orientation;
    _instance._minTextAdapt = minTextAdapt;
    _instance.fontSizeResolver = fontSizeResolver;
  }

  double get screenWidth => _data.size.width;
  double get screenHeight => _data.size.height;
  double get statusBarHeight => _data.padding.top;
  double get bottomBarHeight => _data.padding.bottom;

  /// Calcola un moltiplicatore di scala in base alla larghezza effettiva dello schermo.
  /// Puoi personalizzare i breakpoints e i valori come preferisci.
  double get widthMultiplier {
    final width = screenWidth;
    // Scaling smooth (interpolazione lineare):
    return 1.0 +
        ((width - 360).clamp(0, 1440 - 360) / (1440 - 360)) * (2.0 - 1.0);

    // Breakpoint a step (alternativa):
    // if (width >= 1440) {
    //   return 2.0;
    // } else if (width >= 1024) {
    //   return 1.5;
    // } else if (width >= 600) {
    //   return 1.2;
    // } else {
    //   return 1.0;
    // }
  }

  /// Calcola un moltiplicatore di scala in base all'altezza effettiva dello schermo.
  /// Puoi personalizzare i breakpoints e i valori come preferisci.
  double get heightMultiplier {
    final height = screenHeight;
    // Scaling smooth (interpolazione lineare):
    return 1.0 +
        ((height - 600).clamp(0, 1200 - 600) / (1200 - 600)) * (2.0 - 1.0);

    // Breakpoint a step (alternativa):
    // if (height >= 1200) {
    //   return 2.0;
    // } else if (height >= 900) {
    //   return 1.5;
    // } else if (height >= 700) {
    //   return 1.2;
    // } else {
    //   return 1.0;
    // }
  }

  double get scaleWidth => (screenWidth / _uiSize.width) * widthMultiplier;
  double get scaleHeight => (screenHeight / _uiSize.height) * heightMultiplier;
  double get scaleText =>
      _minTextAdapt ? min(scaleWidth, scaleHeight) : scaleWidth;

  double setWidth(num width) => width * scaleWidth;
  double setHeight(num height) => height * scaleHeight;
  double radius(num r) => r * min(scaleWidth, scaleHeight);
  double diagonal(num d) => d * scaleHeight * scaleWidth;
  double diameter(num d) => d * max(scaleWidth, scaleHeight);
  double setSp(num fontSize) =>
      fontSizeResolver?.call(fontSize, this) ?? fontSize * scaleText;

  DeviceType deviceType() {
    if (kIsWeb) return DeviceType.web;
    final width = screenWidth;
    final height = screenHeight;
    final orientation = _orientation;
    bool isMobile =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
    bool isTablet =
        (orientation == Orientation.portrait && width >= 600) ||
        (orientation == Orientation.landscape && height >= 600);
    if (isMobile) {
      return isTablet ? DeviceType.tablet : DeviceType.mobile;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.linux:
        return DeviceType.linux;
      case TargetPlatform.macOS:
        return DeviceType.mac;
      case TargetPlatform.windows:
        return DeviceType.windows;
      case TargetPlatform.fuchsia:
        return DeviceType.fuchsia;
      default:
        return DeviceType.desktop;
    }
  }

  SizedBox setVerticalSpacing(num height) =>
      SizedBox(height: setHeight(height));
  SizedBox setVerticalSpacingFromWidth(num height) =>
      SizedBox(height: setWidth(height));
  SizedBox setHorizontalSpacing(num width) => SizedBox(width: setWidth(width));
  SizedBox setHorizontalSpacingRadius(num width) =>
      SizedBox(width: radius(width));
  SizedBox setVerticalSpacingRadius(num height) =>
      SizedBox(height: radius(height));
  SizedBox setHorizontalSpacingDiameter(num width) =>
      SizedBox(width: diameter(width));
  SizedBox setVerticalSpacingDiameter(num height) =>
      SizedBox(height: diameter(height));
  SizedBox setHorizontalSpacingDiagonal(num width) =>
      SizedBox(width: diagonal(width));
  SizedBox setVerticalSpacingDiagonal(num height) =>
      SizedBox(height: diagonal(height));
}
