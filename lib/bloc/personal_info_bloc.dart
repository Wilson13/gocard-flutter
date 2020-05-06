import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';

import '../constants.dart';

class PersonalInfoBloc {

  UserData userData;
  String errorMsg, msg;
  TextEditingController nricController, nameController, dobController, genderController, raceController, occupationController, phoneController, maritalController, numChildController;

  UserRepository _userRepository;

  PersonalInfoBloc({
    @required this.nricController, 
    @required this.nameController, 
    @required this.dobController, 
    @required this.genderController, 
    @required this.raceController, 
    @required this.occupationController,
    @required this.phoneController,
    @required this.maritalController,
    @required this.numChildController}) {
    userData = new UserData();
    _userRepository = UserRepository();
    errorMsg = "";
    msg = "";
  }

  // Return a future so UI can handle unauthorised situation
  Future<UserResponse> searchUser(String nric) async {
    try {
      UserResponse userResponse = await _userRepository.searchUser(nric);
      userData = userResponse.data;
      updateContollers();
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

  // Update controllers values from userData instance
  void updateContollers() {
    nricController.text = userData.nric;
    nameController.text = userData.name;
    dobController.text = userData.dob == null ? "" : DateFormat(DATE_FORMAT).format(userData.dob);
    genderController.text = userData.gender == null ? "" : userData.gender;
    raceController.text = userData.race == null ? "" : userData.race;
    occupationController.text = userData.occupation == null ? "" : userData.occupation;
    phoneController.text = userData.phone == null ? "" : userData.phone;
    maritalController.text = userData.maritalStatus == null ? "" : userData.maritalStatus;
    numChildController.text = userData.noOfChildren == null ? "" : userData.noOfChildren.toString();
  }

  // Save controllers' values into userData instance
  void saveUserData() {
    userData.nric = nricController.text;
    userData.name = nameController.text;
    userData.dob = DateFormat(DATE_FORMAT).parse(dobController.text);
    userData.gender = genderController.text;
    userData.race = raceController.text;
    userData.occupation = occupationController.text;
    userData.phone = phoneController.text;
    userData.maritalStatus = maritalController.text;
    userData.noOfChildren = isEmpty(numChildController.text) ? null : int.parse(numChildController.text);
  }

  bool isEmpty(String value) {
    return ["", null].contains((value)) ? true : false;
  }

}