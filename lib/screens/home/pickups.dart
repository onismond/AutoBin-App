import 'package:flutter/material.dart';
import 'package:autobin/mech/constants.dart';
import 'package:autobin/mech/screensize.dart';

class Pickups extends StatefulWidget {
  @override
  State<Pickups> createState() => _PickupsState();
}

class _PickupsState extends State<Pickups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.grey.withOpacity(.05),
            width: double.infinity,
            height: screenHeight(
              context,
              dividedBy: 1.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Pickups",
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              color: fHeader)),
                      SizedBox(height: 5),
                      Text(
                        'All your pick history.',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
