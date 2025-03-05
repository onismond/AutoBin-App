class Transaction {
  late int id;
  late String date;
  late double amount;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
  });

  Transaction.fromMap(obj) {
    this.id = obj['id'];
    this.date = obj['date'];
    this.amount = obj['amount'];
  }
}