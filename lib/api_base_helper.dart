import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:perks_card/response/app_exceptions.dart';
import 'package:path/path.dart';
import 'constants.dart';
import 'helper.dart';

class ApiBaseHelper {
  
  final String _baseUrl = "https://api.queue.freshturfengineering.com/";
  final String _authUrl = "https://staging.auth.freshturfengineering.com/";
  final Helper helper = new Helper();

  Future<dynamic> authenticatePhoto(String url, File file) async {
      var stream = new http.ByteStream(Stream.castFrom(file.openRead()));
      var length = await file.length();
      var uri = Uri.parse(_authUrl + url);
      var responseJson;
      Map<String, String> headers = {
          'Content-Type': 'multipart/form-data',
      };
      
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('image', stream, length,
          filename: basename(file.path));
          // contentType: new MediaType('image', 'jpg'));
      
      request.headers.addAll(headers);
      request.files.add(multipartFile);
      try {

        final StreamedResponse streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        responseJson = _returnResponse(response);

        // If user is unauthorised or jwt expired, remove saved token. 
        if (responseJson == ERROR_UNAUTHORISED) {
          await helper.setAuthToken("");
          throw UnauthorisedException(ERROR_UNAUTHORISED);
        }
      }
      on SocketException {
        throw FetchDataException('No Internet connection');
      } catch (err) {
        throw Exception(err);
      }
      return responseJson;
  }

  Future<dynamic> get(String url) async {
      var responseJson;
      String token = await helper.getAuthToken();
      try {
        final response = await http.get(_baseUrl + url,
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
        responseJson = _returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      return responseJson;
  }

  Future<dynamic> getBasicAuth(String url, String username, String password) async {
      var responseJson;
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
      // print(basicAuth);
      try {
        final response = await http.get(url,
        headers: <String, String>{'authorization': basicAuth});
        responseJson = _returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      return responseJson;
  }

  Future<dynamic> postBasicAuth(String url, String amount, String username, String password) async {
      var responseJson;
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
      Map<String, String> reqBody = {
        "type": "TRANSFER",
          "amount": amount,
          "notes": "Transfer to Expenses Account",
          "toSavingsAccount": M_ADDITIONAL_SAVINGS_ACC,
          "method":"bank"
      };

      try {
        final response = await http.post(url,
          headers: <String, String>{'authorization': basicAuth},
          body: reqBody
        );
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

  Future<dynamic> postFile(String url, File file) async {
      var stream = new http.ByteStream(Stream.castFrom(file.openRead()));
      var length = await file.length();
      var uri = Uri.parse(_baseUrl + url);
      var responseJson;
      String token = await helper.getAuthToken();
      Map<String, String> headers = {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          };
      
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('image', stream, length,
          filename: basename(file.path));
          // contentType: new MediaType('image', 'jpg'));

      
      request.headers.addAll(headers);
      request.files.add(multipartFile);
      try {

        final StreamedResponse streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        responseJson = _returnResponse(response);

        // If user is unauthorised or jwt expired, remove saved token. 
        if (responseJson == ERROR_UNAUTHORISED) {
          await helper.setAuthToken("");
          throw UnauthorisedException(ERROR_UNAUTHORISED);
        }
      }
      on SocketException {
        throw FetchDataException('No Internet connection');
      } catch (err) {
        throw err;
      }
      return responseJson;
  }

  Future<dynamic> patch(String url, dynamic body) async {
      var responseJson;
      var reqBody = json.encode(body);
      String token = await helper.getAuthToken();
      
      try {
        final response = await http.patch(
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
      case 201:
        return json.decode(response.body.toString());
        break;
      case 400:
        String message = json.decode(response.body)["message"];
        message = message == null ? "" : message;
        throw AppException(message);
      case 401:
      case 403:
        throw Exception('Unauthorised');
        break;
      case 404:
        throw NotFoundException(json.decode(response.body)["returnStatus"]);
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