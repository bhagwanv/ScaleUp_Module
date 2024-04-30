import 'package:scale_up_module/view/bank_details_screen/model/BankDetailResult.dart';

class BankDetailsResponceModel {
  BankDetailResult? result;
  bool? isSuccess;
  String? message;

  BankDetailsResponceModel({this.result, this.isSuccess, this.message});

  BankDetailsResponceModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? BankDetailResult.fromJson(json['result']) : null;
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