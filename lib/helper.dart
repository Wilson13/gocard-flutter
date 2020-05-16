

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart' as Constants;
import 'constants.dart';

enum Headers {PERSONAL_INFO, ADDRESS, PHOTO, SUBJECT, SUMMARY}

class Helper {

  Future<String> getUsername() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERNAME_KEY);
  }

  Future<void> setUsername(String username) async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(USERNAME_KEY, username);
  }

  Future<String> getAuthToken() async {
    final storage = new FlutterSecureStorage();

    // Read value 
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

}