class AadhaarGenerateOTPResponseModel {
  String? requestId;
  int? statusCode;
  String? error;
  String? personId;


  AadhaarGenerateOTPResponseModel({
    this.requestId,
    this.statusCode,
    this.error,
    this.personId,});

  AadhaarGenerateOTPResponseModel.fromJson(dynamic json) {
    requestId = json['requestId'];
    statusCode = json['statusCode'];
    error = json['error'];
    personId = json['personId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestId'] = requestId;
    map['statusCode'] = statusCode;
    map['error'] = error;
    map['personId'] = personId;
    return map;
  }

}