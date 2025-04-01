import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:autobin/data/services/api_controller.dart';
import 'package:autobin/data/services/pref_controller.dart';
// import 'package:flutter/rendering.dart';
import 'package:autobin/utils/constants.dart';
import 'package:autobin/widgets/customWidgets.dart';
import 'package:autobin/utils/drawings.dart';
import 'package:autobin/utils/input_validations.dart';
import 'package:autobin/utils/screensize.dart';
import 'package:autobin/screens/home/home_shell.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Form builder key
  final _formKey = GlobalKey<FormState>();

  // Keeps track of the login process
  bool _isProcessing = false;

  // Form inputs
  String _title = '';
  String _fName = '';
  String _lName = '';
  String _oName = '';
  var _phone = '';
  String _email = '';
  var _rAddress = '';
  var _password = '';
  var _password2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bColor1,
      body: SafeArea(
        child: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Container(
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

                        // Main Content.start
                        Container(
                          height: screenHeight(context, dividedBy: 1),
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 60.0),
                                child: Image.asset(
                                  'assets/images/bin-logo-s.png',
                                  width: 160.0,
                                ),
                              ),
                              SizedBox(
                                  height: screenHeight(context, dividedBy: 23)),
                              Expanded(
                                child: Container(
                                  width: screenWidth(context, dividedBy: 1.4),
                                  child: SingleChildScrollView(
                                    child: Form(
                                      key: _formKey,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            DropdownButton(
                                              dropdownColor: Colors.white,
                                              iconEnabledColor: Colors.black87,
                                              hint: _title == ''
                                                  ? Text(
                                                      'Select a title',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black26),
                                                    )
                                                  : Text(
                                                      _title,
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                              isExpanded: true,
                                              iconSize: 30.0,
                                              style: TextStyle(
                                                color: Colors.black87,
                                              ),
                                              items:
                                                  ['Mr.', 'Mrs.', 'Miss.'].map(
                                                (val) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: val,
                                                    child: Text(val),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (val) {
                                                setState(
                                                  () {
                                                    _title = val!;
                                                  },
                                                );
                                              },
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                setState(() => _fName = value);
                                              },
                                              validator: textOnlyValidation,
                                              decoration: customInput.copyWith(
                                                  hintText: 'First name'),
                                            ),
                                            SizedBox(
                                              height: 12.7,
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                setState(() => _lName = value);
                                              },
                                              validator: textOnlyValidation,
                                              decoration: customInput.copyWith(
                                                hintText: 'Last name',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12.7,
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                setState(() => _oName = value);
                                              },
                                              validator: textOnlyValidation2,
                                              decoration: customInput.copyWith(
                                                hintText: 'Other name',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12.7,
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                setState(() => _phone = value);
                                              },
                                              validator: numOnlyValidation,
                                              decoration: customInput.copyWith(
                                                  hintText: 'Phone'),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            SizedBox(
                                              height: 12.7,
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                setState(() => _email = value);
                                              },
                                              validator: emailValidation,
                                              decoration: customInput.copyWith(
                                                  hintText: 'Email'),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                            ),
                                            SizedBox(
                                              height: 12.7,
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                setState(
                                                    () => _rAddress = value);
                                              },
                                              validator: requiredValidation,
                                              decoration: customInput.copyWith(
                                                hintText: 'Residencial Address',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12.7,
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                setState(
                                                    () => _password = value);
                                              },
                                              validator: passLenValidation,
                                              decoration: customInput.copyWith(
                                                hintText: 'Password',
                                              ),
                                              obscureText: true,
                                            ),
                                            SizedBox(
                                              height: 12.7,
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                setState(
                                                    () => _password2 = value);
                                              },
                                              validator: (val) =>
                                                  passMatch.validateMatch(
                                                      _password, _password2),
                                              decoration: customInput.copyWith(
                                                hintText: 'Confirm Password',
                                              ),
                                              obscureText: true,
                                            ),
                                            SizedBox(
                                              height: 12.7,
                                            ),
                                            // Button
                                            CustomButton(
                                                buttonType:
                                                    ButtonType.defaultButton,
                                                width: screenWidth(context,
                                                    dividedBy: 1.211,
                                                    minus: 42.0),
                                                height: null,
                                                buttonChild: _isProcessing
                                                    ? loadingSpinner
                                                    : Text(
                                                        'SIGN UP',
                                                        style: TextStyle(
                                                          fontSize: 22.0,
                                                        ),
                                                      ),
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      !.validate()) {
                                                    _submitDataToApi(
                                                        context,
                                                        _title,
                                                        _fName,
                                                        _lName,
                                                        _oName,
                                                        _phone,
                                                        _rAddress,
                                                        _email,
                                                        _password);
                                                  }
                                                }),
                                            SizedBox(
                                              height: 13.0,
                                            ),
                                            Center(
                                                child: RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            'Already have an accound? Tap '),
                                                    TextSpan(
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () =>
                                                                Navigator.pop(
                                                                    context),
                                                      text: 'HERE',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                    ),
                                                    TextSpan(
                                                        text: ' to sign in.')
                                                  ],
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: fBright,
                                                      letterSpacing: 0.2)),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                        // Main Content.end
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
        top: true,
        bottom: false,
      ),
    );
  }

  void _submitDataToApi(
      BuildContext context,
      String title,
      String fName,
      String lName,
      String oName,
      String phone,
      String rAddress,
      String email,
      String password) async {
    // if a register process is already ongoing, exit
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    await APIController()
        .register(
            title: title,
            firstName: fName,
            lastName: lName,
            otherName: oName,
            telephone: phone,
            address: rAddress,
            email: email,
            password: password)
        .then((Response<dynamic> response) async {
      // Decode the data
      Map<String, dynamic> data = APIController.decodeMapData(response);

      // Save details to device
      // await PrefController.saveUserDetails(data);

      setState(() {
        _isProcessing = false;
      });

      // Navigate to Dashboard
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeShell()),
          (Route<dynamic> route) => false);
    }, onError: (e) {
      // DioError

      setState(() {
        _isProcessing = false;
      });

      // Display error notification if any
      Future(errorDialog(context,
          title: "Error",
          message: APIController.errorMessage(e, context),
          primaryButtonText: "Ok", onPrimaryPress: () {
        Navigator.of(context).pop();
      }));
    });
  }
}
