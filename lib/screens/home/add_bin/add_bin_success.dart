import 'package:flutter/material.dart';

class AddBinSuccess extends StatelessWidget {
  const AddBinSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Bin Added Successfully")
            ],
          ),
        )
    );
  }
}

