// ignore_for_file: library_private_types_in_public_api, unused_element, prefer_const_constructors

import 'package:finance_app/presentation/pages/group_page.dart';
import 'package:finance_app/widgets/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/data/database/database_helper.dart';
import 'package:finance_app/models/expense.dart';
import 'package:finance_app/presentation/pages/expense_page.dart';
import 'package:finance_app/widgets/main_drawer.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showFab = true;
  bool _showNotch = true;
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endDocked;
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

  void _onShowNotchChanged(bool value) {
    setState(() {
      _showNotch = value;
    });
  }

  void _onShowFabChanged(bool value) {
    setState(() {
      _showFab = value;
    });
  }

  void _onFabLocationChanged(FloatingActionButtonLocation? value) {
    setState(() {
      _fabLocation = value ?? FloatingActionButtonLocation.endDocked;
    });
  }

  void _logout() {
    // Remove todas as rotas anteriores para impedir o retorno à HomePage após o logout
    Navigator.of(context).popUntil(ModalRoute.withName('/login'));

    // Aguarde um pequeno atraso antes de navegar para a tela de login
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  void _deleteExpense(int expenseId) async {
    await DatabaseHelper.instance.deleteExpense(expenseId);
    _loadExpenses(); // Atualize a lista de despesas após a exclusão
  }

  void _showDeleteConfirmationDialog(int expenseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir este registro?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                // Confirma a exclusão
                _deleteExpense(expenseId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    for (var expense in _expenses) {
      total += expense.value;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'GroupPage': (context) => GroupPage(),
        'ExpensePage': (context) => ExpensePage(),
      },
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Finance'),
              Row(
                children: [
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: _loadExpenses,
                  ),
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: _logout,
                  ),
                ],
              ),
            ],
          ),
        ),
        drawer: MainDrawer(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];
                  return ListTile(
                    title: Text(expense.title),
                    subtitle:
                        Text('Valor: ${expense.value.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(expense.id ?? 0);
                      },
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0, // para ficar na parte inferior da tela
              left: 0, // começar do canto esquerdo da tela
              right: 0, // terminar no canto direito da tela
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors
                    .blueGrey, // você pode escolher sua cor preferida aqui
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      "R\$ ${_calculateTotalAmount().toStringAsFixed(2)}", // usando $ para representar a moeda
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _showFab
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExpensePage(),
                    ),
                  );
                },
                tooltip: 'Create',
                child: const Icon(Icons.add),
              )
            : null,
        floatingActionButtonLocation: _fabLocation,
        bottomNavigationBar: BottomAppBarWidget(
          fabLocation: _fabLocation,
          shape: _showNotch ? const CircularNotchedRectangle() : null,
          loadExpenses: _loadExpenses,
          totalAmount: _calculateTotalAmount(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    DatabaseHelper.instance.closeDatabase();
    super.dispose();
  }
}
