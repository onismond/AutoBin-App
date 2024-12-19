import 'package:flutter/material.dart';

class Bin {
  late int binID;
  late String nickName;
  late String serialNumber;
  late var currentLevel;
  var currentWeight;
  late String smokeNotification;

  Bin(
      {required this.binID,
      required this.nickName,
      required this.serialNumber,
      required this.currentLevel,
      required this.currentWeight,
      required this.smokeNotification});

  Bin.fromMap(obj) {
    binID = obj['id'];
    nickName = obj['name'];
    serialNumber = obj['serial_number'];
    currentLevel = obj['current_level'];
    currentWeight = obj['current_weight'];
    smokeNotification = 'smoke notification';
  }
}
