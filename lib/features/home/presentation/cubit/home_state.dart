sealed class HomeState {}

class HomeInitial extends HomeState {
  HomeInitial();

  @override
  String toString() => 'HomeInitial()';
}

class HomeCreatingGroup extends HomeState {
  @override
  String toString() => 'HomeCreatingGroup()';
}
