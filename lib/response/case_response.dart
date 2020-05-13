import 'dart:convert';

CaseResponse caseResponseFromJson(String str) => CaseResponse.fromJson(json.decode(str));

String caseResponseToJson(CaseResponse data) => json.encode(data.toJson());

class CaseResponse {
    int status;
    String message;
    CaseData data;

    CaseResponse({
        this.status,
        this.message,
        this.data,
    });

    factory CaseResponse.fromJson(Map<String, dynamic> json) => CaseResponse(
        status: json["status"],
        message: json["message"],
        data: CaseData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class CaseData {
    String status;
    bool whatsappCall;
    String id;
    String userId;
    String nric;
    String subject;
    String description;
    String language;
    String refId;
    String location;
    int queueNo;
    DateTime createdAt;
    String uid;
    int v;

    CaseData({
        this.status,
        this.whatsappCall,
        this.id,
        this.userId,
        this.nric,
        this.subject,
        this.description,
        this.language,
        this.refId,
        this.location,
        this.queueNo,
        this.createdAt,
        this.uid,
        this.v,
    });

    factory CaseData.fromJson(Map<String, dynamic> json) => CaseData(
        status: json["status"],
        whatsappCall: json["whatsappCall"],
        id: json["_id"],
        userId: json["userId"],
        nric: json["nric"],
        subject: json["subject"],
        description: json["description"],
        language: json["language"],
        refId: json["refId"],
        location: json["location"],
        queueNo: json["queueNo"],
        createdAt: DateTime.parse(json["createdAt"]),
        uid: json["uid"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "whatsappCall": whatsappCall,
        "_id": id,
        "userId": userId,
        "nric": nric,
        "subject": subject,
        "description": description,
        "language": language,
        "refId": refId,
        "location": location,
        "queueNo": queueNo,
        "uid": uid,
        "__v": v,
    };
}
