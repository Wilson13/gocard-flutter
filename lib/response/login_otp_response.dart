// To parse this JSON otpData, do
//
//     final loginOtpResponse = loginOtpResponseFromJson(jsonString);

import 'dart:convert';

LoginOtpResponse loginOtpResponseFromJson(String str) => LoginOtpResponse.fromJson(json.decode(str));

String loginOtpResponseToJson(LoginOtpResponse otpData) => json.encode(otpData.toJson());

class LoginOtpResponse {
    int status;
    String message;
    dynamic otpData;

    LoginOtpResponse({
        this.status,
        this.message,
        this.otpData,
    });

    factory LoginOtpResponse.fromJson(Map<String, dynamic> json) => LoginOtpResponse(
        status: json["status"],
        message: json["message"],
        otpData: json["otpData"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "otpData": otpData,
    };
}

class KioskPhone {

  String countryCode;
  String number;

  KioskPhone({
    this.countryCode,
    this.number,
  });

  KioskPhone.instantiate(this.countryCode, this.number);

  factory KioskPhone.fromJson(Map<String, dynamic> json) => KioskPhone(
        countryCode: json["countryCode"],
        number: json["number"],
    );

    Map<String, dynamic> toJson() => {
        "countryCode": countryCode,
        "number": number,
    };
}
