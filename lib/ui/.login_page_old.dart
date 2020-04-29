import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meet_queue_volunteer/bloc/login_bloc.dart';
import 'package:meet_queue_volunteer/response/login_otp_response.dart';

import 'package:meet_queue_volunteer/services/user_repository.dart';

import '../helper.dart';

class LoginSignupPage extends StatefulWidget {

LoginSignupPage({this.loginCallback});

final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();

}

class _LoginSignupPageState extends State<LoginSignupPage>{

  UserRepository userRepository = new UserRepository();

  final _formKey = new GlobalKey<FormState>();
  String _phone, _otp;
  String _errorMessage;

  bool _isLoading = false;
  bool _isOtp = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:  
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            showForm(),
            showCircularProgress(),
        ],
    ));
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Container(
      height: 0.0,
      width: 0.0,
    ));
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/flutter-icon.png'),
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
        validator: (value) => value.isEmpty && !_isOtp ? 'OTP can\'t be empty' : null,
        onSaved: (value) => _otp = value.trim(),
      ),
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
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            'Request OTP',
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300)),
        onPressed: validatePhone);
  }

  // Widget getUserList() {
  //   return FutureBuilder<List<User>>(
  //     future: userRepository.getUsers(),
  //     builder: (context, snapshot) {
  //         print(snapshot.data.toString());
  //         return Text('${snapshot.data.toString()}');
  //   });
  // }

  void validatePhone() {
    setState(() {
      _isOtp = true;
    });

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

 // Perform login or signup
void validateAndSubmit() async {
  setState(() {
    _errorMessage = "";
    _isLoading = true;
  });

  if (validateAndSave()) {

    // Request OTP
    if (_isOtp) {
      
      LoginBloc _loginBloc = new LoginBloc();  
      await _loginBloc.requestOtp(new KioskPhone.instantiate("65", _phone));
      _loginBloc.otpStream.listen((res) {
        
      setState(() {
        _isLoading = false;
        _isOtp = false;
      });

      // Not using snackbar because can't adjust its width
      if (res.data?.status == 200)
        showToast(res.data?.message);
      else {
        setState(() {
          _errorMessage = res.message;
        });
      }
      });
    } 
    // Attempt to login
    else {
      LoginBloc _loginBloc = new LoginBloc();  
      await _loginBloc.loginOtp(new KioskPhone.instantiate("65", _phone), _otp);
      _loginBloc.loginStream.listen((res) {
        
      setState(() {
        _isLoading = false;
        _isOtp = false;
      });

      if (res.data?.status == 200) {
        // Logged in successfully
        if (res.data?.loginData?.accessToken != null) {
          new Helper().setAuthToken(res.data?.loginData?.accessToken);
          widget.loginCallback();
        }
        else {
          setState(() {
          _errorMessage = "Access token not found.";
        });
        }
      }
      else {
        setState(() {
          _errorMessage = res.message;
        });
      }
      });
    }
  } else {
    setState(() {
      _isLoading = false;
  });
  }
}

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }
  
  void requestForOtp() {
    resetForm();
  }

  Widget showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return 
        new Align(
          alignment: Alignment.center,
          child:
            new Text(
              _errorMessage,
              style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.red,
                  height: 1.0,
                  fontWeight: FontWeight.w300),
            ));
    } else {
      return new Container(
        height: 0.0,
      );
    }
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
            showPrimaryButton(),
            showSecondaryButton(),
            showErrorMessage(),
          ],
        ),
      )));
}
}