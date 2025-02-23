import 'package:flutter/material.dart';
import 'package:pos/presentation/pages/register_page.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user.dart';
import '../providers/auth_provider.dart';
import 'admin_home.dart';
import 'user_home.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  List<User> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    var users = await authProvider.getAllUsers(); 
    setState(() {
      _allUsers = users;
    });
  }

  Future<void> _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userExist = await authProvider.login(_emailController.text, _passwordController.text);
    //Try to change this validation later so its in the Login User use case so You can do it 
    // from the Auth_Provider and not do something dangerous.
    if ( userExist == true) {
      final isAdmin = await authProvider.isAdmin(_emailController.text, _passwordController.text);
      if (isAdmin) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminHome()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserHome()));
      }
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesion"),backgroundColor: Colors.blue,foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Usuario"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
                 ElevatedButton(
                    onPressed: _login,
                    child: Text("Iniciar Sesion"),
                  ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())),
              child: Text("No tienes cuenta? Registrate!"),
            ),
           // SizedBox(height: 20),
           // if (_allUsers.isNotEmpty) ...[
           //   Text('Usuario en la Base de datos, para Debug:'),
           //   for (var user in _allUsers) Text('${user.username} - ${user.userType}'),
           // ]
          ],
        ),
      ),
    );
  }
}
