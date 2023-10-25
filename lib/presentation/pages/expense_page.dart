// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'package:finance_app/presentation/pages/group_page.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/models/expense.dart';
import 'package:finance_app/models/group.dart';
import 'package:finance_app/data/database/database_helper.dart';
import 'package:intl/intl.dart';

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _value = 0.0;
  int _selectedGroupId = 0;
  ExpenseType _selectedExpenseType = ExpenseType.Expense;
  DateTime _selectedDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController _dateController = TextEditingController();

  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
    _dateController.text = _dateFormat.format(_selectedDate);
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
      Expense newExpense = Expense(
        title: _title.toUpperCase(),
        value: _value,
        groupId: _selectedGroupId,
        date: _selectedDate,
        type: _selectedExpenseType,
      );

      await DatabaseHelper.instance.addExpense(newExpense);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Despesa adicionada com sucesso!')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedGroupId = 0;
        _selectedExpenseType = ExpenseType.Expense;
        _selectedDate = DateTime.now();
        _dateController.text = _dateFormat.format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense'),
        actions: [
          IconButton(
            icon: Icon(Icons.group_add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GroupPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _dateController.text =
                            _dateFormat.format(_selectedDate);
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione uma data.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<ExpenseType>(
                  items: ExpenseType.values.map((type) {
                    return DropdownMenuItem<ExpenseType>(
                      value: type,
                      child: Text(
                        type == ExpenseType.Expense ? 'Despesa' : 'Receita',
                      ),
                    );
                  }).toList(),
                  value: _selectedExpenseType,
                  onChanged: (type) {
                    setState(() {
                      _selectedExpenseType = type!;
                    });
                  },
                  hint: Text('Selecione um tipo'),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione um tipo.';
                    }
                    return null;
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
      ),
    );
  }
}
