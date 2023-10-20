import 'package:flutter/material.dart';
import 'package:finance_app/data/database/database_helper.dart';
import 'package:finance_app/models/expense.dart';
import 'package:finance_app/presentation/pages/expense_page.dart';
import 'package:finance_app/widgets/main_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  _loadExpenses() async {
    List<Expense> expenses = await DatabaseHelper.instance.loadExpenses();

    setState(() {
      _expenses = expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Lista de despesas
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text('Valor: ${expense.value.toStringAsFixed(2)}'),
                  // Mais detalhes sobre a despesa
                  // ...
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExpensePage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
