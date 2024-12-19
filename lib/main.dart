import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autobin/screens/auth/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
//            primaryColor: Colors.white,
            fontFamily: 'Calibri'),
        home: SplashScreen());
  }
}
