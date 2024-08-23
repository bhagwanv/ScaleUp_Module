class PostLeadBuisnessDetailRequestModel {
  int? leadId;
  int? activityId;
  int? subActivityId;
  String? userId;
  int? companyId;
  String? busName;
  String? doi;
  String? busGSTNO;
  String? busEntityType;
  String? busAddCorrLine1;
  String? busAddCorrLine2;
  String? busAddCorrPincode;
  String? busAddCorrCity;
  String? busAddCorrState;
  int? buisnessMonthlySalary;
  String? incomeSlab;
  String? buisnessProof;
  int? buisnessProofDocId;
  String? buisnessDocumentNo;
  int? inquiryAmount;
  String? surrogateType;

  PostLeadBuisnessDetailRequestModel(
      {this.leadId,
        this.activityId,
        this.subActivityId,
        this.userId,
        this.companyId,
        this.busName,
        this.doi,
        this.busGSTNO,
        this.busEntityType,
        this.busAddCorrLine1,
        this.busAddCorrLine2,
        this.busAddCorrPincode,
        this.busAddCorrCity,
        this.busAddCorrState,
        this.buisnessMonthlySalary,
        this.incomeSlab,
        this.buisnessProof,
        this.buisnessProofDocId,
        this.buisnessDocumentNo,
        this.inquiryAmount,
        this.surrogateType});

  PostLeadBuisnessDetailRequestModel.fromJson(Map<String, dynamic> json) {
    leadId = json['leadId'];
    activityId = json['activityId'];
    subActivityId = json['subActivityId'];
    userId = json['userId'];
    companyId = json['companyId'];
    busName = json['busName'];
    doi = json['doi'];
    busGSTNO = json['busGSTNO'];
    busEntityType = json['busEntityType'];
    busAddCorrLine1 = json['busAddCorrLine1'];
    busAddCorrLine2 = json['busAddCorrLine2'];
    busAddCorrPincode = json['busAddCorrPincode'];
    busAddCorrCity = json['busAddCorrCity'];
    busAddCorrState = json['busAddCorrState'];
    buisnessMonthlySalary = json['buisnessMonthlySalary'];
    incomeSlab = json['incomeSlab'];
    buisnessProof = json['buisnessProof'];
    buisnessProofDocId = json['buisnessProofDocId'];
    buisnessDocumentNo = json['buisnessDocumentNo'];
    inquiryAmount = json['inquiryAmount'];
    surrogateType = json['surrogateType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadId'] = this.leadId;
    data['activityId'] = this.activityId;
    data['subActivityId'] = this.subActivityId;
    data['userId'] = this.userId;
    data['companyId'] = this.companyId;
    data['busName'] = this.busName;
    data['doi'] = this.doi;
    data['busGSTNO'] = this.busGSTNO;
    data['busEntityType'] = this.busEntityType;
    data['busAddCorrLine1'] = this.busAddCorrLine1;
    data['busAddCorrLine2'] = this.busAddCorrLine2;
    data['busAddCorrPincode'] = this.busAddCorrPincode;
    data['busAddCorrCity'] = this.busAddCorrCity;
    data['busAddCorrState'] = this.busAddCorrState;
    data['buisnessMonthlySalary'] = this.buisnessMonthlySalary;
    data['incomeSlab'] = this.incomeSlab;
    data['buisnessProof'] = this.buisnessProof;
    data['buisnessProofDocId'] = this.buisnessProofDocId;
    data['buisnessDocumentNo'] = this.buisnessDocumentNo;
    data['inquiryAmount'] = this.inquiryAmount;
    data['surrogateType'] = this.surrogateType;
    return data;
  }
}