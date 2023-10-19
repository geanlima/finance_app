// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/models/expense.dart';
import 'package:finance_app/models/group.dart';
import 'package:finance_app/data/database/database_helper.dart';

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _value = 0.0;
  int _selectedGroupId = 0;

  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  _loadGroups() async {
    List<Group> groupsFromDb = await DatabaseHelper.instance.loadGroups();

    if (groupsFromDb.isNotEmpty) {
      setState(() {
        _groups = groupsFromDb;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Expense newExpense =
          Expense(title: _title, value: _value, groupId: _selectedGroupId);

      await DatabaseHelper.instance.addExpense(newExpense);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Despesa adicionada com sucesso!')));

      _formKey.currentState!.reset();
      setState(() {
        _selectedGroupId = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Despesa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Por favor, insira um valor válido.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _value = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                items: _groups.map((Group group) {
                  return DropdownMenuItem<int>(
                    value: group.id,
                    child: Text(group.name),
                  );
                }).toList(),
                hint: Text('Selecione um grupo'),
                onChanged: (value) {
                  setState(() {
                    _selectedGroupId = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um grupo.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _selectedGroupId = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Adicionar Despesa'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('_selectedGroupId', _selectedGroupId));
  }
}
