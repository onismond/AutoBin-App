class Transaction {
  late int id;
  late String date;
  late double amount;
  late bool cleared;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.cleared,
  });

  Transaction.fromMap(obj) {
    id = obj['id'];
    date = obj['date'];
    amount = obj['amount'];
    cleared = obj['cleared'];
  }
}