
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/response/photo_get_response.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';

import '../constants.dart';

class PhotoBloc with ChangeNotifier {

  UserData userData;
  String errorMsg, msg;
  String photoPath;
  String photoURL; //if photo exists on cloud
  bool isLocal;
  // TextEditingController postalController, blkHseController, floorController, unitController, addressController, flatController;

  UserRepository _userRepository;

  PhotoBloc({@required this.userData}) {
    _userRepository = new UserRepository();
    isLocal = false;
  }

  Future<void> setPath(String path) async {
    photoPath = path;
    isLocal = true;
    notifyListeners();
  }

  Future<void> discardPhoto() async {
    if (photoPath != null) {
      File photo = new File(photoPath);
      photo.deleteSync();
    }
    photoPath = null;
    photoURL = null;
    notifyListeners();
  }

  void getUserPhoto() async {
    try {
      
      PhotoGetResponse photoGetResponse = await _userRepository.getUserPhoto(userData.uid);
      photoURL = photoGetResponse.data.url;
      // Save uid into userData so the states are correct even if user navigate back and forth.
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