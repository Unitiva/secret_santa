import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secret_santa/core/utils/size_extension.dart';

import '../../../../core/utils/const.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({
    super.key,
    required this.context,
    required VoidCallback onPressed,
  }) : _onPressed = onPressed;

  final BuildContext context;
  final VoidCallback _onPressed;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Icon(
              FontAwesomeIcons.gift,
              size: 80.sp,
              color: AppColors.primary[500],
            ),
            SizedBox(height: 20.h),
            Text(
              tr('home.ready_for_secret_santa'),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              tr('home.create_group_description'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: _onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green[500],
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FontAwesomeIcons.plus, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(
                    tr('home.create_new_group'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
