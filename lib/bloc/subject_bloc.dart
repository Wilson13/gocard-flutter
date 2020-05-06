import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/response/case_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';

class SubjectBloc {

  CaseData caseData;
  String errorMsg, msg;
  bool whatsappCall;
  CaseResponse caseResponse;
  TextEditingController subjectController, languageController, descriptionController;

  UserRepository _userRepository;

  SubjectBloc({    
    @required this.caseData,
    @required this.subjectController, 
    @required this.languageController, 
    @required this.descriptionController
    }) {
      _userRepository = UserRepository();
      errorMsg = "";
      msg = "";
    }

  // Save controllers' values into caseData instance
  // void saveUserData() {
  //   caseData.postalCode = int.parse(subjectController.text);
  //   caseData.blockHseNo = languageController.text;
  //   caseData.floorNo = descriptionController.text;
  // }

}