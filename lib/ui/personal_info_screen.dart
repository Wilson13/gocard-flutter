import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/bloc/personal_info_bloc.dart';
import 'package:provider/provider.dart';
import 'package:meet_queue_volunteer/helper.dart';

import '../constants.dart';

class PersonalInfoScreen extends StatefulWidget {

  PersonalInfoScreen();

  @override
  State<StatefulWidget> createState() => new _PersonalInfo();
}
  
class _PersonalInfo extends State<PersonalInfoScreen>{

  final TextEditingController _nricController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _occupationController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _dobController = new TextEditingController(text: DateFormat(DATE_FORMAT).format(DateTime.now()));
  final TextEditingController _genderController = new TextEditingController();
  final TextEditingController _raceController = new TextEditingController();
  final TextEditingController _maritalController = new TextEditingController();
  final TextEditingController _numChildController = new TextEditingController();
  final StreamController<String> _raceStreamController = new StreamController<String>();

  // This regex is  for use when input is converted into uppsercase
  final RegExp nricExp = new RegExp(
    r"^(S|T|F|G|)[0-9]{7}[A-Z]$",
    caseSensitive: false,
    multiLine: false,
  );

  final _formKey = GlobalKey<FormState>();
  // String selectedValue;

  final Helper helper = new Helper();

  String selectedValue;

     @override
    Widget build(BuildContext context) {
        
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
    
    // void showPersonalInfoPage() {
    //   Navigator.pushNamed(context, '/personal_info');
    // }
    
    Widget makeBody() {
      return Provider<UserBloc>(
        create: (context) => UserBloc(
          nricController: _nricController,
          nameController: _nameController,
          occupationController: _occupationController,
          phoneController: _phoneController,
          dobController: _dobController,
          genderController: _genderController,
          raceController: _raceController,
          maritalController: _maritalController,
          numChildController: _numChildController
          ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          // Header
          Row(children: <Widget>[
            SizedBox(width: 180),
            // Progress
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                drawHeader("Personal Information", BLACK_HEADER_HIGHLIGHT),
                drawHeader("Address", BLACK_HEADER_DISABLED),
                drawHeader("Photo", BLACK_HEADER_DISABLED),
                drawHeader("Subject", BLACK_HEADER_DISABLED),            
              ]
            )), 
            // Cancel button
            SizedBox(width: 180, child: drawCancelButton())
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
                ]
            )),
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
  
    BoxDecoration myBoxDecoration() {
      return BoxDecoration(
        border: Border.all(
          color: BLUE_INPUT_BORDER,
          width: 1.0
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) 
        ),
      );
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              showLabel('NRIC'),
              Consumer<UserBloc>(builder: (context, personalBloc, child) {
                return showNricInput('S9876543A', true,  personalBloc.nricController);
              }),
              
              SizedBox(height: 50),
              // Gender row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: showLabel('Gender')),
                    SizedBox(width: 40),
                    Expanded(child: showLabel('Race')),
                ]),
              // Gender selection row
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: showGenderDropDown()),
                    SizedBox(width: 40),
                    Expanded(child: showRaceDropDown()),
                ]),
              SizedBox(height: 50),
              showLabel('Marital Status'),
              showDropDownButton('Select', ['single', 'married', 'divorced'], _maritalController),
              SizedBox(height: 50),
              showLabel('No. of Children'),
              showCommonInput('0', _numChildController, false),
              showMsg(),
      ]));
    }
  
    Widget secondRow() {
      return Container(width: double.infinity, // Match parent
          padding: const EdgeInsets.only(left: 0, top: 0, right: 60, bottom: 0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              showLabel('Name'),
              showCommonInput('Your full name', _nameController, true),
              SizedBox(height: 50),
              showLabel('Date of Birth'),
              showDateSelector('DD / MM / YYYY'),
              SizedBox(height: 40),
              showLabel('Occupation (NA if not applicable)'),
              showCommonInput('Occupation', _occupationController, true),
              SizedBox(height: 48),
              // showLabel(''),
              // showHiddenDropDownButton('', []),
              // Show a hidden textfield on the right and also providing
              // the same controller to ensure even after validation,
              // both rows remain aligned.
              // showHiddenDropDownButton("hint", ["test"]),
              // Consumer<PersonalInfoBloc>(builder: (context, personalBloc, child) {
              //   return showHiddenTextField(personalBloc.occupationController);
              // }),
              showLabel('Phone Number'),
              showCommonInput('1234 5678', _phoneController, true),
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
  
    // Input that doesn't need to use personalBloc, hence no need for rebuild, 
    // controllers will help update the text value.
    Widget showCommonInput(String hint, TextEditingController controller, bool isRequired) {
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
                if (isRequired && value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value) => controller.text = value,
        ));
    }
  
    Widget showNricInput(String hint, bool checkFocus, TextEditingController controller) {
      return 
        // Container(padding: const EdgeInsets.only(left: 15, top: 0, right: 0, bottom: 0),
        //   decoration: myBoxDecoration(),
        //   child:
        Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: 
          Consumer<UserBloc>(
            builder: (context, personalBloc, child) {
              return Focus(
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
                  if (!nricExp.hasMatch(value.toUpperCase())) {
                    return 'NRIC format is wrong.';
                  }
                  return null;
                },
                onSaved: (value) => controller.text = value.toUpperCase(),
                ),
                onFocusChange: (focus) async {
                  // Only NRIC text form field will has checkFocus set to true and controller not set to null.
                  if (checkFocus) {
                    if (!focus) {
                      personalBloc.nricController.text = personalBloc.nricController.text.toUpperCase();
                      if (nricExp.hasMatch(personalBloc.nricController.text)) {
                        try{
                          await personalBloc.searchUser(controller.text.toUpperCase());
                          _raceStreamController.sink.add(personalBloc.userData.race);
                          // setState(() {
                          //   selectedValue = personalBloc.user.race;
                          // });
                          FocusScope.of(context).requestFocus(FocusNode());
                        } catch(e) {
                          // If error is unauthorised
                          if (e.toString() == ERROR_UNAUTHORISED)
                            navigateToRoot();
                        }
                      }
                    }
                  }
                }
              );
          },
        ));
        // ); 
    }
  
    Widget showDateSelector(String hint) {
      return 
        Consumer<UserBloc>(
          builder: (context, personalBloc, child) {
            return Container(padding: const EdgeInsets.only(left: 15, top: 0, right: 0, bottom: 0),
              decoration: myBoxDecoration(),
              child:
              Stack(
                alignment: Alignment.centerRight, 
                children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    enabled: false,
                    controller: _dobController,
                    decoration: new InputDecoration(
                      hintText: hint,
                      icon: new Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                  )),
                  Container(
                    decoration: 
                      BoxDecoration(
                        color: BLUE_ICON_BUTTON,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    child: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                    onPressed: () async {
                      // Format date to the appropriate format
                      DateTime tempDate = ["", null].contains(personalBloc.dobController?.text) ? DateTime.now() : new DateFormat(DATE_FORMAT).parse(personalBloc.dobController?.text);
                      DateTime selectedDate = await showDatePicker(
                        context: context,
                        initialDate: tempDate,
                        firstDate: DateTime(1920),
                        lastDate: DateTime(2030),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.dark(),
                            child: child,
                          );
                        },
                      );
                      personalBloc?.dobController?.text = selectedDate == null ? DateFormat(DATE_FORMAT).format(tempDate) : DateFormat(DATE_FORMAT).format(selectedDate);
                  })),
                ],
              )
            );
      }); 
    }

    Widget showGenderDropDown() {
      return 
        Consumer<UserBloc>(
          builder: (context, personalBloc, child) {
            return showDropDownButton('Select', ['male', 'female'], personalBloc.genderController);
        });
    }
  
    Widget showRaceDropDown() {
      return 
        Consumer<UserBloc>(
          builder: (context, personalBloc, child) {
            // return showConsumerDropDownButton('Select', ['chinese', 'malay', 'indian', 'other']);
            return showDropDownButton('Select', ['chinese', 'malay', 'indian', 'other'], personalBloc.raceController);
        });
    }
  
    // Widget showOccupationDropDown() {
    //   return 
    //     Consumer<personalBloc>(
    //       builder: (context, personalBloc, child) {
    //         return showDropDownButton('Select', ['Professional', 'Other'], personalBloc.user.occupation);
    //     });
    // }
  
  // personalBloc.user?.gender == null ? null : personalBloc.user.gender,
  
  Widget showConsumerDropDownButton(String hint, List<String> items) {
      return  
        StreamBuilder<String>(
          stream: _raceStreamController.stream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // (context, personalBloc, child) {

            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
  
            // int index = items.indexOf(personalBloc.user.race);
            // if (index > -1)
            //     selectedValue = items[index];
  
            return new DropdownButtonFormField<String>(
              value: snapshot.data,//index > -1 ? items[index] : null,
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
              onChanged: (value) {
                selectedValue = value;
                _formKey.currentState.validate();
                },
            );
          });
    }
  
    Widget showDropDownButton(String hint, List<String> items, TextEditingController controller) {
      return DropdownButtonFormField<String>(
        // value: [""].contains(controller.text) ? items[0] : items[1],
        hint: new Text(hint,
          textAlign: TextAlign.center),
        isExpanded: true,
        items: items.map((String value) {
          return new DropdownMenuItem<String>(
            child: new Text(toBeginningOfSentenceCase(value)),
            value: value
          );
        }).toList(),
        validator: (value) => value == null ? 'field required' : null,
        onChanged: (value) {
          controller.text = value;
          _formKey.currentState.validate();
        },
        onSaved: (value) => controller.text = value,
      );
    }
  
    // Hacky way of ensuring left row and right row matches in height
    Widget showHiddenDropDownButton(String hint, List<String> items) {
      return Opacity(opacity: 0.0, child: new Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: 
              DropdownButton<String>(
        hint: new Text(hint,
          textAlign: TextAlign.center),
        isExpanded: true,
        items: items.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (_) {},
      )));
    }
  
    Widget showHiddenTextField(TextEditingController controller) {
      return Opacity(opacity: 1.0, child: new Padding(
                padding: const EdgeInsets.only(
                  left: 0.0,
                ),
                child: TextFormField(
                    controller: controller,
                    maxLines: 1,
                    autofocus: false,
                    decoration: new InputDecoration(
                      enabledBorder: textFieldDecoration(),
                      focusedBorder: textFieldDecoration(),
                      border: textFieldDecoration(),
                      errorBorder: textFieldDecoration(),
                      disabledBorder: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
      )));
    }
  
    Widget showNavigationButton(bool isBack) {
      IconData iconData = isBack ? Icons.arrow_back_ios : Icons.arrow_forward_ios;
      
      return 
      Consumer<UserBloc>(builder: (context, personalBloc, child) {
        return Container(
          decoration: 
            BoxDecoration(
              color: BLUE_ICON_BUTTON,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          child: 
            IconButton(
              icon: Icon(iconData, color: Colors.white),
              onPressed: () {
                if (!isBack) {
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, pass User data to next screen.
                    _formKey.currentState.save();
                    // Save data before passing to next screen
                    personalBloc.saveUserData();
                    // Show next screen along with passing the data
                    Navigator.pushNamed(
                      context,
                      '/address',
                       arguments: Provider.of<UserBloc>(context, listen: false).userData);
                  }
                } else {
                  Navigator.pop(context);
                }
              })
        );
      });
    }
  
    Widget showMsg() {
      return 
        Consumer<UserBloc>(
          builder: (context, personalBloc, child) {
            
            if (personalBloc.msg != "User not found.")
              helper.displayToast(personalBloc.msg);
            if (personalBloc.errorMsg != "" && personalBloc.errorMsg != "User not found.")
              helper.displayToast(personalBloc.errorMsg);
            
            return Container();
        });
      }
  
    Widget drawCancelButton() {
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
        _nricController.dispose();
        _nameController.dispose();
        _occupationController.dispose();
        _dobController.dispose();
        _genderController.dispose();
        _raceController.dispose();
        _raceStreamController.close();
    } 
  }

  
