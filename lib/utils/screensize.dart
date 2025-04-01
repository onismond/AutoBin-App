import 'package:flutter/material.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context,
    {double dividedBy = 1, double minus = 0}) {
  return (screenSize(context).height / dividedBy) - minus;
}

double screenWidth(BuildContext context,
    {double dividedBy = 1, double minus = 0}) {
  return (screenSize(context).width / dividedBy) - minus;
}
