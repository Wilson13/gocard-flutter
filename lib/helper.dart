

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'constants.dart' as Constants;

class Helper {

  Future<String> getAuthToken() async {
    final storage = new FlutterSecureStorage();

    // Read value 
    // return null;
    return await storage.read(key: Constants.AUTH_KEY);
    
  }

  Future<void> setAuthToken(String value) async {
    final storage = new FlutterSecureStorage();

    // Read value 
    return await storage.write(key: Constants.AUTH_KEY, value: value);
  }

  void displayToast(String message) {
    if (!(["", null, false, 0].contains(message))) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void userUnauthenticated(context) {
    // Remove all routes and redirect user to root page
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}