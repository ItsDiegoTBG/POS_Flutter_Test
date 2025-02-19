import 'package:flutter/material.dart';
import 'presentation/pages/inicial_page.dart';
void main() {
  runApp(const MyApp());
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


