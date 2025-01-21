import 'package:flutter/material.dart';
import 'package:autobin/screens/home/dashboard.dart';

class AddBinSuccess extends StatelessWidget {
  const AddBinSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Bin Added Successfully",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 100,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBoard()
                      )
                  );
                },
                child: const Text("Continue")
              )
            ],
          ),
        ),
      )
    );
  }
}

