import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:autobin/data/services/pref_controller.dart';
import 'package:autobin/data/services/api_controller.dart';
import 'package:autobin/utils/constants.dart';
import 'package:autobin/widgets/customWidgets.dart';
import 'package:autobin/utils/screensize.dart';
import 'package:autobin/data/models/bin_model.dart';
import 'package:autobin/data/models/pickup_model.dart';
import 'package:autobin/data/models/transaction_model.dart';
import 'package:autobin/screens/home/dashboard/bin_details/bin_details.dart';
import 'package:autobin/screens/home/dashboard/add_bin/scan_bin_qr.dart';
import 'package:autobin/screens/home/dashboard/payment/payment_details.dart';
import 'package:autobin/widgets/pickup_card.dart';
import 'package:autobin/widgets/transaction_card.dart';


class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
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
            // Positioned(
            //   bottom: 0.0,
            //   left: 0.0,
            //   right: 0.0,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         colors: [
            //           Color.fromARGB(200, 0, 0, 0),
            //           Color.fromARGB(0, 0, 0, 0)
            //         ],
            //         begin: Alignment.bottomCenter,
            //         end: Alignment.topCenter,
            //       ),
            //     ),
            //     padding: EdgeInsets.symmetric(
            //         vertical: 10.0, horizontal: 20.0),
            //     child: Text(
            //       'No. ${imgList.indexOf(item)} image',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 20.0,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        )),
  ),
)).toList();

class _DashBoardState extends State<DashBoard> {
  String fName = '';
  String residenceAddress = '';

  List<Bin> _bins = [];
  List<Pickup> _pickups = [];
  List<Transaction> _transactions = [];

  // var pickup = DateTime.parse('2024-12-17 13:04:27.000000'); // last pickup time
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
                color: Colors.blue.withOpacity(0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        "Welcome back!",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Onismond Yao Duame",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.blue.shade700
                        ),
                      ),
                      SizedBox(height: 10,)
                    ],
                  ),
                  Icon(
                    Icons.account_circle_rounded,
                    size: 70,
                    color: Colors.blue[300],
                  )
                ],),
              ),
              Container(
                height: 100,
                width: double.infinity,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.8),
                      Colors.blue.withOpacity(0.7),
                      Colors.blue.withOpacity(0.6)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Amount Due:",
                          style: TextStyle(fontSize: 15,color: Colors.white)
                        ),
                        Text(
                          "GHS 25.00",
                          style: TextStyle(fontSize: 26, color: Colors.white)
                        )
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentDetails(amount: "25.00")
                            )
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      child: Text(
                        'Details',
                        style: TextStyle(color: Colors.blue)
                      )
                    )
                  ],
                ),
              ),
              Column(children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: CarouselSlider(
                    items: imageSliders,
                    carouselController: _controller,
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        enableInfiniteScroll: true,
                        enlargeFactor: 0.2,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: imgList.asMap().entries.map((entry) {
                  //     return GestureDetector(
                  //       onTap: () => _controller.animateToPage(entry.key),
                  //       child: Container(
                  //         width: 12.0,
                  //         height: 12.0,
                  //         margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  //         decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: (Theme.of(context).brightness == Brightness.dark
                  //                 ? Colors.white
                  //                 : Colors.black)
                  //                 .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
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
              SizedBox(height: 10),
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
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
        final pickup = _pickups[index];
        return PickupCard(
          amount: pickup.amount.toString(),
          binName: pickup.bin_name,
          dateOrdered: pickup.date,
          onTap: () {
            print("Tapped on pickup ${pickup.bin_name}");
          },
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
        final transaction = _transactions[index];
        return TransactionCard(
          id: transaction.id.toString(),
          date: transaction.date,
          amount: transaction.amount.toString(),
          cleared: transaction.cleared,
          onTap: () {
            print("Tapped on transaction ${transaction.id}");
          },
        );
      }),
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

    await APIController().home().then((Response<dynamic> response) async {
      List<Bin> binList = [];
      List<Pickup> pickupList = [];
      List<Transaction> transactionList = [];

      List binData = response.data['bins'];
      List pickupData = response.data['pickups'];
      List transactionData = response.data['transactions'];

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

