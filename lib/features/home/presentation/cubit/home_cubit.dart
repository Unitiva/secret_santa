import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/send_mail.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SendEmailUseCase sendEmailUseCase;

  HomeCubit(this.sendEmailUseCase) : super(HomeInitial());

  void startCreatingGroup() {
    emit(HomeCreatingGroup());
  }

  void backToInitial() {
    emit(HomeInitial());
  }

  void sendEmails() async {
    try {
      await sendEmailUseCase();
      // You might want to emit a success state here
    } catch (e) {
      // Handle error, possibly emit an error state
    }
  }
}
