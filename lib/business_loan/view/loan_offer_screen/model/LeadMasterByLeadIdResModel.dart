class LeadMasterByLeadIdResModel {
  LeadMasterByLeadIdResModel({
      this.msg, 
      this.status, 
      this.data, 
      this.isNotEditable, 
      this.nameOnCard, 
      this.arthMateOffer, 
      this.companyIdentificationCode, 
      this.isActivation,});

  LeadMasterByLeadIdResModel.fromJson(dynamic json) {
    msg = json['msg'];
    status = json['status'];
    data = json['data'];
    isNotEditable = json['isNotEditable'];
    nameOnCard = json['nameOnCard'];
    arthMateOffer = json['arthMateOffer'];
    companyIdentificationCode = json['companyIdentificationCode'];
    isActivation = json['isActivation'];
  }
  dynamic msg;
  bool? status;
  dynamic data;
  bool? isNotEditable;
  dynamic nameOnCard;
  dynamic arthMateOffer;
  dynamic companyIdentificationCode;
  bool? isActivation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msg'] = msg;
    map['status'] = status;
    map['data'] = data;
    map['isNotEditable'] = isNotEditable;
    map['nameOnCard'] = nameOnCard;
    map['arthMateOffer'] = arthMateOffer;
    map['companyIdentificationCode'] = companyIdentificationCode;
    map['isActivation'] = isActivation;
    return map;
  }

}