import 'package:flutter/foundation.dart';
import 'package:meet_queue_volunteer/response/login_otp_response.dart';
import 'package:meet_queue_volunteer/response/login_response.dart';
import 'package:meet_queue_volunteer/services/login_repository.dart';

import '../helper.dart';


class LoginBloc extends ChangeNotifier {
  
  bool isLoading = false;
  bool hasLoggedIn = false, otpRequested = false;

  String errorMsg = "", msg = "";
  
  LoginRepository _loginRepository;

  LoginBloc() {
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
            
    } catch (e) {
      reset();
      errorMsg = e.toString();
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<LoginOtpResponse> requestOtp(KioskPhone kioskPhone) async {
      return await _loginRepository.requestOtp(kioskPhone);
  }

  void reset() {
    otpRequested = false;
    msg = "";
    hasLoggedIn = false;
    errorMsg = "";
  }
}