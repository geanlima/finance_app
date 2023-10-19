class Expense {
  final int? id;
  final String title;
  final double value;
  final int groupId;

  Expense(
      {this.id,
      required this.title,
      required this.value,
      required this.groupId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'groupId': groupId,
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      value: map['value'],
      groupId: map['groupId'],
    );
  }
}
