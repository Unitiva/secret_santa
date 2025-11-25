import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app_size_util.dart';

extension SizeExtension on num {
  /// Larghezza scalata rispetto al device (es: 16.w)
  double get w => AppSizeUtil.instance.setWidth(this);

  /// Altezza scalata rispetto al device (es: 16.h)
  double get h => AppSizeUtil.instance.setHeight(this);

  /// Font size scalabile (es: 14.sp)
  double get sp => AppSizeUtil.instance.setSp(this);

  /// Raggio scalabile per border radius (es: 8.r)
  double get r => AppSizeUtil.instance.radius(this);

  /// Diagonale dello schermo (es: 1.dg)
  double get dg => AppSizeUtil.instance.diagonal(this);

  /// Diametro medio tra larghezza e altezza (es: 1.dm)
  double get dm => AppSizeUtil.instance.diameter(this);

  /// Font size smart: il minore tra il valore e lo scalato (es: 16.spMin)
  double get spMin => math.min(toDouble(), sp);

  /// Font size smart: il maggiore tra il valore e lo scalato (es: 16.spMax)
  double get spMax => math.max(toDouble(), sp);

  /// Multiplo della larghezza schermo (es: 0.5.sw)
  double get sw => AppSizeUtil.instance.screenWidth * this;

  /// Multiplo dell'altezza schermo (es: 0.5.sh)
  double get sh => AppSizeUtil.instance.screenHeight * this;

  /// Spaziatura verticale (es: 16.verticalSpace)
  SizedBox get verticalSpace => SizedBox(height: h);

  /// Spaziatura verticale calcolata su larghezza (es: 16.verticalSpaceFromWidth)
  SizedBox get verticalSpaceFromWidth => SizedBox(height: w);

  /// Spaziatura orizzontale (es: 16.horizontalSpace)
  SizedBox get horizontalSpace => SizedBox(width: w);

  /// Spaziatura orizzontale con raggio (es: 8.horizontalSpaceRadius)
  SizedBox get horizontalSpaceRadius => SizedBox(width: r);

  /// Spaziatura verticale con raggio (es: 8.verticalSpacingRadius)
  SizedBox get verticalSpacingRadius => SizedBox(height: r);

  /// Spaziatura orizzontale con diametro (es: 1.horizontalSpaceDiameter)
  SizedBox get horizontalSpaceDiameter => SizedBox(width: dm);

  /// Spaziatura verticale con diametro (es: 1.verticalSpacingDiameter)
  SizedBox get verticalSpacingDiameter => SizedBox(height: dm);

  /// Spaziatura orizzontale con diagonale (es: 1.horizontalSpaceDiagonal)
  SizedBox get horizontalSpaceDiagonal => SizedBox(width: dg);

  /// Spaziatura verticale con diagonale (es: 1.verticalSpacingDiagonal)
  SizedBox get verticalSpacingDiagonal => SizedBox(height: dg);

  /// Pixel scalabile per spaziature minime (es: 1.px)
  double get px =>
      this *
      (AppSizeUtil.instance.screenWidth /
          (AppSizeUtil.instance.scaleWidth * 100));

  /// Lato quadrato scalabile (es: 24.square per icone quadrate)
  double get square =>
      this *
      ((AppSizeUtil.instance.screenWidth < AppSizeUtil.instance.screenHeight
              ? AppSizeUtil.instance.screenWidth
              : AppSizeUtil.instance.screenHeight) /
          AppSizeUtil.instance.scaleWidth);

  /// Valore minimo tra w e h (es: 1.min)
  double get min =>
      this *
      ((AppSizeUtil.instance.screenWidth < AppSizeUtil.instance.screenHeight
              ? AppSizeUtil.instance.screenWidth
              : AppSizeUtil.instance.screenHeight) /
          AppSizeUtil.instance.scaleWidth);

  /// Valore massimo tra w e h (es: 1.max)
  double get max =>
      this *
      ((AppSizeUtil.instance.screenWidth > AppSizeUtil.instance.screenHeight
              ? AppSizeUtil.instance.screenWidth
              : AppSizeUtil.instance.screenHeight) /
          AppSizeUtil.instance.scaleWidth);

  /// Area scalabile (utile per superfici, es: 1.area)
  double get area =>
      this *
      (AppSizeUtil.instance.screenWidth * AppSizeUtil.instance.screenHeight) /
      (AppSizeUtil.instance.scaleWidth * 1000);
}

// EdgeInsets extension
extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets get r =>
      copyWith(top: top.r, bottom: bottom.r, right: right.r, left: left.r);

  EdgeInsets get dm =>
      copyWith(top: top.dm, bottom: bottom.dm, right: right.dm, left: left.dm);

  EdgeInsets get dg =>
      copyWith(top: top.dg, bottom: bottom.dg, right: right.dg, left: left.dg);

  EdgeInsets get w =>
      copyWith(top: top.w, bottom: bottom.w, right: right.w, left: left.w);

  EdgeInsets get h =>
      copyWith(top: top.h, bottom: bottom.h, right: right.h, left: left.h);
}

// BorderRadius extension
extension BorderRadiusExtension on BorderRadius {
  BorderRadius get r => copyWith(
    bottomLeft: bottomLeft.r,
    bottomRight: bottomRight.r,
    topLeft: topLeft.r,
    topRight: topRight.r,
  );

  BorderRadius get w => copyWith(
    bottomLeft: bottomLeft.w,
    bottomRight: bottomRight.w,
    topLeft: topLeft.w,
    topRight: topRight.w,
  );

  BorderRadius get h => copyWith(
    bottomLeft: bottomLeft.h,
    bottomRight: bottomRight.h,
    topLeft: topLeft.h,
    topRight: topRight.h,
  );
}

// Radius extension
extension RadiusExtension on Radius {
  Radius get r => Radius.elliptical(x.r, y.r);
  Radius get dm => Radius.elliptical(x.dm, y.dm);
  Radius get dg => Radius.elliptical(x.dg, y.dg);
  Radius get w => Radius.elliptical(x.w, y.w);
  Radius get h => Radius.elliptical(x.h, y.h);
}

// BoxConstraints extension
extension BoxConstraintsExtension on BoxConstraints {
  BoxConstraints get r => copyWith(
    maxHeight: maxHeight.r,
    maxWidth: maxWidth.r,
    minHeight: minHeight.r,
    minWidth: minWidth.r,
  );

  BoxConstraints get hw => copyWith(
    maxHeight: maxHeight.h,
    maxWidth: maxWidth.w,
    minHeight: minHeight.h,
    minWidth: minWidth.w,
  );

  BoxConstraints get w => copyWith(
    maxHeight: maxHeight.w,
    maxWidth: maxWidth.w,
    minHeight: minHeight.w,
    minWidth: minWidth.w,
  );

  BoxConstraints get h => copyWith(
    maxHeight: maxHeight.h,
    maxWidth: maxWidth.h,
    minHeight: minHeight.h,
    minWidth: minWidth.h,
  );
}
