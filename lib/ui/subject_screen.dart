
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meet_queue_volunteer/bloc/subject_bloc.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/ui/photo_screen.dart';
import 'package:meet_queue_volunteer/ui/summary_screen.dart';
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

  final _formKey = GlobalKey<FormState>();
  Map<String, Object> passSubjectData;
  UserData _userData;
  PhotoModel _photoModel;
  bool _enableWhatsApp = false;

  final Helper helper = new Helper();

  final TextEditingController _subjectController = new TextEditingController();
  final TextEditingController _languageController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  // final String token;
  final RegExp postalExp = new RegExp(
    r"^\d{6}$",
    caseSensitive: false,
    multiLine: false,
  );

  void updateControllers() {
    _phoneController.text = _userData.phone;
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
    // caseData = ModalRoute.of(context).settings.arguments;
    final Map<String, Object> receivedData = ModalRoute.of(context).settings.arguments;
    _userData = receivedData["userData"];
    _photoModel = receivedData["photoModel"];

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
                drawHeader("Personal Information", HEADER_DISABLED),
                drawHeader("Address", HEADER_DISABLED),
                drawHeader("Photo", HEADER_DISABLED),
                drawHeader("Subject", HEADER_HIGHLIGHT),
                drawHeader("Summary", HEADER_DISABLED),            
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
              value: _enableWhatsApp,
              onChanged: (value) {
                setState((){
                _enableWhatsApp = value;
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
              enabledBorder: helper.textFieldDecoration(),
              focusedBorder: helper.textFieldDecoration(),
              border: helper.textFieldDecoration(),
              errorBorder: helper.textFieldDecoration(),
              disabledBorder: helper.textFieldDecoration(),
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
              enabledBorder: helper.textFieldDecoration(),
              focusedBorder: helper.textFieldDecoration(),
              border: helper.textFieldDecoration(),
              errorBorder: helper.textFieldDecoration(),
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
              enabledBorder: helper.textFieldDecoration(),
              focusedBorder: helper.textFieldDecoration(),
              border: helper.textFieldDecoration(),
              errorBorder: helper.textFieldDecoration(),
              disabledBorder: InputBorder.none,
            ),
            validator: (value) {
              if (isRequired && value.isEmpty) {
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
                  // Pass both CaseData and UserData to summary page
                  SubjectBloc subjectBloc = Provider.of<SubjectBloc>(context, listen: false);
                  subjectBloc.saveCaseData(_enableWhatsApp);
                  passSubjectData = { 
                    "userData": _userData, // no need to store UserData in SubjectBloc as it doesn't get changed in this screen
                    "caseData": Provider.of<SubjectBloc>(context, listen: false).caseData,
                    "photoModel": _photoModel
                  };
                  Navigator.pushNamed(
                    context, 
                    SummaryScreen.routeName, 
                    arguments: passSubjectData
                  );
                }
              } else {
                // Instead of popping, push PhotoScreen so camera can be initialized and disposed properly.
                // Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context, 
                  PhotoScreen.routeName, 
                  arguments: _userData);
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

  
