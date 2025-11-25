import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secret_santa/core/shared/common_scaffold/pages/common_scaffold_page.dart';

import '../../../../core/utils/const.dart';
import '../../../../core/shared/header/pages/custom_header.dart';
import '../../data/datasources/home_datasource.dart';
import '../../data/repositories/home_repository.dart';
import '../../domain/usecases/send_mail.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/create_group_page.dart';
import '../widgets/welcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();

    final datasource = HomeDataSource();
    final repository = HomeRepositoryImpl(datasource);
    final getHomeData = SendEmailUseCase(repository);
    _homeCubit = HomeCubit(getHomeData);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: BlocProvider<HomeCubit>.value(
        value: _homeCubit,
        child: Column(
          children: [
            CustomHeader(
              title: tr('app_name'),
              icon: FontAwesomeIcons.tree,
              textColor: Colors.white,
              message: tr('welcome'),
              gradientColors: [
                AppColors.primary[500]!,
                AppColors.primary[900]!,
              ],
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeInitial) {
                  return _buildInitialBody();
                }
                if (state is HomeCreatingGroup) {
                  return _buildCreatingGroupBody();
                }

                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialBody() {
    return Expanded(
      child: WelcomeWidget(
        context: context,
        onPressed: _homeCubit.startCreatingGroup,
      ),
    );
  }

  Widget _buildCreatingGroupBody() {
    return Expanded(child: GroupPage(backToInitial: _homeCubit.backToInitial));
  }
}
