class GetDisbursedLoanDetailResModel {
  dynamic sanctionAmount;
  int? insurancePremium;
  dynamic monthlyEMI;
  String? borroBankAccNum;
  dynamic loanIntAmt;
  dynamic processingFeesAmt;
  dynamic netDisburAmt;
  String? loanId;
  List<GetDisbursedLoanDetailRows>? rows;
  String? companyIdentificationCode;
  dynamic insuranceAmount;
  dynamic? othercharges;

  GetDisbursedLoanDetailResModel(
      {this.sanctionAmount,
        this.insurancePremium,
        this.monthlyEMI,
        this.borroBankAccNum,
        this.loanIntAmt,
        this.processingFeesAmt,
        this.netDisburAmt,
        this.loanId,
        this.rows,
        this.companyIdentificationCode,
        this.insuranceAmount,
        this.othercharges});

  GetDisbursedLoanDetailResModel.fromJson(Map<String, dynamic> json) {
    sanctionAmount = json['sanction_amount'];
    insurancePremium = json['insurancePremium'];
    monthlyEMI = json['monthlyEMI'];
    borroBankAccNum = json['borro_bank_acc_num'];
    loanIntAmt = json['loan_int_amt'];
    processingFeesAmt = json['processing_fees_amt'];
    netDisburAmt = json['net_disbur_amt'];
    loanId = json['loan_id'];
    if (json['rows'] != null) {
      rows = <GetDisbursedLoanDetailRows>[];
      json['rows'].forEach((v) {
        rows!.add(new GetDisbursedLoanDetailRows.fromJson(v));
      });
    }
    companyIdentificationCode = json['companyIdentificationCode'];
    insuranceAmount = json['insuranceAmount'];
    othercharges = json['othercharges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sanction_amount'] = this.sanctionAmount;
    data['insurancePremium'] = this.insurancePremium;
    data['monthlyEMI'] = this.monthlyEMI;
    data['borro_bank_acc_num'] = this.borroBankAccNum;
    data['loan_int_amt'] = this.loanIntAmt;
    data['processing_fees_amt'] = this.processingFeesAmt;
    data['net_disbur_amt'] = this.netDisburAmt;
    data['loan_id'] = this.loanId;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['companyIdentificationCode'] = this.companyIdentificationCode;
    data['insuranceAmount'] = this.insuranceAmount;
    data['othercharges'] = this.othercharges;
    return data;
  }
}

class GetDisbursedLoanDetailRows {
  int? repayScheduleId;
  int? companyId;
  int? productId;
  int? emiNo;
  String? dueDate;
  dynamic emiAmount;
  dynamic prin;
  dynamic intAmount;
  dynamic principalBal;
  dynamic principalOutstanding;

  GetDisbursedLoanDetailRows(
      {this.repayScheduleId,
        this.companyId,
        this.productId,
        this.emiNo,
        this.dueDate,
        this.emiAmount,
        this.prin,
        this.intAmount,
        this.principalBal,
        this.principalOutstanding});

  GetDisbursedLoanDetailRows.fromJson(Map<String, dynamic> json) {
    repayScheduleId = json['repay_schedule_id'];
    companyId = json['company_id'];
    productId = json['product_id'];
    emiNo = json['emi_no'];
    dueDate = json['due_date'];
    emiAmount = json['emi_amount'];
    prin = json['prin'];
    intAmount = json['int_amount'];
    principalBal = json['principal_bal'];
    principalOutstanding = json['principal_outstanding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['repay_schedule_id'] = this.repayScheduleId;
    data['company_id'] = this.companyId;
    data['product_id'] = this.productId;
    data['emi_no'] = this.emiNo;
    data['due_date'] = this.dueDate;
    data['emi_amount'] = this.emiAmount;
    data['prin'] = this.prin;
    data['int_amount'] = this.intAmount;
    data['principal_bal'] = this.principalBal;
    data['principal_outstanding'] = this.principalOutstanding;
    return data;
  }
}