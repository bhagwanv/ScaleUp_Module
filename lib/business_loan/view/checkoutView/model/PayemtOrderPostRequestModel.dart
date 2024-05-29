class PayemtOrderPostRequestModel {
  PayemtOrderPostRequestModel({
      this.transactionReqNo, 
      this.amount, 
      this.mobileNo, 
      this.loanAccountId, 
      this.creditDay,});

  PayemtOrderPostRequestModel.fromJson(dynamic json) {
    transactionReqNo = json['TransactionReqNo'];
    amount = json['Amount'];
    mobileNo = json['MobileNo'];
    loanAccountId = json['LoanAccountId'];
    creditDay = json['CreditDay'];
  }
  String? transactionReqNo;
  int? amount;
  String? mobileNo;
  int? loanAccountId;
  int? creditDay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TransactionReqNo'] = transactionReqNo;
    map['Amount'] = amount;
    map['MobileNo'] = mobileNo;
    map['LoanAccountId'] = loanAccountId;
    map['CreditDay'] = creditDay;
    return map;
  }

}