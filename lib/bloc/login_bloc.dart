import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meet_queue_volunteer/response/login_otp_response.dart';
import 'package:meet_queue_volunteer/services/login_repository.dart';

import '../helper.dart';

class LoginBloc extends ChangeNotifier {
  
  // bool isLoading = false;
  bool hasLoggedIn = false, otpRequested = false;

  String errorMsg = "", msg = "";
  Helper _helper;
  LoginRepository _loginRepository;

  LoginBloc() {
    _loginRepository = LoginRepository();
    _helper = new Helper();
  }

  loginOtp(KioskPhone kioskPhone, String otp, TextEditingController locationController) async {
      _helper.setLocation(locationController.text);
      return await _loginRepository.loginOtp(kioskPhone, otp);
  }

  Future<LoginOtpResponse> requestOtp(KioskPhone kioskPhone) async {
      return await _loginRepository.requestOtp(kioskPhone);
  }

  void reset() {
    hasLoggedIn = false;
  }
}