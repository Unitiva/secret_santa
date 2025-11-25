import 'package:get_it/get_it.dart';

import '../../features/home/data/datasources/home_datasource.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/send_mail.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // SPLASH
  sl.registerFactory(() => SplashCubit());

  // HOME
  sl.registerLazySingleton(() => HomeDataSource());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SendEmailUseCase(sl()));
  sl.registerFactory(() => HomeCubit(sl()));
}
