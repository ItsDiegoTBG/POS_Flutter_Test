import 'package:pos/data/repositories/user_repository.dart';
import '../../domain/entities/user.dart';
class RegisterUserUsecase {
  final UserRepository repository;

  RegisterUserUsecase(this.repository);
  Future<void> execute(User user) async{
    await repository.insertUser(user);
  }
}