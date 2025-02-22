import 'package:pos/domain/entities/user.dart';
import '../../data/repositories/user_repository.dart';

class LoginUserUsecase {
  final UserRepository repository;

  LoginUserUsecase(this.repository);

  Future<User?> execute(String username, String password) async{
    User? user= await repository.loginUser(username, password);
    if(user != null){
      return user;
    }
    return null;
  }

  Future<bool> isAdmin(String username, String password) async{
    User? user= await repository.loginUser(username, password);
    if(user?.userType == UserType.admin){
      return true;
    }
    return false;
  } 



}