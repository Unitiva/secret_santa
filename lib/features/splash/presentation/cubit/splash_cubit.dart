import 'dart:async';
import 'package:bloc/bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashLoading(0.0));

  Timer? _timer;

  /// Avvia l'animazione: emette SplashLoading(progress) periodicamente.
  void startAnimation({int durationMs = 2000, int tickMs = 16}) {
    _timer?.cancel();
    final int steps = (durationMs / tickMs).ceil();
    int current = 0;
    emit(SplashLoading(0.0));
    _timer = Timer.periodic(Duration(milliseconds: tickMs), (t) {
      current++;
      final double progress = (current / steps).clamp(0.0, 1.0);
      emit(SplashLoading(progress));
      if (progress >= 1.0) {
        _timer?.cancel();
        emit(SplashLoaded());
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}