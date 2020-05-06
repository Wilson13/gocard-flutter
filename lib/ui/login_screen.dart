import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meet_queue_volunteer/bloc/login_bloc.dart';
import 'package:meet_queue_volunteer/response/login_otp_response.dart';
import 'package:meet_queue_volunteer/services/user_repository.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {

LoginScreen();

  @override
  State<StatefulWidget> createState() => new _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{

  UserRepository userRepository = new UserRepository();

  final _formKey = new GlobalKey<FormState>();
  String _phone, _otp;
  bool isOtp = false;

  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    loginBloc = Provider.of<LoginBloc>(context);
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
    return ChangeNotifierProvider<LoginBloc>.value(
      value: loginBloc,
      child: Consumer<LoginBloc>(builder: (context, loginBloc, child) {
        if (loginBloc.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        else 
          return Container();
        }));

    // return Consumer<LoginBloc>(
    //   builder: (context, res, child) {
    //     if (res.isLoading) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //     return Center(
    //       child: Container(
    //       height: 0.0,
    //       width: 0.0,
    //     ));
    //   });
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

    loginBloc.isLoading = true;
    // Request OTP
    if (isOtp) {
      await loginBloc.requestOtp(new KioskPhone.instantiate("65", _phone));
      isOtp = false;
    } else {
      // Attempt to login
      await loginBloc.loginOtp(new KioskPhone.instantiate("65", _phone), _otp);
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

  Widget handleApiResponse() {
    // Using MultiProvider to handle two different streams
    return ChangeNotifierProvider<LoginBloc>.value(
      value: loginBloc,
      child: Consumer<LoginBloc>(
        builder: (context, bloc, child) {
          loginBloc.isLoading = false;

          if (loginBloc.otpRequested)
            showToast(loginBloc.msg);
          // else if (loginBloc.hasLoggedIn)
          //   widget.loginCallback();

          return showErrorMessage(bloc.errorMsg);
          
          // if (otpRes != null) {

          //   if (otpRes.status == Status.LOADING)
          //     return Center();
          //   // OTP response
          //   if (otpRes.status == Status.ERROR) {
          //     loginBloc.isLoading = false;
          //     // Show error message
          //     return showErrorMessage(otpRes.message);
          //   } else if (otpRes?.data?.status == 200) {
          //     showToast(otpRes.data?.message);
          //     return Container(); 
          //   }
          // }
          // return Container();
        }
      )
    );
    }

    // Widget handleLoginResponse() {
    // // Using MultiProvider to handle two different streams
    // return StreamProvider<ApiResponse<LoginResponse>>.value(
    //   value: loginBloc.loginStream,
    //   child: Consumer<ApiResponse<LoginResponse>>(
    //     builder: (context, loginRes, child) {
    //       if (loginRes != null) {
    //         // Login response
    //         if (loginRes.status == Status.ERROR) {
    //           loginBloc.isLoading = false;
    //           // Show error message
    //           return showErrorMessage(loginRes.message);
    //           } else if (loginRes.data?.status == 200) {
    //             // Login successfully
    //             showToast(loginRes.data?.message);
    //             new Helper().setAuthToken(loginRes.data?.loginData?.accessToken);
    //             widget.loginCallback();
    //             return Container();
    //           }
    //         }
    //       return Container();
    //     }
    //   )
    // );
    // }
    
    // return MultiProvider(
    //   providers: [
    //     StreamProvider<ApiResponse<LoginOtpResponse>>.value(
    //       value: loginBloc.otpStream),

    //     StreamProvider<ApiResponse<LoginResponse>>.value(
    //       value: loginBloc.loginStream)
    // ],
    //   child: Consumer2<ApiResponse<LoginOtpResponse>, ApiResponse<LoginResponse>>(
    //     builder: (context, otpRes, loginRes, child) { 
    //       if (otpRes != null) {
    //         // OTP response
    //         if (otpRes.status == Status.ERROR) {
    //           loginBloc.isLoading = false;
    //           // Show error message
    //           return showErrorMessage(otpRes.message, otpRes);
    //         } else if (otpRes?.data?.status == 200) {
    //           showToast(otpRes.data?.message);
    //           return Container(); 
    //         }
    //       } else if (loginRes != null) {
    //         // Login response
    //         if (loginRes.status == Status.ERROR) {
    //           loginBloc.isLoading = false;
    //           // Show error message
    //           return showErrorMessage(loginRes.message, loginRes);
    //           } else if (loginRes.data?.status == 200) {
    //             // Login successfully
    //             showToast(loginRes.data?.message);
    //             new Helper().setAuthToken(loginRes.data?.loginData?.accessToken);
    //             widget.loginCallback();
    //             return Container();
    //           }
    //         }
    //         // For all other cases just return blank container.
    //         return Container(); 
    //     })
    // );
  // }

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
            handleApiResponse(),                
          ],
        ),
    )));
  }
}