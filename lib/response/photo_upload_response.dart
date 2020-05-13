import 'dart:convert';

PhotoUploadResponse photoUploadResponseFromJson(String str) => PhotoUploadResponse.fromJson(json.decode(str));

String photoUploadResponseToJson(PhotoUploadResponse data) => json.encode(data.toJson());

class PhotoUploadResponse {
    int status;
    String message;
    dynamic data;

    PhotoUploadResponse({
        this.status,
        this.message,
        this.data,
    });

    factory PhotoUploadResponse.fromJson(Map<String, dynamic> json) => PhotoUploadResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
    };
}
