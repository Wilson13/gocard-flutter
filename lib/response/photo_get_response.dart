import 'dart:convert';

PhotoGetResponse photoGetResponseFromJson(String str) => PhotoGetResponse.fromJson(json.decode(str));

String photoGetResponseToJson(PhotoGetResponse photoData) => json.encode(photoData.toJson());

class PhotoGetResponse {
    int status;
    String message;
    PhotoGetData data;

    PhotoGetResponse({
        this.status,
        this.message,
        this.data,
    });

    factory PhotoGetResponse.fromJson(Map<String, dynamic> json) => PhotoGetResponse(
        status: json["status"],
        message: json["message"],
        data: PhotoGetData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class PhotoGetData {
    String url;
    String validity;

    PhotoGetData({
        this.url,
        this.validity,
    });

    factory PhotoGetData.fromJson(Map<String, dynamic> json) => PhotoGetData(
        url: json["url"],
        validity: json["validity"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "validity": validity,
    };
}
