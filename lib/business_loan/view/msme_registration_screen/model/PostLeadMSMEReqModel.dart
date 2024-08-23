class PostLeadMsmeReqModel {
  PostLeadMsmeReqModel({
      this.doi, 
      this.msmeCertificateUrl, 
      this.msmeRegNum, 
      this.frontDocumentId, 
      this.businessName, 
      this.businessType, 
      this.vintage, 
      this.leadMasterId, 
      this.sequenceNo, 
      this.leadId, 
      this.userId, 
      this.activityId, 
      this.subActivityId, 
      this.companyId,});

  PostLeadMsmeReqModel.fromJson(dynamic json) {
    doi = json['doi'];
    msmeCertificateUrl = json['msmeCertificateUrl'];
    msmeRegNum = json['msmeRegNum'];
    frontDocumentId = json['frontDocumentId'];
    businessName = json['businessName'];
    businessType = json['businessType'];
    vintage = json['vintage'];
    leadMasterId = json['LeadMasterId'];
    sequenceNo = json['SequenceNo'];
    leadId = json['LeadId'];
    userId = json['UserId'];
    activityId = json['ActivityId'];
    subActivityId = json['SubActivityId'];
    companyId = json['CompanyId'];
  }
  String? doi;
  String? msmeCertificateUrl;
  String? msmeRegNum;
  int? frontDocumentId;
  String? businessName;
  String? businessType;
  int? vintage;
  int? leadMasterId;
  int? sequenceNo;
  int? leadId;
  String? userId;
  int? activityId;
  int? subActivityId;
  int? companyId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['doi'] = doi;
    map['msmeCertificateUrl'] = msmeCertificateUrl;
    map['msmeRegNum'] = msmeRegNum;
    map['frontDocumentId'] = frontDocumentId;
    map['businessName'] = businessName;
    map['businessType'] = businessType;
    map['vintage'] = vintage;
    map['LeadMasterId'] = leadMasterId;
    map['SequenceNo'] = sequenceNo;
    map['LeadId'] = leadId;
    map['UserId'] = userId;
    map['ActivityId'] = activityId;
    map['SubActivityId'] = subActivityId;
    map['CompanyId'] = companyId;
    return map;
  }

}