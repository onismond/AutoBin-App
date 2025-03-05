import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:autobin/controllers/pref_controller.dart';
import 'package:autobin/controllers/api_controller.dart';
import 'package:autobin/mech/constants.dart';
import 'package:autobin/mech/customWidgets.dart';
import 'package:autobin/mech/screensize.dart';
import 'package:autobin/models/bin_model.dart';
import 'package:autobin/models/pickup_model.dart';
import 'package:autobin/models/transaction_model.dart';
import 'package:autobin/screens/home/bin-details.dart';
import 'package:autobin/screens/home/add_bin/scan_bin_qr.dart';


class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
final List<Widget> imageSliders = imgList
    .map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.network(item, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'No. ${imgList.indexOf(item)} image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )),
  ),
))
    .toList();

class _DashBoardState extends State<DashBoard> {
  String fName = '';
  String residenceAddress = '';

  List<Bin> _bins = [];
  List<Pickup> _pickups = [];
  List<Transaction> _transactions = [];

  var pickup = DateTime.parse('2024-12-17 13:04:27.000000'); // last pickup time
  var _pickedTime;

  // holds status for loading api data
  bool _isProcessing = false;

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();

    // callData();
    // _pickUpTime();
    _loadBins();
  }

  // callData() async {
  //   // fName = await PrefController.getFName();
  //   // residenceAddress = await PrefController.getRAdress();
  //   fName = "";
  //   residenceAddress = "";
  // }

  // _pickUpTime() async {
  //   final now = new DateTime.now();
  //   final difference = now.difference(pickup);
  //   final result = timeago.format(now.subtract(difference), locale: 'en');
  //   setState(() {
  //     _pickedTime = result;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "AutoBin",
      //     style: TextStyle(
      //       fontSize: 25,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right:10.0),
      //       child: IconButton(
      //         icon: Icon(Icons.notifications),
      //         onPressed: () {
      //           // Handle icon tap
      //           ScaffoldMessenger.of(context).showSnackBar(
      //             SnackBar(content: Text("Notification icon tapped")),
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      appBar: AppBar(
        title: const Text(
          "AutoBin",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Notification icon tapped")),
                    );
                  },
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Color.fromARGB(1, 245, 236, 236),
        width: double.infinity,
        height: screenHeight(context, dividedBy: 1.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.blue.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text(
                        "Welcome back!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Onismond Yao Duame",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.blue.shade700
                        ),
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),
                  Icon(
                    Icons.account_circle_rounded,
                    size: 90,
                    color: Colors.blue.shade300,
                  )
                ],),
              ),
              Column(children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: CarouselSlider(
                    items: imageSliders,
                    carouselController: _controller,
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                                  .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
              ]),
              // RichText(
              //     text: TextSpan(
              //         style: TextStyle(
              //             fontSize: 30,
              //             fontWeight: FontWeight.w600,
              //             color: fHeader),
              //         children: [
              //       TextSpan(text: "Hello "),
              //       TextSpan(text: "fName")
              //     ])),
              // SizedBox(height: 13),
              // Center(
              //   child: OverViewCard(
              //       residence: residenceAddress,
              //       numberOfBins: _bins.length,
              //       lastPickup: _pickedTime),
              // ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("My Bins",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: fHeader)),
                        OutlinedButton(
                          child: Text("Add Bin"),
                          onPressed: () => { _addBin() },
                        ),
                      ],
                    ),
                    _binListBuilder(),
                    SizedBox(height: 30.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Pending Pickups",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: fHeader)),
                      ],
                    ),
                    _pickupListBuilder(),
                    SizedBox(height: 30.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Transactions",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: fHeader)),
                        TextButton(
                          child: Text("View All"),
                          onPressed: () => { _addBin() },
                        ),
                      ],
                    ),
                    _transactionListBuilder(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _binListBuilder() {
    if (_isProcessing) {
      return Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: loadingSpinner2,
        ),
      );
    }
    if (_bins.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Icon(Icons.delete_outline, size: 80, color: Colors.black26),
            SizedBox(height: 20),
            Text(
              "There are no bins to display",
              style: TextStyle(fontSize: 20.0, color: Colors.black54),
            ),
          ],
        ),
      );
    }
    return Column(
      children: List.generate(_bins.length, (index) {
        return Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          borderOnForeground: true,
          child: InkWell(
            splashColor: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BinDetails(
                      binObject: _bins[index],
                    ),
                  )
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Icon(
                Icons.delete_sharp,
                color: Colors.blue[200],
                size: 50,
              ),
              title: Text(
                  _bins[index].nickName,
                style: TextStyle(
                  fontSize: 17
                ),
              ),
              subtitle: Text("ID: ${_bins[index].serialNumber}"),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _pickupListBuilder() {
    if (_isProcessing) {
      return Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: loadingSpinner2,
        ),
      );
    }
    if (_pickups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "There are no pending pickups",
              style: TextStyle(fontSize: 20.0, color: Colors.black54),
            ),
          ],
        ),
      );
    }
    return Column(
      children: List.generate(_pickups.length, (index) {
        return Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 10),
          borderOnForeground: true,
          child: InkWell(
            splashColor: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Icon(
                Icons.fire_truck_sharp,
                color: Colors.blue[300],
                size: 30,
              ),
              title: Text(
                "GHS ${_pickups[index].amount},  ${_pickups[index].bin_name}",
                style: TextStyle(
                  fontSize: 15
                ),
              ),
              subtitle: Text("Date Ordered: ${_pickups[index].date}"),
            ),
          ),
        );
      }),
    );
  }

  Widget _transactionListBuilder() {
    if (_isProcessing) {
      return Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: loadingSpinner2,
        ),
      );
    }
    if (_transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "There are no transactions yet",
              style: TextStyle(fontSize: 20.0, color: Colors.black54),
            ),
          ],
        ),
      );
    }
    return Column(
      children: List.generate(_transactions.length, (index) {
        return Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 10),
          borderOnForeground: true,
          child: InkWell(
            splashColor: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                  "GHS ${_transactions[index].amount}",
                style: TextStyle(
                  fontSize: 17
                ),
              ),
              subtitle: Text("ID: ${_transactions[index].id}, ${_transactions[index].date}"),
            ),
          ),
        );
      }),
    );
  }

  // Widget _binBuilder2(Bin bin) {
  //   return Card(
  //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     borderOnForeground: true,
  //     child: ListTile(
  //       leading: Image.asset('assets/images/Garbage Truck_24px.png'),
  //       title: Text(bin.nickName),
  //       subtitle: Text("Status: ${bin.serialNumber}"),
  //       trailing: Icon(Icons.arrow_forward),
  //       onTap: () {
  //         print("Tapped on bin: ${bin.nickName}");
  //       },
  //     ),
  //   );
  // }

  // _binBuilder(Bin bin) {
  //   return BinCard2(
  //     binID: bin.binID,
  //     nickName: bin.nickName,
  //     binSerial: bin.serialNumber,
  //     pickupMsg: () {
  //       int.parse(bin.currentLevel) < 1
  //           ? errorDialog(context,
  //               title: "Not Allowed",
  //               message: "This bin is still empty",
  //               primaryButtonText: "Ok", onPrimaryPress: () {
  //               Navigator.of(context).pop();
  //             })
  //           : defaultDialog(context,
  //               title: 'Order Pickup',
  //               message:
  //                   'Do you want to order a pickup for "${bin.nickName}" (${bin.serialNumber})',
  //               primaryButtonText: "Yes",
  //               onPrimaryPress: () {
  //                 _orderForPickup(context, bin.binID);
  //               },
  //               secondaryButtonText: 'Cancel',
  //               onSecondaryPress: () {
  //                 Navigator.of(context).pop();
  //               });
  //     },
  //     routTo: () {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => BinDetails(
  //               binObject: bin,
  //             ),
  //           )
  //       );
  //     },
  //   );
  // }

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

    await APIController().home().then((Response<dynamic> response) async {
      //create the bin list
      List<Bin> binList = [];
      List<Pickup> pickupList = [];
      List<Transaction> transactionList = [];

      //get the bin list with map data
      List binData = response.data['bins'];
      List pickupData = response.data['pickups'];
      List transactionData = response.data['transactions'];

      //convert the bin data map to model
      for (var bin in binData) {
        binList.add(Bin.fromMap(bin));
      }
      for (var pickup in pickupData) {
        pickupList.add(Pickup.fromMap(pickup));
      }
      for (var transaction in transactionData) {
        transactionList.add(Transaction.fromMap(transaction));
      }

      setState(() {
        _isProcessing = false;
        _bins = binList;
        _pickups = pickupList;
        _transactions = transactionList;
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

