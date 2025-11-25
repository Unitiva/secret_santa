import 'package:flutter/material.dart';
import '../../../utils/size_extension.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final Color textColor;
  final IconData? icon;
  final String message;
  final List<Color> gradientColors;
  final EdgeInsetsGeometry? padding;

  const CustomHeader({
    super.key,
    required this.title,
    required this.textColor,
    this.icon,
    required this.message,
    this.gradientColors = const [Colors.blue, Colors.blueAccent],
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 32.sp),
                SizedBox(width: 12.sp),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15.sp,
                color: textColor.withValues(alpha : 0.9),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              ),
            ),
          ],
      ),
    );
  }
}
