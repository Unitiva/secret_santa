import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:secret_santa/core/routes/app_routes.dart';
import 'package:secret_santa/core/utils/const.dart';
import '../../../../core/shared/logo/pages/logo.dart';
import '../../../../core/utils/app_size_util.dart';
import '../../../../core/utils/size_extension.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _position;

  late final SplashCubit _splashCubit;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _position = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _splashCubit = SplashCubit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _splashCubit.startAnimation(durationMs: 2000);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _splashCubit.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppSizeUtil.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>.value(
      value: _splashCubit,
      child: SafeArea(
        bottom: true,
        top: true,
        child: Scaffold(
          backgroundColor: AppColors.primary[50],
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: SizedBox.shrink(),
          ),
          bottomNavigationBar: SizedBox.shrink(),
          body: BlocListener<SplashCubit, SplashState>(
            listener: (context, state) {
              if (state is SplashLoading) {
                return _buildLoadingEffect(state);
              }
              if (state is SplashLoaded) {
                _buildLoadedEffect(state);
              }
            },
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _position,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [LogoEsteso(height: 50.h)],
        ),
      ),
    );
  }

  void _buildLoadingEffect(SplashLoading state) {
    _controller.value = state.progress;
  }

  void _buildLoadedEffect(SplashLoaded state) {
    if (!mounted) return;
    Future.microtask(() => Get.offNamed(AppRoutes.HOME));
  }
}
