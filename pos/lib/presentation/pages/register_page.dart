import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import '../providers/auth_provider.dart';
//import 'home_screen.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({super.key});

  void register(BuildContext context) async {
   // final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //  bool success = await authProvider.login(usernameController.text, passwordController.text);

  //  if (success) {
   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  //  } else {
    //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid credentials")));
   // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => register(context), child: Text('Register')),
                 ],
        ),
      ),
    );
  }
}