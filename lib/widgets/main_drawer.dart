// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

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
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('GroupPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Expense'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('ExpensePage');
            },
          ),
          // Adicione mais ListTiles conforme necessário
        ],
      ),
    );
  }
}
