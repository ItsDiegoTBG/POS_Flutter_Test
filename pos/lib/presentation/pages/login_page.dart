import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import '../providers/auth_provider.dart';
//import 'home_screen.dart';
import 'register_page.dart';
class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  void login(BuildContext context) async {
   // final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //  bool success = await authProvider.login(usernameController.text, passwordController.text);

  //  if (success) {
   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  //  } else {
    //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid credentials")));
   // }
  // if (user.userType == UserType.admin) {
  //print("Welcome, Admin!");
//} else {
//  print("Welcome, User!");
//}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => login(context), child: Text('Login')),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())), child: Text('Register'))
          ],
        ),
      ),
    );
  }
}
