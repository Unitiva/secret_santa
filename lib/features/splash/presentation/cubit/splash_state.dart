sealed class SplashState {}

class SplashLoading extends SplashState {
  final double progress; // 0.0 .. 1.0
  SplashLoading(this.progress);

  SplashLoading copyWith({double? progress}) {
    return SplashLoading(progress ?? this.progress);
  }

  @override
  String toString() => 'SplashLoading(progress: $progress)';
}

class SplashLoaded extends SplashState {
  SplashLoaded();

  @override
  String toString() => 'SplashLoaded()';
}
