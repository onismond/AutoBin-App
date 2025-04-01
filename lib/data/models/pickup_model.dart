class Pickup {
  late int id;
  late String bin_name;
  late double amount;
  late String date;
  late bool cleared;

  Pickup({
    required this.id,
    required this.bin_name,
    required this.amount,
    required this.date,
    required this.cleared,
  });

  Pickup.fromMap(obj) {
    this.id = obj['id'];
    this.bin_name = obj['bin_name'];
    this.amount = obj['amount'];
    this.date = obj['date'];
    this.cleared = obj['cleared'];
  }
}