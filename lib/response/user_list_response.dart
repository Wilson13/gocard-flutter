// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

UserListResponse usersFromJson(String str) => UserListResponse.fromJson(json.decode(str));

String usersToJson(UserListResponse data) => json.encode(data.toJson());

class UserListResponse {
    int status;
    String message;
    List<User> data;

    UserListResponse({
        this.status,
        this.message,
        this.data,
    });

    factory UserListResponse.fromJson(Map<String, dynamic> json) => UserListResponse(
        status: json["status"],
        message: json["message"],
        data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class User {
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
    String address;
    String flatType;
    Phone phone;
    String authServer;
    DateTime createdAt;
    String uid;
    String floorNo;

    User({
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
        this.address,
        this.flatType,
        this.phone,
        this.authServer,
        this.createdAt,
        this.uid,
        this.floorNo,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
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
        address: json["address"],
        flatType: json["flatType"],
        phone: Phone.fromJson(json["phone"]),
        authServer: json["authServer"],
        createdAt: DateTime.parse(json["createdAt"]),
        uid: json["uid"],
        floorNo: json["floorNo"] == null ? null : json["floorNo"],
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
        "address": address,
        "flatType": flatType,
        "phone": phone.toJson(),
        "authServer": authServer,
        "createdAt": createdAt.toIso8601String(),
        "uid": uid,
        "floorNo": floorNo == null ? null : floorNo,
    };
}

class Phone {
    String id;
    String countryCode;
    String number;
    DateTime createdAt;
    int v;

    Phone({
        this.id,
        this.countryCode,
        this.number,
        this.createdAt,
        this.v,
    });

    factory Phone.fromJson(Map<String, dynamic> json) => Phone(
        id: json["_id"],
        countryCode: json["countryCode"],
        number: json["number"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "countryCode": countryCode,
        "number": number,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
    };
}
