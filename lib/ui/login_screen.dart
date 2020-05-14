import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meet_queue_volunteer/bloc/login_bloc.dart';
import 'package:meet_queue_volunteer/response/login_otp_response.dart';
import 'package:meet_queue_volunteer/response/login_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';
import 'package:provider/provider.dart';
import "../extension/string_extension.dart";
import '../constants.dart';
import '../helper.dart';


class LoginScreen extends StatefulWidget {

  static const routeName = '/login';

  VoidCallback loginCallback;

  LoginScreen({@required this.loginCallback});

  @override
  State<StatefulWidget> createState() => new _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{

  UserRepository userRepository = new UserRepository();

  final _formKey = new GlobalKey<FormState>();
  String _phone, _otp;
  bool isOtp = false;
  String defaultValue = LOCATION_ANG_MO_KIO;
  TextEditingController locationController = new TextEditingController();

  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    locationController.text = LOCATION_ANG_MO_KIO;    
  }

  @override
  Widget build(BuildContext context) {

    loginBloc = Provider.of<LoginBloc>(context);
    return new Scaffold(
      body: Center(child: showForm()),
    );
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/images/flutter-icon.png'),
        ),
      ),
    );
  }

  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Phone',
            icon: new Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Phone can\'t be empty' : null,
        onSaved: (value) => _phone = value.trim(),
      ),
    );
  }

  Widget showOtpInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'OTP',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        // If value is not empty and user wasn't requesting for OTP
        validator: (value) => value.isEmpty && !isOtp ? 'OTP can\'t be empty' : null,
        onSaved: (value) => _otp = value.trim(),
      ),
    );
  }

  Widget showLocationDropDown(List<String> itemList) { 
    return  Padding(
      padding: const EdgeInsets.only(top: 15),
      child: 
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
            Icons.place,
            color: Colors.grey,
            size: 20.0,
          )),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: locationController.text,
              hint: Text('Location'),
              items: 
                itemList
                  .map((label) => DropdownMenuItem(
                        child: Text(label.capitalize()),
                        value: label,
                  ))
                  .toList(), 
              onChanged: (value) { locationController.text = value; },
          )),
      ])
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Login',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateLoginRequest,
          ),
    ));
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            'Request OTP',
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300)),
        onPressed: validateOtpRequest);
  }

  void validateOtpRequest() {
    isOtp = true;

    validateAndSubmit();
  }

  void validateLoginRequest() {
    isOtp = false;

    validateAndSubmit();
  }

// Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

 void showToast(String message) {
    if (!(["", null, false, 0].contains(message))) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
    );
  }
 }

 // Request OTP or perform login
void validateAndSubmit() async {

  if (validateAndSave()) {

    // Request OTP
    if (isOtp) {
      // For now, can't find a better way to handle api calls without try-catch in UI.
      // FutureBuilder has snapshot, but requires to return widget which is not required here.
      try {
        LoginOtpResponse otpRes = await loginBloc.requestOtp(new KioskPhone.instantiate("65", _phone));
        showToast(otpRes.message);
      } catch (err) {
        showToast(err.toString());
      }
    } else {
      try {
        // Attempt to login
        LoginResponse loginRes = await loginBloc.loginOtp(new KioskPhone.instantiate("65", _phone), _otp, locationController);
        showToast(SUCCESS_LOGIN);
        if (loginRes.status == 200) {
          // Login successfully
          new Helper().setAuthToken(loginRes.loginData.accessToken);
          widget.loginCallback();
        }
      } catch(err) {
        showToast(err.toString());
      }
    }
  }
}

  void resetForm() {
    _formKey.currentState.reset();
  }

  Widget showErrorMessage(String msg) {
    return Center(
      child: Text(
        msg,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300)
    ));
  }

  Widget showForm() {
  return new Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
        // padding: EdgeInsets.all(10),
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: 
      new Form(
        key: _formKey,
        child: 
          new Center(
          child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showLogo(),
            showPhoneInput(),
            showOtpInput(),
            showLocationDropDown(LOCATION_LIST),
            showPrimaryButton(),
            showSecondaryButton(),              
          ],
        ),
    )));
  }
}