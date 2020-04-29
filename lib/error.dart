import 'dart:convert';

Error errorFromJson(String str) => Error.fromJson(json.decode(str));

String errorToJson(Error data) => json.encode(data.toJson());

class Error {
    int status;
    String message;

    Error({
        this.status,
        this.message,
    });

    factory Error.fromJson(Map<String, dynamic> json) => Error(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}