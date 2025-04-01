import 'package:flutter/material.dart';
import 'package:autobin/utils/constants.dart';
import 'package:autobin/widgets/customWidgets.dart';
import 'package:autobin/utils/drawings.dart';
import 'package:autobin/utils/screensize.dart';

class PhoneVerification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bColor1,
      body: SafeArea(
        child: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        // Main Background
                        Positioned(
                          child: Container(
                            child: CustomPaint(painter: DrawCircle()),
                          ),
                        ),

                        // Mian Content.start
                        Container(
                          height: screenHeight(context, dividedBy: 1),
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 90.0),
                                child: Image.asset(
                                  'assets/images/bin-logo-s.png',
                                  width: 165.0,
                                ),
                              ),
                              SizedBox(
                                  height: screenHeight(context, dividedBy: 9)),
                              Container(
                                width: screenWidth(context, dividedBy: 1.3),
                                child: Form(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Phone Verification',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24,
                                            color: fBright,
                                            letterSpacing: 0.2)),
                                    SizedBox(
                                      height: 6.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    'A security code has been sent to '),
                                            TextSpan(text: 'xxxxxx7843'),
                                            TextSpan(text: '. '),
                                          ],
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: fBright,
                                              letterSpacing: 0.2)),
                                    ),
                                    Text(
                                        'Please enter the code below to proceed.',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: fBright,
                                            letterSpacing: 0.2)),
                                    SizedBox(
                                      height: 19.0,
                                    ),
                                    Container(
                                        width: screenWidth(context,
                                            dividedBy: 1.4),
                                        child: Column(children: <Widget>[
                                          TextFormField(
                                            decoration: customInput.copyWith(
                                                hintText: 'Enter code here'),
                                            keyboardType: TextInputType.number,
                                          ),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          // Button
                                          // RaisedButton(
                                          //   onPressed: () {},
                                          //   textColor: fBright,
                                          //   elevation: 1.3,
                                          //   highlightElevation: 2.5,
                                          //   shape: RoundedRectangleBorder(
                                          //       borderRadius:
                                          //           BorderRadius.circular(5)),
                                          //   padding: EdgeInsets.all(0.0),
                                          //   // color: Colors.blueAccent,
                                          //   child: Container(
                                          //     width: screenWidth(context,
                                          //         dividedBy: 1.3, minus: 0.0),
                                          //     decoration: BoxDecoration(
                                          //       gradient: LinearGradient(
                                          //           colors: <Color>[
                                          //             gEnd,
                                          //             gStart
                                          //           ]),
                                          //       borderRadius:
                                          //           BorderRadius.circular(5.0),
                                          //     ),
                                          //     padding: EdgeInsets.all(13.0),
                                          //     alignment: Alignment.center,
                                          //     child: Text(
                                          //       'VERIFY',
                                          //       style: TextStyle(fontSize: 24),
                                          //     ),
                                          //   ),
                                          // ),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              elevation: 1.3,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              padding: EdgeInsets.zero, // Removes padding around the button
                                              backgroundColor: Colors.transparent, // Makes button background transparent
                                              shadowColor: Colors.black, // Sets shadow color
                                            ),
                                            child: Container(
                                              width: screenWidth(context, dividedBy: 1.3, minus: 0.0),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: <Color>[gEnd, gStart],
                                                ),
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              padding: EdgeInsets.all(13.0),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'VERIFY',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: fBright, // Use the desired text color here
                                                ),
                                              ),
                                            ),
                                          ),
                                        ])),
                                    SizedBox(
                                      height: 14.0,
                                    ),
                                    Center(
                                        child: RichText(
                                      text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    'Didn\'t recieve any code? '),
                                            TextSpan(
                                              text: 'RESEND',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      TextDecoration.underline),
                                            )
                                          ],
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: fBright,
                                              letterSpacing: 0.2)),
                                    )),
                                  ],
                                )),
                              )
                            ],
                          ),
                        )
                        // Mian Content.end
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
        top: false,
        bottom: false,
      ),
    );
  }
}
