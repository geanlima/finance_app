import 'package:finance_app/presentation/pages/group_page.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/data/database/database_helper.dart';
import 'package:finance_app/models/expense.dart';
import 'package:finance_app/presentation/pages/expense_page.dart';
import 'package:finance_app/widgets/main_drawer.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'GroupPage': (context) => GroupPage(), // Rota para a tela de Grupos
        'ExpensePage': (context) =>
            ExpensePage(), // Rota para a tela de Lançamentos
        // Adicione outras rotas conforme necessário
      },
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('My Finance'),
        ),

        drawer: MainDrawer(), // Adicione o MainDrawer aqui
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
                    subtitle:
                        Text('Valor: ${expense.value.toStringAsFixed(2)}'),
                    // Mais detalhes sobre a despesa
                    // ...
                  );
                },
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
        bottomNavigationBar: _BottomAppBar(
          fabLocation: _fabLocation,
          shape: _showNotch ? const CircularNotchedRectangle() : null,
        ),
      ),
    );
  }
}

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Adicionei esta linha
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Abre o drawer quando o ícone do menu é pressionado
                Scaffold.of(context).openDrawer();
              },
            ),
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Abre o drawer quando o ícone do menu é pressionado
                Scaffold.of(context).openDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }
}
