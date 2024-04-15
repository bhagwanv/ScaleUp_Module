class PostLeadBuisnessDetailRequestModel {
  PostLeadBuisnessDetailRequestModel({
      this.leadId, 
      this.userId, 
      this.activityId, 
      this.subActivityId, 
      this.busName, 
      this.doi, 
      this.busGSTNO, 
      this.busEntityType, 
      this.busAddCorrLine1, 
      this.busAddCorrLine2, 
      this.busAddCorrCity, 
      this.busAddCorrState, 
      this.busAddCorrPincode, 
      this.buisnessMonthlySalary, 
      this.incomeSlab, 
      this.companyId, 
      this.buisnessDocumentNo, 
      this.buisnessProofDocId, 
      this.buisnessProof,});

  PostLeadBuisnessDetailRequestModel.fromJson(dynamic json) {
    leadId = json['LeadId'];
    userId = json['UserId'];
    activityId = json['ActivityId'];
    subActivityId = json['SubActivityId'];
    busName = json['BusName'];
    doi = json['DOI'];
    busGSTNO = json['BusGSTNO'];
    busEntityType = json['BusEntityType'];
    busAddCorrLine1 = json['BusAddCorrLine1'];
    busAddCorrLine2 = json['BusAddCorrLine2'];
    busAddCorrCity = json['BusAddCorrCity'];
    busAddCorrState = json['BusAddCorrState'];
    busAddCorrPincode = json['BusAddCorrPincode'];
    buisnessMonthlySalary = json['BuisnessMonthlySalary'];
    incomeSlab = json['IncomeSlab'];
    companyId = json['CompanyId'];
    buisnessDocumentNo = json['BuisnessDocumentNo'];
    buisnessProofDocId = json['BuisnessProofDocId'];
    buisnessProof = json['BuisnessProof'];
  }
  int? leadId;
  String? userId;
  int? activityId;
  int? subActivityId;
  String? busName;
  String? doi;
  String? busGSTNO;
  String? busEntityType;
  String? busAddCorrLine1;
  String? busAddCorrLine2;
  String? busAddCorrCity;
  String? busAddCorrState;
  String? busAddCorrPincode;
  int? buisnessMonthlySalary;
  String? incomeSlab;
  int? companyId;
  String? buisnessDocumentNo;
  int? buisnessProofDocId;
  String? buisnessProof;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['LeadId'] = leadId;
    map['UserId'] = userId;
    map['ActivityId'] = activityId;
    map['SubActivityId'] = subActivityId;
    map['BusName'] = busName;
    map['DOI'] = doi;
    map['BusGSTNO'] = busGSTNO;
    map['BusEntityType'] = busEntityType;
    map['BusAddCorrLine1'] = busAddCorrLine1;
    map['BusAddCorrLine2'] = busAddCorrLine2;
    map['BusAddCorrCity'] = busAddCorrCity;
    map['BusAddCorrState'] = busAddCorrState;
    map['BusAddCorrPincode'] = busAddCorrPincode;
    map['BuisnessMonthlySalary'] = buisnessMonthlySalary;
    map['IncomeSlab'] = incomeSlab;
    map['CompanyId'] = companyId;
    map['BuisnessDocumentNo'] = buisnessDocumentNo;
    map['BuisnessProofDocId'] = buisnessProofDocId;
    map['BuisnessProof'] = buisnessProof;
    return map;
  }

}