import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe a biblioteca intl para formatação de datas
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
  DateTime _selectedDate = DateTime.now(); // Data inicial

  @override
  void initState() {
    super.initState();
    _loadExpensesForSelectedDate(_selectedDate);
  }

  _loadExpensesForSelectedDate(DateTime selectedDate) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    List<Expense> expenses =
        await DatabaseHelper.instance.loadExpensesForDate(formattedDate);

    setState(() {
      _expenses = expenses;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadExpensesForSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Botão para selecionar data
          TextButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text(
              'Selecionar Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
          ),

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
    );
  }
}
