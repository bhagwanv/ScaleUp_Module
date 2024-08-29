class GetOfferEmiDetailsDownloadPdfReqModel {
  GetOfferEmiDetailsDownloadPdfReqModel({
      this.leadId, 
      this.reqTenure,});

  GetOfferEmiDetailsDownloadPdfReqModel.fromJson(dynamic json) {
    leadId = json['leadId'];
    reqTenure = json['reqTenure'];
  }
  int? leadId;
  int? reqTenure;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadId'] = leadId;
    map['reqTenure'] = reqTenure;
    return map;
  }

}