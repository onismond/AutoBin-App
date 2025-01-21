import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:zuba/controllers/pref_controller.dart';
import 'package:autobin/screens/auth/login.dart';

class APIController {
  late Dio _dio;
  late Options _options;

  // api url
  final String _url = "https://autobin-ucc-40b2bf6f03bc.herokuapp.com/api/v1";

  // id of the logged in user
  late int _userId;

  APIController() {
    _dio = new Dio();
  }

  // decodes data from string to json (Map)
  static decodeMapData(Response response) {
    return response.data['data'];
  }

  // decodes data from string to json (List)
  static List decodeListData(Response response) {
    return decodeMapData(response);
  }

  // accepts response and returns message
  static successMessage(Response response) {
    return response.data['detail'];
  }

  // decodes data using methods above and returns the message column for success or error responses from the api
  static errorMessage(DioException e, BuildContext context) {
    print(e.response?.data);
    String message = e.response != null
        ? e.response?.data
        : "No connectivity. Please check your internet connection and try again.";
    int statusCode = e.response != null ? 0 : 0;

    // if response code is unauthenticated or unauthorized
    bool isUnauthorizedOrUnAuthenticated =
        statusCode == 401 || statusCode == 403;

    return isUnauthorizedOrUnAuthenticated
        ?
        // redirect to login page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()))
        : message;
  }

  // retrieve token and user id
  _setTokenHeaderAndUserId() async {
    // String token = await PrefController.getToken();
    // _userId = await PrefController.getId();
    String token = "";
    _userId = 1;
    // assign token
    _options = Options(headers: {"Authorization": "Bearer $token"});
  }


  // login method
  Future<Response<dynamic>> login({String? email, var password}) async {
    return await _dio.post("$_url/user/login/",
        data: {"email": email, "password": password});
  }

  // register method
  Future<Response<dynamic>> register(
      {String? title,
        String? firstName,
        String? lastName,
        String? otherName,
        String? telephone,
        String? address,
        String? email,
        var password}) async {
    return await _dio.post("$_url/user/register/", data: {
      "title": title,
      "first_name": firstName,
      "last_name": lastName,
      "other_name": otherName,
      "telephone": telephone,
      "address": address,
      "email": email,
      "password": password
    });
  }

  // retrieve owner's bins
  // @return Response
  Future<Response<dynamic>> ownerBins() async {
    await _setTokenHeaderAndUserId();
    return await _dio.get("$_url/bins/");
    // return await _dio.get("$_url/bins/", options: _options);
  }

  // manual request for pick up
  Future<Response<dynamic>> orderPickup({required int binID}) async {
    return await _dio
        .post("$_url/bin/order-pickup/", data: {"bin_id": binID});
  }

  Future<Response<dynamic>> addBin({
    required String qrValue,
    required String binName,
    required String binColor,
    required String latitude,
    required String longitude,
  }) async {
    return await _dio.post("$_url/bin/add/", data: {
      'qr_value': qrValue,
      'bin_name': binName,
      'bin_color': binColor,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<Response<dynamic>> binDetails({
    required String binId,
  }) async {
    return await _dio.post("$_url/bin/detail/", data: {
      'bin_id': binId,
    });
  }
}
