import 'package:flutter/material.dart';
import 'dart:async'; // Para usar o Timer

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3), // Duração que a tela de splash será exibida
      () => Navigator.pushReplacementNamed(
          context, '/login'), // Direciona para a tela de login após a duração
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Image.asset('assets/images/splash_logo.png'), // Sua imagem ou logo
      ),
    );
  }
}
