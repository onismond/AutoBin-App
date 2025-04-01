import 'package:flutter/material.dart';

class PickupCard extends StatelessWidget {
  final String amount;
  final String binName;
  final String dateOrdered;
  final VoidCallback onTap;

  const PickupCard({
    Key? key,
    required this.amount,
    required this.binName,
    required this.dateOrdered,
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
          contentPadding: const EdgeInsets.all(10),
          leading: Icon(
            Icons.fire_truck_sharp,
            color: Colors.blue[300],
            size: 30,
          ),
          title: Text(
            "GHS $amount,  $binName",
            style: const TextStyle(fontSize: 17),
          ),
          subtitle: Text("Date Ordered: $dateOrdered"),
        ),
      ),
    );
  }
}
