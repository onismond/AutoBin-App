import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:autobin/utils/constants.dart';
import 'package:autobin/screens/home/dashboard/dashboard.dart';
import 'package:autobin/screens/home/pickups/pickups.dart';
import 'package:autobin/screens/home/transactions/transactions.dart';
import 'package:autobin/screens/home/settings/settings.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final GlobalKey _fancyBottomNavigatorKey = GlobalKey();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_currentPageIndex),
      bottomNavigationBar: FancyBottomNavigation(
        initialSelection: _currentPageIndex,
        tabs: [
          TabData(iconData: Icons.home_rounded, title: "Home"),
          TabData(iconData: Icons.drive_eta_rounded, title: "Pickups"),
          TabData(iconData: Icons.payment_rounded, title: "Transactions"),
          TabData(iconData: Icons.settings_rounded, title: "Settings"),
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
      case 1:
        return Pickups();
      case 2:
        return Transactions();
      case 3:
        return Settings();
    }
    return DashBoard();
  }
}
