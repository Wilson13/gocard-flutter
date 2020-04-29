// To parse this JSON LoginData, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse loginData) => json.encode(loginData.toJson());

class LoginResponse {
    int status;
    String message;
    LoginData loginData;

    LoginResponse({
        this.status,
        this.message,
        this.loginData,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        message: json["message"],
        loginData: LoginData.fromJson(json["data"]),
    );

  bool get accessToken => null;

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": loginData.toJson(),
    };
}

class LoginData {
    String redirectUri;
    String accessToken;

    LoginData({
        this.redirectUri,
        this.accessToken,
    });

    factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        redirectUri: json["redirectUri"],
        accessToken: json["accessToken"],
    );

    Map<String, dynamic> toJson() => {
        "redirectUri": redirectUri,
        "accessToken": accessToken,
    };
}
