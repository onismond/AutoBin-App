import 'package:flutter/material.dart';

class AddBin extends StatefulWidget {
  final String qrValue;

  const AddBin({super.key, required this.qrValue});

  @override
  State<AddBin> createState() => _AddBinState();
}

class _AddBinState extends State<AddBin> {
  String qrValue = '';

  @override void initState() {
    qrValue = widget.qrValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(qrValue),
    );
  }
}
