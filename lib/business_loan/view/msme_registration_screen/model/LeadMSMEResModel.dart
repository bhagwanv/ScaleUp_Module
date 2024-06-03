class LeadMsmeResModel {
  LeadMsmeResModel({
      this.doi, 
      this.msmeCertificateUrl, 
      this.msmeRegNum, 
      this.frontDocumentId, 
      this.businessName, 
      this.businessType, 
      this.vintage,});

  LeadMsmeResModel.fromJson(dynamic json) {
    doi = json['doi'];
    msmeCertificateUrl = json['msmeCertificateUrl'];
    msmeRegNum = json['msmeRegNum'];
    frontDocumentId = json['frontDocumentId'];
    businessName = json['businessName'];
    businessType = json['businessType'];
    vintage = json['vintage'];
  }
  String? doi;
  String? msmeCertificateUrl;
  String? msmeRegNum;
  int? frontDocumentId;
  String? businessName;
  String? businessType;
  int? vintage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['doi'] = doi;
    map['msmeCertificateUrl'] = msmeCertificateUrl;
    map['msmeRegNum'] = msmeRegNum;
    map['frontDocumentId'] = frontDocumentId;
    map['businessName'] = businessName;
    map['businessType'] = businessType;
    map['vintage'] = vintage;
    return map;
  }

}