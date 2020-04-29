import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';

class UserBloc extends ChangeNotifier {

  UserData user;
  bool isLoading;
  String errorMsg, msg;

  UserRepository _userRepository;

  UserBloc() {
    _userRepository = UserRepository();
    isLoading = false;
    errorMsg = "";
    msg = "";
  }

  Future<UserData> searchUser(String nric) async {
    try {
      // if (nricExp.hasMatch(nric.toString().toUpperCase()))
      return _userRepository.searchUser(nric);
    } 
    catch (e) {
      errorMsg = e.toString();
      print(e);
    } finally {
      notifyListeners();
    }
    return null;
  }
}