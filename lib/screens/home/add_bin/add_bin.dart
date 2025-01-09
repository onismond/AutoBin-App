import 'package:autobin/mech/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:autobin/mech/constants.dart';
import 'package:autobin/screens/home/add_bin/pick_bin_location.dart';


class AddBin extends StatefulWidget {
  final String qrValue;


  const AddBin({super.key, required this.qrValue});

  @override
  State<AddBin> createState() => _AddBinState();
}

class _AddBinState extends State<AddBin> {
  String? qrValue;
  String? binName;
  String? binColor;

  final Map<String, Color> colors = {
    'Blue': Colors.blue,
    'Red': Colors.red,
    'Black': Colors.black,
    'Orange': Colors.orange,
  };

  @override void initState() {
    qrValue = widget.qrValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bin Details'),
      ),
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Bin ID: ",
                  style: TextStyle(
                    fontSize: 18,
                    color: fHeader,
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  enabled: false,
                  decoration: customInput.copyWith(
                      hintText: qrValue
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Bin Name",
                  style: TextStyle(
                    fontSize: 16,
                    color: fHeader,
                  ),
                ),
                SizedBox(height: 5,),
                TextFormField(
                  decoration: customInput.copyWith(
                    hintText: "Enter Bin Name"
                  ),
                  onChanged: (newValue) => binName = newValue,
                ),
                SizedBox(height: 20),
                Text(
                  "Bin Color",
                  style: TextStyle(
                    fontSize: 16,
                    color: fHeader,
                  ),
                ),
                SizedBox(height: 5,),
                DropdownButtonFormField(
                  decoration: customInput.copyWith(),
                  hint: Text('Select the color of your bin'),
                  items: colors.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: entry.value,
                            margin: EdgeInsets.only(right: 10),
                          ),
                          Text(entry.key),
                        ],
                      ),
                    );
                  }).toList(),
                    onChanged: (String? newColor) {
                      setState(() {
                        binColor = newColor;
                      });
                    }
                ),
                SizedBox(height: 60,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bColor1,
                    foregroundColor: Colors.deepPurple
                  ),
                  onPressed: () => pickLocation(),
                  child: Text('Next'),
                )
              ],
            ),
          )
      )
    );
  }

  void pickLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PickBinLocation(
            qrValue: qrValue!,
            binName: binName!,
            binColor: binColor!,
          )
      ),
    );
  }
}


















