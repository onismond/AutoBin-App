import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String id;
  final String date;
  final String amount;
  final bool cleared;

  final VoidCallback onTap;

  const TransactionCard({
    Key? key,
    required this.id,
    required this.date,
    required this.amount,
    required this.cleared,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
        splashColor: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: Icon(
            Icons.credit_card_rounded,
            color: Colors.blue[300],
            size: 30,
          ),
          title: Text(
            "GHS $amount",
            style: const TextStyle(fontSize: 17),
          ),
          subtitle: Text("ID: $id, Date: $date"),
          trailing: Icon(
            cleared ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
            color: cleared ? Colors.green : Colors.redAccent,
            size: 30,
          )
        ),
      ),
    );
  }
}
