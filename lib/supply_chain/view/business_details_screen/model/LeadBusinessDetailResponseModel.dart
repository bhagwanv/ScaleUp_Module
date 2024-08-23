class LeadBusinessDetailResponseModel {
  LeadBusinessDetailResponseModel({
      this.businessName, 
      this.doi, 
      this.busGSTNO, 
      this.busEntityType, 
      this.busPan, 
      this.addressLineOne, 
      this.addressLineTwo, 
      this.addressLineThree, 
      this.zipCode, 
      this.cityId, 
      this.stateId, 
      this.buisnessMonthlySalary, 
      this.incomeSlab, 
      this.buisnessProof, 
      this.buisnessProofUrl, 
      this.buisnessProofDocId, 
      this.buisnessDocumentNo, 
      this.status, 
      this.message,});

  LeadBusinessDetailResponseModel.fromJson(dynamic json) {
    businessName = json['businessName'];
    doi = json['doi'];
    busGSTNO = json['busGSTNO'];
    busEntityType = json['busEntityType'];
    busPan = json['busPan'];
    addressLineOne = json['addressLineOne'];
    addressLineTwo = json['addressLineTwo'];
    addressLineThree = json['addressLineThree'];
    zipCode = json['zipCode'];
    cityId = json['cityId'];
    stateId = json['stateId'];
    buisnessMonthlySalary = json['buisnessMonthlySalary'];
    incomeSlab = json['incomeSlab'];
    buisnessProof = json['buisnessProof'];
    buisnessProofUrl = json['buisnessProofUrl'];
    buisnessProofDocId = json['buisnessProofDocId'];
    buisnessDocumentNo = json['buisnessDocumentNo'];
    status = json['status'];
    message = json['message'];
  }
  String? businessName;
  String? doi;
  String? busGSTNO;
  String? busEntityType;
  dynamic busPan;
  String? addressLineOne;
  String? addressLineTwo;
  String? addressLineThree;
  int? zipCode;
  int? cityId;
  int? stateId;
  int? buisnessMonthlySalary;
  String? incomeSlab;
  String? buisnessProof;
  String? buisnessProofUrl;
  int? buisnessProofDocId;
  String? buisnessDocumentNo;
  dynamic status;
  dynamic message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['businessName'] = businessName;
    map['doi'] = doi;
    map['busGSTNO'] = busGSTNO;
    map['busEntityType'] = busEntityType;
    map['busPan'] = busPan;
    map['addressLineOne'] = addressLineOne;
    map['addressLineTwo'] = addressLineTwo;
    map['addressLineThree'] = addressLineThree;
    map['zipCode'] = zipCode;
    map['cityId'] = cityId;
    map['stateId'] = stateId;
    map['buisnessMonthlySalary'] = buisnessMonthlySalary;
    map['incomeSlab'] = incomeSlab;
    map['buisnessProof'] = buisnessProof;
    map['buisnessProofUrl'] = buisnessProofUrl;
    map['buisnessProofDocId'] = buisnessProofDocId;
    map['buisnessDocumentNo'] = buisnessDocumentNo;
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}