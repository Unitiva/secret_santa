import '../repositories/home_repository.dart';

class SendEmailUseCase {
  final HomeRepository repository;

  SendEmailUseCase(this.repository);

  Future<void> call() => repository.sendMail();
}
