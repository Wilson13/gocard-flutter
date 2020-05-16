import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:perks_card/response/authenticate_response.dart';
import 'package:perks_card/services/login_repository.dart';


class LoginBloc extends ChangeNotifier {
  
  // bool isLoading = false;
  bool hasLoggedIn = false, otpRequested = false;

  String errorMsg = "", msg = "";
  LoginRepository _loginRepository;

  LoginBloc() {
    _loginRepository = LoginRepository();
  }

  Future<AuthenticateResponse> authenticateFace(String phone, String photoPath) async {
    if (await File(photoPath).exists()) {
      return _loginRepository.authenticatePhoto(phone: phone, photo: File(photoPath));
    } else {
      throw Exception('Photo doesn\'t exist.');
    }
  }
}