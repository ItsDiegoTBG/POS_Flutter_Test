import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'inicial_page.dart';
import '../../domain/entities/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  UserType defaultType = UserType.normal;
 

  void register(BuildContext context) async {

    User newUser = User(username: usernameController.text, password: passwordController.text,userType: defaultType);
 final authProvider = Provider.of<AuthProvider>(context, listen: false);
  await authProvider.register(newUser);
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InitialPage()));
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
            DropdownButtonFormField<UserType>(
              value:defaultType,
              decoration: InputDecoration(labelText: 'Select Role'),
              items: UserType.values.map((UserType role) {
                return DropdownMenuItem<UserType>(
                  value: role,
                  child: Text(role == UserType.admin ? 'admin' : 'normal'),
                );
              }).toList(),
              onChanged: (UserType? newRole) {
                if (newRole != null) {
                  setState(() => defaultType = newRole);
                }
              },
            ),
            ElevatedButton(onPressed: () => register(context), child: Text('Register')),
                 ],
        ),
      ),
    );
  }
}