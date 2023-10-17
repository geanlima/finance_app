// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'package:finance_app/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'presentation/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Finance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Definindo a SplashScreen como a primeira tela
      routes: {
        '/login': (context) => LoginPage(), // Rota para a tela de login
        // Adicione outras rotas conforme necessário
      },
    );
  }
}
