// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:finance_app/presentation/pages/expense_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add), // Ícone de adição
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExpensePage(),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text('My Finance'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                  '/login'); // Navega de volta para a tela de login
            },
          ),
        ],
      ),
      drawer: MainDrawer(), // Suponho que o seu Drawer seja chamado MainDrawer
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Center(
              child: Image.asset('assets/images/splash_logo.png'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Groups'),
            onTap: () {
              Navigator.of(context).pushNamed('GroupPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Expense'),
            onTap: () {
              Navigator.of(context).pushNamed('ExpensePage');
            },
          ),
          // Adicione mais ListTiles conforme necessário
        ],
      ),
    );
  }
}
