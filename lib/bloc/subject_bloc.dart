import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/response/case_response.dart';

class SubjectBloc {

  CaseData caseData;
  String errorMsg, msg;
  bool enableWhatsApp;
  CaseResponse caseResponse;
  TextEditingController subjectController, languageController, descriptionController;

  SubjectBloc({    
    @required this.subjectController, 
    @required this.languageController, 
    @required this.descriptionController, 
    }) {
      caseData = new CaseData();
      errorMsg = "";
      msg = "";
    }

  // Save controllers' values into caseData instance
  void saveCaseData(bool enableWhatsApp) {
    caseData.subject = subjectController.text;
    caseData.language = languageController.text;
    caseData.description = descriptionController.text;
    caseData.whatsappCall = enableWhatsApp;
  }

}