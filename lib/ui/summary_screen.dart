
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/bloc/summary_bloc.dart';
import 'package:meet_queue_volunteer/response/case_response.dart';
import 'package:meet_queue_volunteer/response/photo_upload_response.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

import '../constants.dart';
import '../helper.dart';
import 'photo_screen.dart';
import 'root_page.dart';

class SummaryScreen extends StatefulWidget {

  static const routeName = '/summary';

  SummaryScreen();

  @override
  State<StatefulWidget> createState() => new _SummaryScreen();
}
  
class _SummaryScreen extends State<SummaryScreen>{

  SummaryBloc _summaryBloc;
  bool _enableWhatsApp = false;
  // final String token;
  final RegExp postalExp = new RegExp(
    r"^\d{6}$",
    caseSensitive: false,
    multiLine: false,
  );

  final _formKey = GlobalKey<FormState>();
  UserData userData;
  CaseData caseData;
  PhotoModel _photoModel;
  // String selectedValue;

  final Helper helper = new Helper();

  String selectedValue;

  @override
  Widget build(BuildContext context) {
      
    // Extract the arguments from the current ModalRoute settings and cast
    // them as UserData.
    final Map<String, Object> receivedData = ModalRoute.of(context).settings.arguments;
    caseData = receivedData["caseData"];
    userData = receivedData["userData"];
    _photoModel = receivedData["photoModel"];

    // Set up bloc
    _summaryBloc = SummaryBloc(
      userData: userData,
      caseData: caseData
    );

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body:
       Center(child: SingleChildScrollView(
        reverse: true,
        child: Padding(padding: EdgeInsets.only(bottom: bottom),
          child: new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              }, 
            child: Form(
              key: _formKey,
              autovalidate: false,
              child: makeBody()
            )
          )
      ))));
  }
    
  Widget makeBody() {
    return ChangeNotifierProvider<SummaryBloc>.value(value: _summaryBloc,
      child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            // Header
            helper.headers(Headers.SUMMARY, navigateToRoot),
            // Summary 
            summary(),
          ]
       )
    );
  }

  Widget summary() {
    return Padding(
      padding: EdgeInsets.only(left: 200, right: 200, top: 60),
      child:
        Column(
          children: <Widget>[
            // Multiple sections vertically
            drawSectionHeader('Title'),
            personalInfoContent(),
            drawSectionHeader('Address'),
            addressContent(),
            drawSectionHeader('Subject'),
            subjectContent(),
            completeButton(),
            backButton()
        ]));
  }
  
  Widget backButton() {
    return MaterialButton(
      padding: EdgeInsets.only(bottom: 100),
      child: Text(
        'Back',
        style: TextStyle(
          color: PURPLE_THEME, 
          fontFamily: 'SourceSansPro',
          fontSize: 22,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal
        )
      ),
      onPressed: () async {
        Navigator.pop(context);
      }
    );
  }

  Widget completeButton() {
    return Padding(
      padding: EdgeInsets.only(top: 30, bottom: 45), 
      child: 
        SizedBox(
          width: 700,
          height: 83,
          child: RaisedButton(
              shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
              color: PURPLE_THEME,
              child: Text(
                'Complete Registration',
                style: TextStyle(
                  color: Colors.white, 
                  fontFamily: 'SourceSansPro',
                  fontSize: 22,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal
                )
              ),
              onPressed: () async {
                try {
                  CaseResponse caseResponse;
                  PhotoUploadResponse photoResponse;
                  caseResponse = await _summaryBloc.createCase();

                  if (caseResponse == null)
                    // Display error response
                    helper.displayToast(ERROR_NULL_RESPONSE);
                  else {
                    // Case created
                    // Update photo if necessary
                    if (_photoModel.isLocal) {
                      photoResponse = await _summaryBloc.uploadUserPhoto(_photoModel.uri);
                    }

                    if (photoResponse != null)
                      helper.displayToast(caseResponse.message);
                    else {
                      helper.displayToast(caseResponse.message + " But there was an error uploading your photo.");
                    }
                    Navigator.popUntil(context, ModalRoute.withName(RootPage.routeName.toString()));
                  }
                } catch(e) {
                    // If error is unauthorised
                    if (e.toString() == ERROR_UNAUTHORISED)
                      navigateToRoot();
                    else 
                      helper.displayToast(e.toString());
                }
              }
    )));
  }

  Widget drawSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(45, 25, 45, 25),
      decoration: helper.summaryBoxDecoration(),
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: PURPLE_THEME, 
                fontFamily: 'Chivo',
                fontSize: 22,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal
              )),
            // TODO: No edit for now as navigation is a stack, data has to be passed back.
            // Text(
            //   'Edit',
            //   style: TextStyle(
            //     color: PURPLE_THEME, 
            //     fontFamily: 'Chivo',
            //     fontSize: 22,
            //     fontStyle: FontStyle.normal,
            //     fontWeight: FontWeight.normal
            // )),
        ],)
      );
  }

  Widget personalInfoContent() {
    // 3 row and multipler column within themselves
    Widget imageChild;
    if (!_photoModel.isLocal) 
      imageChild = CircleAvatar(backgroundImage: NetworkImage(_photoModel.uri));
    else {
      imageChild = ClipOval(child: Image.file(File(_photoModel.uri)));
    }
    return Container(
      padding: EdgeInsets.fromLTRB(45, 35, 45, 35),
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(flex:1, child: personalInfoLabelRow()),
            Expanded(flex:1, child: personalInfoContentRow()),
            Expanded(flex:1, child: 
              Container(
                alignment: Alignment.centerRight, 
                child: 
                SizedBox(
                  width: 115,
                  height: 115, 
                  child: 
                    imageChild
                ))
            )
        ])
      );
  }

  Widget addressContent() {
    // 3 row and multipler column within themselves
    return Container(
      padding: EdgeInsets.fromLTRB(45, 35, 45, 35),
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(flex: 1, child: addressLabelRow()),
            Expanded(flex: 2, child: addressContentRow()),
        ])
      );
  }

  Widget subjectContent() {
    // 2 rows
    // Using another column because brief description could be multi-line,
    // so label height has to match with it
    return Container(
      padding: EdgeInsets.fromLTRB(45, 35, 45, 35),
      child:
      Column(children: <Widget>[
        subjectRow('Subject', caseData.subject),
        subjectRow('Preferred Language', caseData.language),
        subjectRow('Brief Description', caseData.description),
        subjectRow('Contact', userData.phone),
      ]));
  }

  Widget subjectRow(String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // addressLabelRow(),//Flexible(flex: 1, child: 
        // Padding(padding: EdgeInsets.only(right: 100), child: drawLabel('Subject')),
        Flexible(flex:1, child: ConstrainedBox(
          constraints: new BoxConstraints(minWidth: 300), 
          child: drawLabel(title))),
        Expanded(flex: 2, child: drawParticulars(content)),
        // Expanded(child: subjectContentRow()),
    ]);
  }


  Widget personalInfoLabelRow() {
    return ConstrainedBox(constraints: new BoxConstraints(minWidth: 300), child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          drawLabel('Name'),
          drawLabel('NRIC'),
          drawLabel('Gender'),
          drawLabel('Race'),
          drawLabel('Date of Birth'),
          drawLabel('Occupation'),
      ])
    );
  }

  Widget addressLabelRow() {
    return ConstrainedBox(constraints: new BoxConstraints(minWidth: 300), child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          drawLabel('Postal Code'),
          drawLabel('Block/House Number'),
          drawLabel('Floor/Unit'),
          drawLabel('Street Address'),
          drawLabel('Flat Type'),
      ]));
  }

  Widget subjectLabelRow() {
    return 
    ConstrainedBox(constraints: new BoxConstraints(minWidth: 300), child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          drawLabel('Subject'),
          drawParticulars('John Wick'),
          // drawLabel('Preferred Language'),
          // drawLabel('Brief Description'),
          // drawLabel('Contact'),
      ]));
  }

  Widget personalInfoContentRow() {
    return 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          drawParticulars(userData.name),
          drawParticulars(userData.nric),
          drawParticulars(toBeginningOfSentenceCase(userData.gender)),
          drawParticulars(toBeginningOfSentenceCase(userData.race)),
          drawParticulars(DateFormat(DATE_FORMAT).format(userData.dob)),
          drawParticulars(userData.occupation),
      ]);
  }

  Widget addressContentRow() {
    String floorStr;

    if (!["", null].contains(userData.floorNo))
      floorStr = userData.floorNo + "-";

    floorStr += userData.unitNo;
    return 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          drawParticulars(userData.postalCode.toString()),
          drawParticulars(userData.blockHseNo),
          drawParticulars(floorStr),
          drawParticulars('Upper Thompson Road'),
          drawParticulars('15 / 03/ 1985'),
      ]);
  }

  Widget drawLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 35), 
      child:
        Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: GREY_SUMMARY_TEXT, 
            fontFamily: 'SourceSansPro',
            fontSize: 24,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal
      )));
  }

  Widget drawParticulars(String text) {
    return 
    Padding(
      padding: EdgeInsets.only(bottom: 35), 
      child:
        Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: BLACK_SUMMARY_TEXT, 
            fontFamily: 'SourceSansPro',
            fontSize: 24,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal
      )));
  }

  // Not using List<Widget> because
  // "This requires the 'spread-collections' experiment to be enabled."
  Widget showLabel(String name) {
    return 
      Container(width: double.infinity, // Match parent
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 15),
        child:
          Text(
            name,
            style: TextStyle(
              color: BLACK_TEXT, 
              fontFamily: 'SourceSansPro',
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal)
    ));
  }

  void navigateToRoot() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}

  
