// ignore_for_file: library_private_types_in_public_api, unused_field, use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:finance_app/data/database/database_helper.dart';
import 'package:finance_app/models/user.dart';
import 'package:flutter/material.dart';

class SignupPopup extends StatefulWidget {
  @override
  _SignupPopupState createState() => _SignupPopupState();
}

class _SignupPopupState extends State<SignupPopup> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Salvando o novo usuário no banco de dados.
      User newUser = User(
          username: _username,
          password: _password); // Supondo que a classe User existe
      await DatabaseHelper.instance
          .addUser(newUser); // Supondo que você tenha esse método

      Navigator.pop(context);

      // Exibir uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário cadastrado com sucesso!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cadastrar novo usuário'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ListBody(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome de usuário.';
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
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('Cadastrar'),
          onPressed: _submit,
        ),
      ],
    );
  }
}
