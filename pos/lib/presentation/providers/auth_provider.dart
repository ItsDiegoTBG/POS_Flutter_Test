import 'package:flutter/material.dart';
import 'package:pos/data/repositories/user_repository.dart';
import '../../domain/usecases/login_user_usecase.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUserUsecase loginUserUseCase;
  final RegisterUserUsecase registerUserUseCase;
  User? _user;
 

  AuthProvider(
    this.loginUserUseCase,
    this.registerUserUseCase,
  );

  User? get user => _user;
 
  Future<bool> isAdmin(String username, String password) async {
    return await loginUserUseCase.isAdmin(username, password);
  }

  Future<bool> login(String username, String password) async {
    notifyListeners();
    _user = await loginUserUseCase.execute(username, password);
    notifyListeners();
    return _user != null;
  }
  Future<List<User>> getAllUsers() async {
    return UserRepository().getAllUsers() ;
  }

  Future<void> register(User user) async {
    notifyListeners();
    await registerUserUseCase.execute(user);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  
}
