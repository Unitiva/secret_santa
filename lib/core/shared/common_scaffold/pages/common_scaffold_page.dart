import 'package:flutter/material.dart';
import '../../../utils/const.dart';

class CommonScaffold extends StatefulWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const CommonScaffold({
    super.key,
    this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  State<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  @override
  Widget build(BuildContext context) {
    var safeArea = SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: widget.appBar,
        bottomNavigationBar: widget.bottomNavigationBar,
        body: widget.body,
      ),
    );
    return safeArea;
  }
}
