import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:autobin/mech/constants.dart';
import 'package:autobin/screens/home/dashboard.dart';
import 'package:autobin/screens/home/pickups.dart';
import 'package:autobin/screens/home/settings.dart';
import 'package:autobin/screens/home/user-profile.dart';

class HomeShell extends StatefulWidget {
  @override
  _HomeShellState createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  GlobalKey _fancyBottomNavigatorKey = GlobalKey();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_currentPageIndex),
      bottomNavigationBar: FancyBottomNavigation(
        initialSelection: _currentPageIndex,
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.person_outline, title: "Profile"),
          TabData(iconData: Icons.drive_eta, title: "Pickups"),
          TabData(iconData: Icons.settings, title: "Settings"),
        ],
        onTabChangedListener: (position) {
          setState(() {
            _currentPageIndex = position;
          });
        },
        key: _fancyBottomNavigatorKey,
        circleColor: bColor1,
        inactiveIconColor: Colors.grey,
      ),
    );
  }

  Widget _getPage(pageNumber) {
    switch (pageNumber) {
      case 0:
        return DashBoard();
        break;
      case 1:
        return UserProfile();
        break;
      case 2:
        return Pickups();
        break;
      case 3:
        return Settings();
        break;
    }
    return DashBoard();
  }
}
