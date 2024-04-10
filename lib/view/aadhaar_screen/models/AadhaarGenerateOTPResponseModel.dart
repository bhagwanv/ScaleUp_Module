class AadhaarGenerateOTPResponseModel {
  String? requestId;
  int? statusCode;
  String? error;
  String? personId;
  Data? data;
  int? errorCode;

  AadhaarGenerateOTPResponseModel({
    this.requestId,
    this.statusCode,
    this.error,
    this.personId,
    this.data,
    this.errorCode,
  });

  AadhaarGenerateOTPResponseModel.fromJson(dynamic json) {
    requestId = json['requestId'];
    statusCode = json['statusCode'];
    error = json['error'];
    personId = json['personId'];
    data = json['result'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestId'] = requestId;
    map['statusCode'] = statusCode;
    map['error'] = error;
    map['personId'] = personId;
    map['result'] = data;
    return map;
  }
}

class Data {
  String? message;

  Data({this.message});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
