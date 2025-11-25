import 'package:flutter/material.dart';

import '../../../utils/const.dart';

class LogoEsteso extends StatelessWidget {
  final double height;
  final double? fontSize;
  final Color? color;

  const LogoEsteso({super.key, this.height = 0, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppAssets.images['logo']!,
          // width: 50.w,
          height: height,
        ),
        Image.asset(
          AppAssets.images['logo_esteso']!,
          // width: 50.w,
          height: height,
        ),
      ],
    );
  }
}
