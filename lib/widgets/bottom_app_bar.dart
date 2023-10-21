import 'package:flutter/material.dart';

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
    required this.loadExpenses, // Adicionando um parâmetro para o método _loadExpenses
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  final VoidCallback loadExpenses; // Adicionando um callback para o método _loadExpenses

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
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Chame o método _loadExpenses para atualizar a lista de expenses
                loadExpenses();
              },
            ),
          ],
        ),
      ),
    );
  }
}