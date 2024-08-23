class ValidateOrderOtpReqModel {
  ValidateOrderOtpReqModel({
      this.mobileNo, 
      this.otp, 
      this.transactionReqNo, 
      this.amount, 
      this.loanAccountId, 
      this.creditDay,});

  ValidateOrderOtpReqModel.fromJson(dynamic json) {
    mobileNo = json['mobileNo'];
    otp = json['otp'];
    transactionReqNo = json['transactionReqNo'];
    amount = json['amount'];
    loanAccountId = json['loanAccountId'];
    creditDay = json['creditDay'];
  }
  String? mobileNo;
  String? otp;
  String? transactionReqNo;
  int? amount;
  int? loanAccountId;
  int? creditDay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileNo'] = mobileNo;
    map['otp'] = otp;
    map['transactionReqNo'] = transactionReqNo;
    map['amount'] = amount;
    map['loanAccountId'] = loanAccountId;
    map['creditDay'] = creditDay;
    return map;
  }

}