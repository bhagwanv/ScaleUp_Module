
import 'ValidOtpResponse.dart';

class ValidOtpForCheckoutModel {
  ValidOtpForCheckoutModel({
      this.status, 
      this.message, 
      this.response,});

  ValidOtpForCheckoutModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null ? ValidOtpResponse.fromJson(json['response']) : null;
  }
  bool? status;
  String? message;
  ValidOtpResponse? response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    return map;
  }

}