import 'package:flutter/material.dart';
import 'package:pos/data/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'data/database_helper.dart';
import 'domain/usecases/login_user_usecase.dart';
import 'domain/usecases/register_user_usecase.dart';
import 'presentation/pages/inicial_page.dart';
import 'presentation/providers/auth_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.init();
  //commands to set up database
  //await UserRepository().delateUsers(100);
  //await UserRepository().initializeUsers();
  final authRepository = UserRepository();
  final loginUsecase = LoginUserUsecase(authRepository);
  final registerUsecase = RegisterUserUsecase(authRepository);
   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(loginUsecase,registerUsecase)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 241, 240, 244)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: InitialPage(),
    );
  }
}


