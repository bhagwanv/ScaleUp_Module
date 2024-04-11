class ValidateAadhaarOTPResponseModel {
  int? result;
  bool? isSuccess;
  String? message;
  int? statusCode;

  ValidateAadhaarOTPResponseModel({this.result, this.isSuccess, this.message, this.statusCode});

  ValidateAadhaarOTPResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    return data;
  }
}
