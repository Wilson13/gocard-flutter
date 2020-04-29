import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/bloc/user_bloc.dart';
import 'package:provider/provider.dart';
import 'package:meet_queue_volunteer/helper.dart';

import '../constants.dart';

class PersonalInfo extends StatefulWidget {

  const PersonalInfo();

  @override
  State<StatefulWidget> createState() => new _PersonalInfoState();
  
}
  
class _PersonalInfoState extends State<PersonalInfo> {

  final TextEditingController _nricController = TextEditingController();
  final Helper helper = new Helper();

  // This regex is  for use when input is converted into uppsercase
  final RegExp nricExp = new RegExp(
    r"^(S|T|F|G|)[0-9]{7}[A-Z]$",
    caseSensitive: false,
    multiLine: false,
  );

  String token;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          }, 
        child: makeBody()
        )
      );
  }
  
  void showPersonalInfoPage() {
    Navigator.pushNamed(context, '/personal_info');
  }
  
  Widget makeBody() {
    return Column(
      children: <Widget> [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            drawHeader("Personal Information", BLACK_HEADER_HIGHLIGHT),
            drawHeader("Address", BLACK_HEADER_DISABLED),
            drawHeader("Subject", BLACK_HEADER_DISABLED),
            drawHeader("Photo", BLACK_HEADER_DISABLED),
          ]
        ),
        // Content column with two rows inside
        Expanded(child: 
          Container(
            // alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 180, top: 64, right: 180, bottom: 0),
            child: 
              Row(
                children: <Widget> [
                // Left row
                Expanded(flex: 1, child: firstRow()),
                SizedBox(width: 45),
                // // Right row
                Expanded(flex: 1, child: secondRow()),
              ]
          ))),
      ]
    );
  }

  Widget drawHeader(String name, Color color) {
    return 
      Center(
        child: 
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 56, right: 90, bottom: 0),
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
          Radius.circular(5.0) //                 <--- border radius here
      ),
    );
  }

  Widget firstRow() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        showLabel('NRIC'),
        showInput('S9876543A', true, _nricController),
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
              Expanded(child: showDropDownButton('Select')),
              SizedBox(width: 40),
              Expanded(child: showDropDownButton('Select')),
          ]),
        SizedBox(height: 50),
        showLabel('Occupation'),
        showDropDownButton('Select'),
        showMsg(),
    ]);
  }

  Widget secondRow() {
    return Column(
      children: <Widget>[
        showLabel('Name'),
        showInput('Your full name', false, null),
        SizedBox(height: 50),
        showLabel('NRIC'),
        showDateSelector('DD / MM / YYYY'),
    ]);
  }

  // Not using List<Widget> because
  // "This requires the 'spread-collections' experiment to be enabled."
  Widget showLabel(String name) {
    return 
      Container(width: double.infinity,
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 15),
        child:
          Text(
            name,
            style: TextStyle(
              color: BLACK_TEXT, 
              fontFamily: 'Source Sans Pro',
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal)
    ));
  }

  Widget showInput(String hint, bool checkFocus, TextEditingController controller) {
    return 
      Container(padding: const EdgeInsets.only(left: 15, top: 0, right: 0, bottom: 0),
        decoration: myBoxDecoration(),
        child:
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 0, right: 45, bottom: 0),
            child: 
            Consumer<UserBloc>(
              builder: (context, userBloc, child) {
                return Focus(
                  child: TextFormField(
                  controller: controller,
                  maxLines: 1,
                  autofocus: false,
                  initialValue: userBloc.user?.nric,
                  decoration: new InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  )),
                  onFocusChange: (focus) async {
                    // Only NRIC text form field will has checkFocus set to true and controller not set to null.
                    if (checkFocus) {
                      if (focus)
                        log("hasFocus"); 
                      else {
                        if (nricExp.hasMatch(controller.text.toUpperCase())) {
                          try{
                          await userBloc.searchUser(controller.text);
                          }catch(e) {
                            // If error is unauthorised
                            if (e.toString() == ERROR_UNAUTHORISED)
                              Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                          }
                          
                        }
                        else
                          log("Wrong NRIC format");
                      }
                    }
                  }
                );
            },
              // If value is not empty and user wasn't requesting for OTP
              // validator: (value) => value.isEmpty && !isOtp ? 'OTP can\'t be empty' : null,
              // onSaved: (value) => _otp = value.trim(),
      ))); 
  }

  Widget showDateSelector(String hint) {
    return 
      Container(padding: const EdgeInsets.only(left: 15, top: 0, right: 0, bottom: 0),
        decoration: myBoxDecoration(),
        child:
        Stack(
          alignment: Alignment.centerRight, 
          children: <Widget>[
            TextFormField(
              maxLines: 1,
              obscureText: true,
              autofocus: false,
              enabled: false,
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
            IconButton(
              icon: Icon(Icons.calendar_today, color: BLUE_ICON_BUTTON),
              onPressed: () {
                // Future<DateTime> selectedDate = 
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2018),
                  lastDate: DateTime(2030),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.dark(),
                      child: child,
                    );
                  },
                );
                // Your codes...
            }),
        ],)
          // Padding(
          //   padding: const EdgeInsets.only(left: 0, top: 0, right: 45, bottom: 0),
          //   child: 

              // If value is not empty and user wasn't requesting for OTP
              // validator: (value) => value.isEmpty && !isOtp ? 'OTP can\'t be empty' : null,
              // onSaved: (value) => _otp = value.trim(),
      ); 
  }

  Widget showDropDownButton(String hint) {
    return DropdownButton<String>(
      hint: new Text(hint,
        textAlign: TextAlign.center),
      isExpanded: true,
      items: <String>['Male', 'Female'].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }

  Widget showMsg() {
    return 
      Consumer<UserBloc>(
        builder: (context, userBloc, child) {
          helper.displayToast(userBloc.msg);
          // if (userBloc.errorMsg == ERROR_UNAUTHORISED)
          
          return Container();
      });
    }

}