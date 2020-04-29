import 'package:meet_queue_volunteer/api_base_helper.dart';
import 'package:meet_queue_volunteer/response/login_otp_response.dart';
import 'package:meet_queue_volunteer/response/login_response.dart';

class LoginRepository {
  // final String baseUrl = 'https://api.queue.freshturfengineering.com/';
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginResponse> loginOtp(KioskPhone kioskPhone, String otp) async{

    Map reqBody = {
      "kioskPhone": kioskPhone,
      "loginType": "otp",
      "otp": otp
    };

    final response = await _helper.post("kiosk/manager/authorize", reqBody);
    return LoginResponse.fromJson(response);
  }

  Future<LoginOtpResponse> requestOtp(KioskPhone kioskPhone) async{
  
    Map reqBody = {
      "kioskPhone": kioskPhone
    };

    final response = await _helper.post("kiosk/manager/otp", reqBody);
    return LoginOtpResponse.fromJson(response);
  }
}