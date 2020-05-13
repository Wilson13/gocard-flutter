import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/response/case_response.dart';
import 'package:meet_queue_volunteer/response/photo_upload_response.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';

import '../constants.dart';

class SummaryBloc {

  UserRepository _userRepository;
  UserData userData;
  CaseData caseData;
  String errorMsg, msg;
  Map<String, dynamic> response;
  bool enableWhatsApp;
  CaseResponse caseResponse;
  TextEditingController subjectController, languageController, descriptionController;

  SummaryBloc({    
    @required this.userData, 
    @required this.caseData, 
    }) {
      _userRepository = new UserRepository();
      errorMsg = "";
      msg = "";
    }

  // Save controllers' values into caseData instance
  Future<CaseResponse> createCase() async {
    try {
      CaseResponse caseResponse = await _userRepository.createCase(userData: userData, caseData: caseData);
      // Save uid into userData so the states are correct even if user navigate back and forth.
      // userData.uid = userResponse.data.uid;
      return caseResponse;
    } catch (e) {
      // Throw ERROR_UNAUTHORISED for UI to handle navigation, other errors
      // are simply just displayed.
      if (e.toString() == ERROR_UNAUTHORISED)
        throw ERROR_UNAUTHORISED;
      else 
        errorMsg = e.toString();
      return null;
    }
  }

  Future<PhotoUploadResponse> uploadUserPhoto(String photoPath) async {
    if (await File(photoPath).exists()) {
      try {
        File photo = File(photoPath);
        PhotoUploadResponse photoUploadResponse = await _userRepository.uploadPhoto(uid: userData.uid, photo: photo);
        // Save uid into userData so the states are correct even if user navigate back and forth.
        // userData.uid = userResponse.data.uid;
        return photoUploadResponse;
      } catch (e) {
        // Throw ERROR_UNAUTHORISED for UI to handle navigation, other errors
        // are simply just displayed.
        if (e.toString() == ERROR_UNAUTHORISED)
          throw ERROR_UNAUTHORISED;
        else 
          errorMsg = e.toString();
        return null;
      }
    } else {
      return null;
    }
  }

}