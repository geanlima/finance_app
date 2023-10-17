// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:finance_app/widgets/signup_popup.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/data/database/database_helper.dart';
import 'package:finance_app/models/user.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: Loginform(),
        ),
      ),
    );
  }
}

class Loginform extends StatefulWidget {
  @override
  _LoginformState createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User? user =
          await DatabaseHelper.instance.fetchUser(_username, _password);

      if (user != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login bem-sucedido!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuário ou senha inválidos")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.account_balance_wallet,
          size: 100,
          color: Colors.blue,
        ),
        SizedBox(height: 20),
        Text(
          'My Finance App',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 40),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your username';
            }
            return null;
          },
          onSaved: (value) {
            _username = value!;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock_outline),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
          onSaved: (value) {
            _password = value!;
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            primary: Colors.blue,
          ),
          child: Text("Login"),
        ),
        SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () {
              // Aqui você navegará para a tela de cadastro.
              // Ajuste "YourSignupPage" para o nome da sua classe de tela de cadastro.
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignupPopup()));
            },
            child: Text('Não tem uma conta? Cadastre-se'),
          ),
        ),
      ],
    );
  }
}
