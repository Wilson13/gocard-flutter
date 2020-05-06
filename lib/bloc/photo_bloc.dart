
import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';

class PhotoBloc with ChangeNotifier {

  UserData userData;
  String errorMsg, msg;
  String photoPath;
  // TextEditingController postalController, blkHseController, floorController, unitController, addressController, flatController;

  UserRepository _userRepository;

  PhotoBloc();

  // Return a future so UI can handle unauthorised situation
  // Future<UserResponse> updateUser() async {
  //   try {
  //     // Update data in userData instance
  //     saveUserData();
  //     UserResponse userResponse = await _userRepository.updateUser(userData);
  //     return userResponse;
  //   } catch (e) {
  //     // Throw ERROR_UNAUTHORISED for UI to handle navigation, other errors
  //     // are simply just displayed.
  //     if (e.toString() == ERROR_UNAUTHORISED)
  //       throw ERROR_UNAUTHORISED;
  //     else 
  //       errorMsg = e.toString();
  //     print(e);
  //     return null;
  //   }
  // }

  Future<void> setPath(String path) async {
    photoPath = path;
    notifyListeners();
  }

  // Future<UserResponse> createUser() async {
  //   try {
  //     // Update data in userData instance
  //     saveUserData();
  //     UserResponse userResponse = await _userRepository.createUser(userData);
  //     // Save uid into userData so the states are correct even if user navigate back and forth.
  //     userData.uid = userResponse.data.uid;
  //     return userResponse;
  //   } catch (e) {
  //     // Throw ERROR_UNAUTHORISED for UI to handle navigation, other errors
  //     // are simply just displayed.
  //     if (e.toString() == ERROR_UNAUTHORISED)
  //       throw ERROR_UNAUTHORISED;
  //     else 
  //       errorMsg = e.toString();
  //     print(e);
  //     return null;
  //   }
  // }

  // Save controllers' values into userData instance
  // void saveUserData() {
  //   userData.postalCode = int.parse(postalController.text);
  //   userData.blockHseNo = blkHseController.text;
  //   userData.floorNo = floorController.text;
  //   userData.unitNo = unitController.text;
  //   userData.address = addressController.text;
  //   userData.flatType = flatController.text;
  // }

}