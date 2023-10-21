// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:finance_app/models/user.dart';
import 'package:finance_app/presentation/pages/home_page.dart';
import 'package:finance_app/widgets/signup_popup.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/data/database/database_helper.dart';

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
  // ignore: library_private_types_in_public_api
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

        // Navegue para ExpensePage
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuário ou senha inválidos")));
      }
    }
  }

  void _showUsersPopup() async {
    List<User> users = await DatabaseHelper.instance.fetchAllUsers();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Lista de Usuários'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index].username),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _dropAndRecreateDatabase(BuildContext context) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.dropAndRecreateDatabase();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Banco de Dados recriado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao recriar o Banco de Dados: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text("Login"),
          ),
          SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupPopup()));
              },
              child: Text('Não tem uma conta? Cadastre-se'),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: _showUsersPopup,
              child: Text('Ver todos os usuários'),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () {
                _dropAndRecreateDatabase(context);
              },
              child: Text(
                  'Recriar Banco de Dados'), // Botão para recriar o banco de dados
            ),
          ),
        ],
      ),
    );
  }
}
