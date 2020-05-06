
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meet_queue_volunteer/bloc/subject_bloc.dart';
import 'package:meet_queue_volunteer/response/case_response.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/ui/photo_screen.dart';
import 'package:provider/provider.dart';
import 'package:meet_queue_volunteer/helper.dart';

import '../constants.dart';

class SubjectScreen extends StatefulWidget {

  static const routeName = '/subject';

  SubjectScreen();

  @override
  State<StatefulWidget> createState() => new _SubjectScreen();
}
  
class _SubjectScreen extends State<SubjectScreen>{

  final TextEditingController _subjectController = new TextEditingController();
  final TextEditingController _languageController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  bool _allowedWhatsapp = false;
  // final String token;
  final RegExp postalExp = new RegExp(
    r"^\d{6}$",
    caseSensitive: false,
    multiLine: false,
  );

  final _formKey = GlobalKey<FormState>();
  CaseData caseData;
  // String selectedValue;

  final Helper helper = new Helper();

  String selectedValue;

  void updateControllers() {
    if (caseData != null) {
    _subjectController.text = caseData.subject;
    _languageController.text = caseData.language;
    _descriptionController.text = caseData.description;
    _allowedWhatsapp = caseData.whatsappCall;
    }
    _phoneController.text = "12345678";
  }

  @override
  void initState() {
    super.initState();
    // Update controllers values after build is done.
    // Not updated in build to avoid values getting updated on every change.
    // This is put in initState so it's only called once.
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => updateControllers());
    }
  }

  @override
  Widget build(BuildContext context) {
      
    // Extract the arguments from the current ModalRoute settings and cast
    // them as UserData.
    caseData = ModalRoute.of(context).settings.arguments;

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Center(child: SingleChildScrollView(
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
    return Provider<SubjectBloc>(
      create: (context) => SubjectBloc(
        caseData: caseData,
        subjectController: _subjectController,
        languageController: _languageController,
        descriptionController: _descriptionController,
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          // Header
          Row(children: <Widget>[
            SizedBox(width: 180),
            // Progress
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                drawHeader("Personal Information", BLACK_HEADER_DISABLED),
                drawHeader("Address", BLACK_HEADER_HIGHLIGHT),
                drawHeader("Photo", BLACK_HEADER_DISABLED),
                drawHeader("Subject", BLACK_HEADER_DISABLED),            
              ]
            )), 
            // Cancel button
            SizedBox(width: 180, child: drawCancelButton(context))
          ]),
          // Content column with four rows inside
          // Expanded(child: // Disable this if centered is required
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 60, top: 64, right: 60, bottom: 0),
              child: 
                Row(
                  children: <Widget> [
                  // Back button
                  showNavigationButton(true),
                  // Left input fields
                  Expanded(flex: 1, child: firstRow()),
                  SizedBox(width: 45),
                  // Right input fields
                  Expanded(flex: 1, child: secondRow()),
                  // Next button
                  showNavigationButton(false)
                ]),
            )
        ]
    ));
  }

  Widget drawHeader(String name, Color color) {
    return 
      Center(
        child: 
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
            child: Text(
              name,
              style: TextStyle(
                color: color, 
                fontFamily: 'Circular Std',
                fontSize: 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400
              ),
    )));
  }

  OutlineInputBorder textFieldDecoration() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: BLUE_INPUT_BORDER, width: 1),
    );
  } 

  Widget firstRow() {
    return Container(width: double.infinity, // Match parent
        padding: const EdgeInsets.only(left: 60, top: 0, right: 0, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            showLabel('Subject'),
            showPostalInput('Education', _subjectController, true),
            SizedBox(height: 50),
            showLabel('Brief Description'),
            showMultilineInput('', _descriptionController, true, 8),
            // showOccupationDropDown(),
            showMsg(),
    ]));
  }

  Widget secondRow() {
    return Container(width: double.infinity, // Match parent
        padding: const EdgeInsets.only(left: 0, top: 0, right: 60, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            showLabel('Prefered contact language'),
            showCommonInput('Hokkien', _languageController, true, true),
            SizedBox(height: 50),
            showLabel('Contact Number'),
            showCommonInput('12345678', _phoneController, false, false),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text("Receive audio/video calls on WhatsApp"),
              value: _allowedWhatsapp,
              onChanged: (value) {
                setState((){
                _allowedWhatsapp = value;
              });
              } ,
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            ),
            SizedBox(height: 92),
    ]));
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

  // Input that doesn't need to use UserBloc, hence no need for rebuild, 
  // controllers will help update the text value.
  Widget showCommonInput(String hint, TextEditingController controller, bool isRequired, bool enabled) {
    return 
      Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: TextFormField(
            controller: controller,
            maxLines: 1,
            autofocus: false,
            enabled: enabled,
            decoration: new InputDecoration(
              hintText: hint,
              enabledBorder: textFieldDecoration(),
              focusedBorder: textFieldDecoration(),
              border: textFieldDecoration(),
              errorBorder: textFieldDecoration(),
              disabledBorder: textFieldDecoration(),
            ),
            validator: (value) {
              if (isRequired && value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (value) => controller.text = value,
      ));
  }

  Widget showMultilineInput(String hint, TextEditingController controller, bool isRequired, int maxLine) {
    return 
      Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: TextFormField(
            controller: controller,
            maxLines: maxLine,
            maxLength: 280,
            autofocus: false,
            decoration: new InputDecoration(
              hintText: hint,
              enabledBorder: textFieldDecoration(),
              focusedBorder: textFieldDecoration(),
              border: textFieldDecoration(),
              errorBorder: textFieldDecoration(),
              disabledBorder: InputBorder.none,
            ),
            validator: (value) {
              if (isRequired && value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (value) => controller.text = value,
      ));
  }

  Widget showPostalInput(String hint, TextEditingController controller, bool isRequired) {
    return 
      Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: TextFormField(
            controller: controller,
            maxLines: 1,
            autofocus: false,
            decoration: new InputDecoration(
              hintText: hint,
              enabledBorder: textFieldDecoration(),
              focusedBorder: textFieldDecoration(),
              border: textFieldDecoration(),
              errorBorder: textFieldDecoration(),
              disabledBorder: InputBorder.none,
            ),
            validator: (value) {
              if (isRequired && !postalExp.hasMatch(value)) {
                return 'Postal code has to be 6-digit.';
              }
              return null;
            },
            onSaved: (value) => controller.text = value,
      ));
  }

  
  
  Widget showDropDownButton(String hint, List<String> items, TextEditingController controller) {
    return DropdownButtonFormField<String>(
            value: [""].contains(controller.text) ? items[0] : items[1],
            hint: new Text(hint,
              textAlign: TextAlign.center),
            isExpanded: true,
            items: items.map((String value) {
              return new DropdownMenuItem<String>(
                child: new Text(value),
                value: value
              );
            }).toList(),
            validator: (value) => value == null ? 'field required' : null,
            onChanged: (value) =>controller.text = value,
          );
  }

  Widget showNavigationButton(bool isBack) {
    IconData iconData = isBack ? Icons.arrow_back_ios : Icons.arrow_forward_ios;

    return Consumer<SubjectBloc>(builder: (context, subjectBloc, child) {
      return Container(
        decoration: 
          BoxDecoration(
            color: BLUE_ICON_BUTTON,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        child: 
          IconButton(
            icon: Icon(iconData, color: Colors.white),
            onPressed: () async {
              // Next button
              if (!isBack) {
                // No error with inputs
                if (_formKey.currentState.validate()) {
                  if (subjectBloc.caseResponse == null) {

                  }
                  // try {
                  // If the form is valid and uid exists, update user.
                  // if (!(["", null, false, 0]).contains(SubjectBloc.userData.uid)) {
                  //   _formKey.currentState.save();
                  //   updateOrCreateResponse = await SubjectBloc.updateUser();
                  // } 
                  // // If the form is valid and uid doesn't exist, create user.
                  // else {
                  //   updateOrCreateResponse = await SubjectBloc.createUser();
                  // }

                  // Display response
                  // if (updateOrCreateResponse == null)
                  //     helper.displayToast(ERROR_NULL_RESPONSE);
                  //   else {
                  //     helper.displayToast(updateOrCreateResponse.message);
                  //     Navigator.of(context).pushNamedAndRemoveUntil(PhotoScreen.routeName, (Route<dynamic> route) => false);
                  //   }
                  // } catch(e) {
                  //     // If error is unauthorised
                  //     if (e.toString() == ERROR_UNAUTHORISED)
                  //       navigateToRoot();
                  //   }
                }
              } 
              // Back button
              else {
                Navigator.pop(context);
              }
            })
      );
    });
  }

  Widget showMsg() {
    return 
      Consumer<SubjectBloc>(
        builder: (context, userBloc, child) {

          if (userBloc.msg != "User not found.")
            helper.displayToast(userBloc.msg);
          if (userBloc.errorMsg != "" && userBloc.errorMsg != "User not found.")
            helper.displayToast(userBloc.errorMsg);
          
          return Container();
      });
    }

  Widget drawCancelButton(context) {
    return
      Container(padding: const EdgeInsets.only(left: 0, top: 0, right: 60, bottom: 0),
          alignment: Alignment.centerRight,
          child: 
            IconButton(
              icon: Image(image: AssetImage('assets/images/cancel.png'), color: Colors.red),
              onPressed: () {
                navigateToRoot();
              }),
      );
  }

  void navigateToRoot() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  void dispose() {
      super.dispose();
        _subjectController.dispose();
        _languageController.dispose();
        _descriptionController.dispose();
    } 
  }

  
