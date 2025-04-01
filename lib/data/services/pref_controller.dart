// import 'package:shared_preferences/shared_preferences.dart';
//
// class PrefController {
//   //save logged in user details to prefs
//   static saveUserDetails(Map<String, dynamic> data) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('title', data['title']);
//     prefs.setString('fName', data['first_name']);
//     prefs.setString('lName', data['last_name']);
//     prefs.setString('oName', data['other_name']);
//     prefs.setString('address', data['address']);
//     prefs.setString('phone', data['telephone']);
//     prefs.setString('email', data['email']);
//     prefs.setInt('id', data['id']);
//     prefs.setString('token', data['token']);
//   }
//
//   static getFName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('fName') ?? "";
//   }
//
//   static getLName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('lName') ?? "";
//   }
//
//   static getOName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('oName') ?? "";
//   }
//
//   static getRAdress() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('address') ?? "";
//   }
//
//   static getPhone() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('phone') ?? "";
//   }
//
//   static getEmail() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('email') ?? "";
//   }
//
//   static getId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('id') ?? 0;
//   }
//
//   static getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token') ?? "";
//   }
//
//   //clears logged in user data from
//   static clearUserDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('id');
//     prefs.remove('fName');
//     prefs.remove('lName');
//     prefs.remove('oName');
//     prefs.remove('address');
//     prefs.remove('phone');
//     prefs.remove('email');
//     prefs.remove('token');
//   }
// }
