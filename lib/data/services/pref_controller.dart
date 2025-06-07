import 'package:shared_preferences/shared_preferences.dart';

class PrefController {
  //save logged in user details to prefs
  static saveUserDetails(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', data['user']['id']);
    prefs.setString('name', data['user']['name']);
    prefs.setString('email', data['user']['email']);
    prefs.setString('contact', data['user']['contact']);
    prefs.setString('avatar', data['user']['avatar'] ?? '');
    prefs.setString('token', data['token']);
  }


  static getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id') ?? 0;
  }

  static getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? "";
  }

  static getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? "";
  }

  static getContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('contact') ?? "";
  }

  static getAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('avatar') ?? "";
  }

  static getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? "";
  }

  //clears logged in user data from
  static clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('contact');
    prefs.remove('avatar');
    prefs.remove('token');
  }
}
