import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meet_queue_volunteer/response/app_exceptions.dart';

import 'constants.dart';
import 'helper.dart';

class ApiBaseHelper {
  
  final String _baseUrl = "https://api.queue.freshturfengineering.com/";
  final Helper helper = new Helper();

  Future<dynamic> get(String url) async {
      var responseJson;
      try {
        final response = await http.get(_baseUrl + url);
        responseJson = _returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
      var responseJson;
      var reqBody = json.encode(body);
      String token = await helper.getAuthToken();
      
      try {
        final response = await http.post(
          _baseUrl + url, 
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: reqBody
        );
        responseJson = _returnResponse(response);

        // If user is unauthorised or jwt expired, remove saved token. 
        if (responseJson == ERROR_UNAUTHORISED) {
          await helper.setAuthToken("");
          throw UnauthorisedException(ERROR_UNAUTHORISED);
        }
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      return responseJson;
  }

  dynamic _returnResponse(http.Response response) {    
    switch (response.statusCode) {
      case 200:
        log("200");
        log(response.body.toString());
        // return json.decode(
        return json.decode(response.body.toString());
        break;
      case 400:
        String message = json.decode(response.body)["message"];
        message = message == null ? "" : message;
        throw AppException(message);
      case 401:
      case 403:
        // Only this is returned instead of thrown to trigger token clearing process
        return ERROR_UNAUTHORISED;
        break;
      case 404:
        throw NotFoundException(json.decode(response.body)["message"]);
      case 409:
        String message = json.decode(response.body)["message"];
        message = message == null ? "" : message;
        throw ConflictException(message);
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
    
  }
}