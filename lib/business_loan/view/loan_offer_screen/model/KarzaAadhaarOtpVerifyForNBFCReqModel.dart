class KarzaAadhaarOtpVerifyForNbfcReqModel {
  KarzaAadhaarOtpVerifyForNbfcReqModel({
      this.otp, 
      this.requestId, 
      this.consent, 
      this.aadhaarNo, 
      this.leadMasterId,});

  KarzaAadhaarOtpVerifyForNbfcReqModel.fromJson(dynamic json) {
    otp = json['otp'];
    requestId = json['requestId'];
    consent = json['consent'];
    aadhaarNo = json['aadhaarNo'];
    leadMasterId = json['leadMasterId'];
  }
  String? otp;
  String? requestId;
  String? consent;
  String? aadhaarNo;
  int? leadMasterId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp'] = otp;
    map['requestId'] = requestId;
    map['consent'] = consent;
    map['aadhaarNo'] = aadhaarNo;
    map['leadMasterId'] = leadMasterId;
    return map;
  }

}