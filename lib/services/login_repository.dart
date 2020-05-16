import 'dart:io';

import 'package:perks_card/response/authenticate_response.dart';

import '../api_base_helper.dart';

class LoginRepository {
  // final String baseUrl = 'https://api.queue.freshturfengineering.com/';
  ApiBaseHelper _apiHelper = ApiBaseHelper();

  Future<AuthenticateResponse> authenticatePhoto({String phone, File photo}) async{
    if (!(["", null].contains(phone))) {
      try {
      final response = await _apiHelper.authenticatePhoto("face/" + phone, photo);
      return AuthenticateResponse.fromJson(response);
      } catch(err) {
        throw Exception(err.toString());
      }
    } else {
      throw Exception('Phone can\'t be null.');
    }
  }
}