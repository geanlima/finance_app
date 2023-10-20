// ignore_for_file: constant_identifier_names

enum ExpenseType {
  Expense,
  Income,
}

class Expense {
  final int? id;
  final String title;
  final double value;
  final int groupId;
  final DateTime date;
  final ExpenseType type; // Adicionando o campo de tipo

  Expense({
    this.id,
    required this.title,
    required this.value,
    required this.groupId,
    required this.date,
    required this.type, // Incluindo o tipo no construtor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'groupId': groupId,
      'date': date.toIso8601String(),
      'type': type.toString(), // Convertendo o tipo para uma string
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      value: map['value'],
      groupId: map['groupId'],
      date: DateTime.parse(map['date']),
      type: map['type'] == 'Expense'
          ? ExpenseType.Expense
          : ExpenseType
              .Income, // Convertendo a string do tipo de volta para um enum
    );
  }
}
