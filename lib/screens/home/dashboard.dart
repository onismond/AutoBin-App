import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:autobin/controllers/pref_controller.dart';
import 'package:autobin/controllers/api_controller.dart';
import 'package:autobin/mech/constants.dart';
import 'package:autobin/mech/customWidgets.dart';
import 'package:autobin/mech/screensize.dart';
import 'package:autobin/models/bin_model.dart';
import 'package:autobin/screens/home/bin-details.dart';
import 'package:autobin/screens/home/add_bin/scan_bin_qr.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String fName = '';
  String residenceAddress = '';

  // get owner bins
  List<Bin> _bins = [];

  var pickup = DateTime.parse('2024-12-17 13:04:27.000000'); // last pickup time
  var _pickedTime;

  //holds status for loading api data
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    callData();
    _pickUpTime();
    _loadBins();
  }

  callData() async {
    // fName = await PrefController.getFName();
    // residenceAddress = await PrefController.getRAdress();
    fName = "";
    residenceAddress = "";
  }

  _pickUpTime() async {
    final now = new DateTime.now();
    final difference = now.difference(pickup);
    final result = timeago.format(now.subtract(difference), locale: 'en');
    setState(() {
      _pickedTime = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Container(
          color: Color.fromARGB(1, 245, 236, 236),
          width: double.infinity,
          height: screenHeight(context, dividedBy: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 30),
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: fHeader),
                        children: [
                      TextSpan(text: "Hello "),
                      TextSpan(text: fName)
                    ])),
              ),
              SizedBox(height: 13),
              Center(
                child: OverViewCard(
                    residence: residenceAddress,
                    numberOfBins: _bins.length,
                    lastPickup: _pickedTime),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30, bottom: 0),
                    child: Text("Bins Owned",
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color: fHeader)),
                  ),
                  TextButton(
                    child: Text("Add Bin"),
                    onPressed: () => { _addBin() },
                  ),
                ],
              ),

              _binListBuilder()
            ],
          ),
        ),
      ),
    );
  }

  _binListBuilder() {
    return Expanded(
      child: _isProcessing
          ? Center(
              child: loadingSpinner2,
            )
          : _bins.length > 0
              ? ListView.builder(
                  itemCount: _bins.length,
                  itemBuilder: (context, position) {
                    return _binBuilder(_bins[position]);
                  })
              : Center(
                  child: Text("There are no bins to display",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black26,
                      )),
                ),
    );
  }

  _binBuilder(Bin bin) {
    return BinCard2(
      binID: bin.binID,
      nickName: bin.nickName,
      binSerial: bin.serialNumber,
      pickupMsg: () {
        int.parse(bin.currentLevel) < 1
            ? errorDialog(context,
                title: "Not Allowed",
                message: "This bin is still empty",
                primaryButtonText: "Ok", onPrimaryPress: () {
                Navigator.of(context).pop();
              })
            : defaultDialog(context,
                title: 'Order Pickup',
                message:
                    'Do you want to order a pickup for "${bin.nickName}" (${bin.serialNumber})',
                primaryButtonText: "Yes",
                onPrimaryPress: () {
                  _orderForPickup(context, bin.binID);
                },
                secondaryButtonText: 'Cancel',
                onSecondaryPress: () {
                  Navigator.of(context).pop();
                });
      },
      routTo: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BinDetails(
                binObject: bin,
              ),
            ));
      },
    );
  }

  _addBin() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScanBinQR()
      )
    );
  }

  // Load bins for owner
  _loadBins() async {
    //if loading menu process is already ongoing, exit
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    await APIController().ownerBins().then((Response<dynamic> response) async {
      //create the bin list
      List<Bin> binList = [];

      //get the bin list with map data
      List binData = APIController.decodeListData(response);
      print(binData);

      //convert the bin data map to model
      binData.forEach((bin) {
        binList.add(Bin.fromMap(bin));
      });

      setState(() {
        _isProcessing = false;
        _bins = binList;
      });
    }, onError: (e) {
      //DioError
      setState(() {
        _isProcessing = false;
      });
      errorDialog(context,
          title: "Error",
          message: APIController.errorMessage(e, context),
          primaryButtonText: "Ok", onPrimaryPress: () {
        Navigator.of(context).pop();
      });
    });
  }

  // Function to manually order for a pickup
  _orderForPickup(BuildContext context, int binID) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    await APIController().orderPickup(binID: binID).then(
        (Response<dynamic> response) async {
      setState(() {
        _isProcessing = false;
      });
      Navigator.of(context).pop();
      successDialog(context,
          title: "Order Success",
          message: APIController.successMessage(response));
    }, onError: (e) {
      setState(() {
        _isProcessing = false;
      });

      // Display error message if any
      Future(errorDialog(context,
          title: "Error",
          message: APIController.errorMessage(e, context),
          primaryButtonText: "Ok", onPrimaryPress: () {
        Navigator.of(context).pop();
      }));
    });
  }
}
