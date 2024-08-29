class AadhaarOtpVerifyReqModel {
  AadhaarOtpVerifyReqModel({
      this.leadMasterId, 
      this.requestId, 
      this.otp, 
      this.loanAmt, 
      this.insuranceApplied,});

  AadhaarOtpVerifyReqModel.fromJson(dynamic json) {
    leadMasterId = json['leadMasterId'];
    requestId = json['request_id'];
    otp = json['otp'];
    loanAmt = json['loan_amt'];
    insuranceApplied = json['insurance_applied'];
  }
  int? leadMasterId;
  String? requestId;
  int? otp;
  int? loanAmt;
  bool? insuranceApplied;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadMasterId'] = leadMasterId;
    map['request_id'] = requestId;
    map['otp'] = otp;
    map['loan_amt'] = loanAmt;
    map['insurance_applied'] = insuranceApplied;
    return map;
  }

}