class ArthMateOffer {
  ArthMateOffer({
      this.loanAmt, 
      this.interestRt, 
      this.loanTnr, 
      this.loanTnrType, 
      this.orignalLoanAmt, 
      this.name,});

  ArthMateOffer.fromJson(dynamic json) {
    loanAmt = json['loan_amt'];
    interestRt = json['interest_rt'];
    loanTnr = json['loan_tnr'];
    loanTnrType = json['loan_tnr_type'];
    orignalLoanAmt = json['orignal_loan_amt'];
    name = json['name'];
  }
  int? loanAmt;
  int? interestRt;
  int? loanTnr;
  String? loanTnrType;
  int? orignalLoanAmt;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['loan_amt'] = loanAmt;
    map['interest_rt'] = interestRt;
    map['loan_tnr'] = loanTnr;
    map['loan_tnr_type'] = loanTnrType;
    map['orignal_loan_amt'] = orignalLoanAmt;
    map['name'] = name;
    return map;
  }

}