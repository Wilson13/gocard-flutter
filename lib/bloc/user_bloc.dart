import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';

import '../constants.dart';

class UserBloc extends ChangeNotifier {

  UserData user;
  bool isLoading;
  String errorMsg, msg;
  TextEditingController dobController;

  UserRepository _userRepository;

  UserBloc() {
    _userRepository = UserRepository();
    isLoading = false;
    errorMsg = "";
    msg = "";
    dobController = new TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  }

  // Return a future so UI can handle unauthorised situation
  Future<UserResponse> searchUser(String nric) async {
    try {
      UserResponse userResponse = await _userRepository.searchUser(nric);
      user = userResponse.data;
      dobController.text = (user.dob == null) ? "" : DateFormat('dd-MM-yyyy').format(user.dob);
      return userResponse;
    } catch (e) {
      // Throw ERROR_UNAUTHORISED for UI to handle navigation, other errors
      // are simply just displayed.
      if (e.toString() == ERROR_UNAUTHORISED)
        throw ERROR_UNAUTHORISED;
      else 
        errorMsg = e.toString();
      print(e);
      return null;
    } finally {
      notifyListeners();
    }
  }
}