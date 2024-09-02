import 'ProductSlabConfigResponse.dart';

class AcceptOfferByLeadReqModel {
  AcceptOfferByLeadReqModel({
      this.leadId, 
      this.tenure, 
      this.amount, 
      this.otp, 
      this.requestId, 
      this.userId, 
      this.activityId, 
      this.subActivityId, 
      this.nbfcCompanyId, 
      this.productSlabConfigResponse,});

  AcceptOfferByLeadReqModel.fromJson(dynamic json) {
    leadId = json['leadId'];
    tenure = json['tenure'];
    amount = json['amount'];
    otp = json['otp'];
    requestId = json['requestId'];
    userId = json['userId'];
    activityId = json['activityId'];
    subActivityId = json['subActivityId'];
    nbfcCompanyId = json['nbfcCompanyId'];
    if (json['productSlabConfigResponse'] != null) {
      productSlabConfigResponse = [];
      json['productSlabConfigResponse'].forEach((v) {
        productSlabConfigResponse?.add(ProductSlabConfigResponse.fromJson(v));
      });
    };
  }
  int? leadId;
  int? tenure;
  int? amount;
  String? otp;
  String? requestId;
  String? userId;
  int? activityId;
  int? subActivityId;
  int? nbfcCompanyId;
  List<ProductSlabConfigResponse>? productSlabConfigResponse;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadId'] = leadId;
    map['tenure'] = tenure;
    map['amount'] = amount;
    map['otp'] = otp;
    map['requestId'] = requestId;
    map['userId'] = userId;
    map['activityId'] = activityId;
    map['subActivityId'] = subActivityId;
    map['nbfcCompanyId'] = nbfcCompanyId;
    if (productSlabConfigResponse != null) {
      map['productSlabConfigResponse'] = productSlabConfigResponse?.map((v) => v.toJson()).toList();
    }

    return map;
  }

}