import 'package:scale_up_module/view/profile_screen/model/disResponse.dart';

class DisbursementResponce {
  DisbursementResponce({
      this.status, 
      this.message, 
      this.response,});

  DisbursementResponce.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
  }
  bool? status;
  String? message;
  Response? response;

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