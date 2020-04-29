import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:meet_queue_volunteer/bloc/bloc.dart';
import 'package:meet_queue_volunteer/response/api_response.dart';
import 'package:meet_queue_volunteer/response/login_otp_response.dart';
import 'package:meet_queue_volunteer/response/login_response.dart';
import 'package:meet_queue_volunteer/services/login_repository.dart';

import '../helper.dart';


class LoginBloc extends ChangeNotifier implements Bloc {
  
  bool isLoading = false;
  bool hasLoggedIn = false, otpRequested = false;

  String errorMsg = "", msg = "";
  
  LoginRepository _loginRepository;

  StreamController _loginController;
  StreamController _otpController;

  StreamSink<ApiResponse<LoginResponse>> get loginSink =>
      _loginController.sink;

  Stream<ApiResponse<LoginResponse>> get loginStream =>
      _loginController.stream;

  StreamSink<ApiResponse<LoginOtpResponse>> get otpSink =>
      _otpController.sink;

  Stream<ApiResponse<LoginOtpResponse>> get otpStream =>
      _otpController.stream;

  LoginBloc() {
    _loginController = StreamController<ApiResponse<LoginResponse>>();
    _otpController = StreamController<ApiResponse<LoginOtpResponse>>();
    _loginRepository = LoginRepository();
  }

  loginOtp(KioskPhone kioskPhone, String otp) async {
    // loginSink.add(ApiResponse.loading('Attempting to login'));
    try {
      LoginResponse loginResult = await _loginRepository.loginOtp(kioskPhone, otp);
      if (loginResult.status == 200) {
        hasLoggedIn = true;
        msg = loginResult.message;
        Helper().setAuthToken(loginResult.loginData?.accessToken);

        // Reset other fields
        otpRequested = false;
        errorMsg = "";
      }
      // loginSink.add(ApiResponse.completed(loginResult));      
    } catch (e) {
      // loginSink.add(ApiResponse.error(e.toString()));
      reset();
      errorMsg = e.toString();
      print(e);
    } finally {
      notifyListeners();
    }
  }

  requestOtp(KioskPhone kioskPhone) async {
    // otpSink.add(ApiResponse.loading('Requesting for OTP'));
    try {
      LoginOtpResponse otpResponse = await _loginRepository.requestOtp(kioskPhone);
      if (otpResponse.status == 200) {
        otpRequested = true;
        msg = otpResponse.message;

        // Reset other fields
        hasLoggedIn = false;
        errorMsg = "";
      }
      // otpSink.add(ApiResponse.completed(otpResponse));
    } catch (e) {
      // otpSink.add(ApiResponse.error(e.toString()));
      reset();
      errorMsg = e.toString();
      print(e);
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    otpRequested = false;
    msg = "";
    hasLoggedIn = false;
    errorMsg = "";
  }

  @override
  void dispose() {
    super.dispose();
    _loginController?.close();
    _otpController?.close();
  }
}