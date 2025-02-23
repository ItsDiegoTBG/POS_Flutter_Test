import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido'),backgroundColor: Colors.blue,foregroundColor: Colors.white,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Punto de Compra y Venta!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              child: Text('Iniciar Sesion'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
