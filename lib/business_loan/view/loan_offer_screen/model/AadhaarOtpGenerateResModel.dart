import 'ArthMateOffer.dart';

class AadhaarOtpGenerateResModel {
  AadhaarOtpGenerateResModel({
      this.msg, 
      this.status, 
      this.data, 
      this.isNotEditable, 
      this.nameOnCard, 
      this.arthMateOffer, 
      this.companyIdentificationCode, 
      this.isActivation,});

  AadhaarOtpGenerateResModel.fromJson(dynamic json) {
    msg = json['msg'];
    status = json['status'];
    data = json['data'];
    isNotEditable = json['isNotEditable'];
    nameOnCard = json['nameOnCard'];
    arthMateOffer = json['arthMateOffer'] != null ? ArthMateOffer.fromJson(json['arthMateOffer']) : null;
    companyIdentificationCode = json['companyIdentificationCode'];
    isActivation = json['isActivation'];
  }
  String? msg;
  bool? status;
  String? data;
  bool? isNotEditable;
  String? nameOnCard;
  ArthMateOffer? arthMateOffer;
  String? companyIdentificationCode;
  bool? isActivation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msg'] = msg;
    map['status'] = status;
    map['data'] = data;
    map['isNotEditable'] = isNotEditable;
    map['nameOnCard'] = nameOnCard;
    if (arthMateOffer != null) {
      map['arthMateOffer'] = arthMateOffer?.toJson();
    }
    map['companyIdentificationCode'] = companyIdentificationCode;
    map['isActivation'] = isActivation;
    return map;
  }

}