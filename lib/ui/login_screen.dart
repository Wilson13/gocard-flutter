
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perks_card/bloc/login_bloc.dart';
import 'package:perks_card/response/authenticate_response.dart';
import 'package:perks_card/ui/home_screen.dart';
import 'package:perks_card/ui/picture_screen.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../helper.dart';


class LoginScreen extends StatefulWidget {

  static const routeName = '/login';

  LoginScreen();

  @override
  State<StatefulWidget> createState() => new _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{

  final _formKey = new GlobalKey<FormState>();
  String _phone;
  var _photoPath;

  // LoginBloc loginBloc;

  void authenticate() {
    
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => authenticate(context));
  }
  

  @override
  Widget build(BuildContext context) {
    // If take photo, photoPath should not be null
    _photoPath = ModalRoute.of(context).settings.arguments;
    return new Scaffold(
      body: Center(child: showForm())
    );
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Container(        
        padding: EdgeInsets.fromLTRB(60, 70.0, 60, 0.0),
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 200.0, 40.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Phone Number',
            ),
        validator: (value) => value.isEmpty ? 'Phone can\'t be empty' : null,
        onSaved: (value) => _phone = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return 
      Consumer<LoginBloc>(builder: (context, bloc, child) {
        return 
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            child:
              RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0)),
                  color: PURPLE_BUTTON,
                  child: 
                    Container(padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    alignment: Alignment.center,
                      child:
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white, 
                            fontFamily: 'SourceSansPro',
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600
                          )
                        )
                    ),
                  onPressed: validateAndSubmit,
                )
          );
        // return new Padding(
        //     padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        //     child: SizedBox(
        //       height: 40.0,
        //       child: new RaisedButton(
        //         elevation: 5.0,
        //         shape: new RoundedRectangleBorder(
        //             borderRadius: new BorderRadius.circular(30.0)),
        //         color: Colors.blue,
        //         child: new Text('Authenticate',
        //             style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        //         onPressed: validateAndSubmit,
        //       ),
        // ));
      });
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

void photoCallBack (photoPath) {
  _photoPath = photoPath;
}
 // Request OTP or perform login
void validateAndSubmit() async {
  if (validateAndSave()) {
    if (_photoPath == null) {
      // Camera preview for taking a photo
      _photoPath = await Navigator.pushNamed(context, PictureScreen.routeName);
      try {
        AuthenticateResponse response = await Provider.of<LoginBloc>(context, listen: false).authenticateFace(_phone, _photoPath);
        if (response.faceMatches.length > 0)
          Helper().setUsername(response.faceMatches[0].face.externalImageId);
        _photoPath = await Navigator.pushNamed(context, HomeScreen.routeName);
      } catch(err) {
        _photoPath = null;
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
            showPrimaryButton(),
          ],
        ),
    )));
  }
}