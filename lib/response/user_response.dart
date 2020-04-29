// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
    int status;
    String message;
    UserData data;

    UserResponse({
        this.status,
        this.message,
        this.data,
    });

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        status: json["status"],
        message: json["message"],
        data: UserData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class UserData {
    String nric;
    String email;
    String name;
    String race;
    String gender;
    int noOfChildren;
    String maritalStatus;
    String occupation;
    int postalCode;
    String blockHseNo;
    String floorNo;
    String address;
    String flatType;
    String phone;
    String authServer;
    DateTime createdAt;
    String uid;

    UserData({
        this.nric,
        this.email,
        this.name,
        this.race,
        this.gender,
        this.noOfChildren,
        this.maritalStatus,
        this.occupation,
        this.postalCode,
        this.blockHseNo,
        this.floorNo,
        this.address,
        this.flatType,
        this.phone,
        this.authServer,
        this.createdAt,
        this.uid,
    });

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        nric: json["nric"],
        email: json["email"],
        name: json["name"],
        race: json["race"],
        gender: json["gender"],
        noOfChildren: json["noOfChildren"],
        maritalStatus: json["maritalStatus"],
        occupation: json["occupation"],
        postalCode: json["postalCode"],
        blockHseNo: json["blockHseNo"],
        floorNo: json["floorNo"],
        address: json["address"],
        flatType: json["flatType"],
        phone: json["phone"],
        authServer: json["authServer"],
        createdAt: DateTime.parse(json["createdAt"]),
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "nric": nric,
        "email": email,
        "name": name,
        "race": race,
        "gender": gender,
        "noOfChildren": noOfChildren,
        "maritalStatus": maritalStatus,
        "occupation": occupation,
        "postalCode": postalCode,
        "blockHseNo": blockHseNo,
        "floorNo": floorNo,
        "address": address,
        "flatType": flatType,
        "phone": phone,
        "authServer": authServer,
        "createdAt": createdAt.toIso8601String(),
        "uid": uid,
    };
}
