import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:autobin/data/services/api_controller.dart';
import 'package:autobin/utils/constants.dart';
import 'package:autobin/widgets/customWidgets.dart';
import 'package:autobin/widgets/waste_bin.dart';
import 'package:autobin/utils/screensize.dart';
import 'package:autobin/data/models/bin_model.dart';

class BinDetails extends StatefulWidget {
  final Bin binObject;

  BinDetails({super.key, required this.binObject});

  @override
  State<BinDetails> createState() => _BinDetailsState();
}

class _BinDetailsState extends State<BinDetails> {
  double binValue = 0.0;
  String binWeight = '';
  // Keeps track of the order process
  bool _isProcessing = false;
  RefreshController _refreshController =  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    binValue = 0.4;
    _levelCalculator();
    binValue = _levelCalculator();
    binWeight = _weightConvertor(double.parse("${widget.binObject.currentWeight}"));
  }

  void _onRefresh() async{
    await APIController().binDetails(
        binId: widget.binObject.binID.toString(),
    ).then(
      (Response<dynamic> response) async {
        setState(() {
          widget.binObject.currentLevel = response.data['current_level'];
          binValue = _levelCalculator();
        });
        _refreshController.refreshCompleted();
      },
      onError: (e) {
        _refreshController.refreshFailed();
      }
    );
    _refreshController.refreshFailed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bin Details'),
      ),
      body: SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          enableTwoLevel: false,
          header: WaterDropMaterialHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: Container(
            color: Colors.grey.withOpacity(.05),
            width: double.infinity,
            height: screenHeight(context, dividedBy: 1.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 25, left: 0),
                  //   child: Row(
                  //     children: <Widget>[
                  //       IconButton(
                  //           icon: Icon(Icons.arrow_back),
                  //           onPressed: () => Navigator.pop(context)),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: <Widget>[
                  //           Text("Bin Details",
                  //               style: TextStyle(
                  //                   fontSize: 23,
                  //                   fontWeight: FontWeight.w600,
                  //                   color: fHeader)),
                  //           SizedBox(height: 5),
                  //           Text(
                  //             'Details of the selected bin.',
                  //             style: TextStyle(
                  //               color: Colors.black54,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  // main content
                  Center(
                    child: Column(
                      children: <Widget>[
                        // head card
                        Container(
                          height: screenHeight(context, dividedBy: 9.0),
                          width: screenWidth(context, dividedBy: 1.2),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [gStart, gEnd]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 15,
                                    color: cardShadow2.withOpacity(0.2)),
                              ]),
                          child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0.0, 20, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // upper card
                                  Text(
                                    '${widget.binObject.nickName}',
                                    style: TextStyle(
                                      color: fBright,
                                      fontSize: 26.0,
                                    ),
                                  ),
                                  SizedBox(
                                      height: screenHeight(context,
                                          dividedBy: 100.0)),
                                  RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              color: fBright, fontSize: 16),
                                          children: [
                                        TextSpan(text: "Serial no: "),
                                        TextSpan(
                                          text:
                                              '${widget.binObject.serialNumber}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )
                                      ])),
                                ],
                              )),
                        ),
                        // details pane
                        Container(
                          width: screenWidth(context, dividedBy: 1.36),
                          height: screenHeight(context, dividedBy: 8.6),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 5,
                                    color: Colors.black.withOpacity(0.1)),
                              ]),
                          child: Stack(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: fDark, fontSize: 16),
                                            children: [
                                          TextSpan(text: "Current level: "),
                                          TextSpan(
                                              text:
                                                  '${((binValue * 100).toInt()).toString()}%', //binValue is converted to an
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500))
                                        ])),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: fDark, fontSize: 16),
                                            children: [
                                          TextSpan(text: "Current weight: "),
                                          TextSpan(
                                              text: '${binWeight}kg',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500))
                                        ])),
                                    // RichText(
                                    //     text: TextSpan(
                                    //         style: TextStyle(
                                    //             color: fDark, fontSize: 16),
                                    //         children: [
                                    //       TextSpan(text: "Smoke notification: "),
                                    //       TextSpan(
                                    //           text:
                                    //               '${widget.binObject.smokeNotification}',
                                    //           style: TextStyle(
                                    //               fontWeight: FontWeight.w500))
                                    //     ])),
                                  ]),
                            )
                          ]),
                        ),
                        SizedBox(height: 30.0),
                        // bin quantity section
                        WasteBinWidget(
                          fillLevel: binValue, // 65% filled
                          width: 160,
                          height: 250,
                        ),
                        // Container(
                        //   width: screenWidth(context, dividedBy: 1.2),
                        //   height: screenHeight(context, dividedBy: 2.6),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: Center(
                        //       child: Padding(
                        //     padding: const EdgeInsets.all(30.0),
                        //     child: Stack(children: <Widget>[
                        //       LiquidCircularProgressIndicator(
                        //         value: binValue, // Defaults to 0.5.
                        //         valueColor: AlwaysStoppedAnimation(gStart.withOpacity(
                        //             binValue)), // Defaults to the current Theme's accentColor.
                        //         backgroundColor: Colors.grey.withOpacity(
                        //             .05), // Defaults to the current Theme's backgroundColor.
                        //         borderColor: Colors.grey,
                        //         borderWidth: 0.30,
                        //         direction: Axis
                        //             .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        //       ),
                        //       LiquidCircularProgressIndicator(
                        //         value: binValue - .01, // Defaults to 0.5.
                        //         valueColor: AlwaysStoppedAnimation(Colors.white
                        //             .withOpacity(
                        //                 .3)), // Defaults to the current Theme's accentColor.
                        //         backgroundColor: Colors
                        //             .transparent, // Defaults to the current Theme's backgroundColor.
                        //         borderColor: Colors.transparent,
                        //         borderWidth: 0.30,
                        //         direction: Axis
                        //             .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        //         center: Text(
                        //             '${((binValue * 100).toInt()).toString()}%',
                        //             style: TextStyle(
                        //                 fontSize: 50,
                        //                 color: Colors.black.withOpacity(0.90))),
                        //       ),
                        //     ]),
                        //   )),
                        // ),
                        SizedBox(height: 25.0),
                        CustomButton(
                            width: screenWidth(context, dividedBy: 1.211),
                            height: 60.0,
                            buttonChild: Text(
                              'Order Pickup',
                              style: TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                            buttonType: ButtonType.successButton,
                            onPressed: () {
                              int.parse("${widget.binObject.currentLevel}") < 1
                                  ? errorDialog(context,
                                      title: "Not Allowed",
                                      message: "This bin is still empty",
                                      primaryButtonText: "Ok",
                                      onPrimaryPress: () {
                                      Navigator.of(context).pop();
                                    })
                                  : defaultDialog(context,
                                      title: 'Order Pickup',
                                      message:
                                          'Do you want to order a pickup for "${widget.binObject.nickName}" (${widget.binObject.serialNumber})',
                                      primaryButtonText: "Yes",
                                      onPrimaryPress: () {
                                        _orderForPickup(
                                            context, widget.binObject.binID);
                                        Navigator.of(context).pop();
                                      },
                                      secondaryButtonText: 'Cancel',
                                      onSecondaryPress: () {
                                        Navigator.of(context).pop();
                                      });
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to translate the bin level to display in the app
  _levelCalculator() {
    return int.parse("${widget.binObject.currentLevel}") / 100;
  }

  _weightConvertor(double weight) {
    weight = weight / 1000;
    return weight.toStringAsFixed(2);
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
