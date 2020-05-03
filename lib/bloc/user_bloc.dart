import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';

import '../constants.dart';

class UserBloc {

  UserData user;
  String errorMsg, msg;
  TextEditingController nricController, nameController, dobController, genderController, raceController, occupationController;

  UserRepository _userRepository;

  UserBloc({@required this.nricController, 
    @required this.nameController, 
    @required this.dobController, 
    @required this.genderController, 
    @required this.raceController, 
    @required this.occupationController}) {
    user = new UserData();
    _userRepository = UserRepository();
    errorMsg = "";
    msg = "";
  }

  // Return a future so UI can handle unauthorised situation
  Future<UserResponse> searchUser(String nric) async {
    try {
      UserResponse userResponse = await _userRepository.searchUser(nric);
      user = userResponse.data;
      nricController.text = user.nric;
      nameController.text = user.name;
      dobController.text = user.dob == null ? "" : DateFormat(DATE_FORMAT).format(user.dob);
      genderController.text = user.gender == null ? "" : user.gender;
      raceController.text = user.race == null ? "" : user.race;
      occupationController.text = user.occupation == null ? "" : user.occupation;
      // notifyListeners();
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
      // notifyListeners();
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   dobController.dispose();
  // }

}