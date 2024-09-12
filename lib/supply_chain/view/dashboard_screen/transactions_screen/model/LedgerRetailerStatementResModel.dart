class LedgerRetailerStatementResModel {
  bool? status;
  String? message;
  Response? response;

  LedgerRetailerStatementResModel({this.status, this.message, this.response});

  LedgerRetailerStatementResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? customerName;
  String? message;
  List<LoanPaymentsResultList>? loanPaymentsResultList;
  String? htmlContent;
  String? invoicePdfPath;

  Response(
      {this.customerName,
        this.message,
        this.loanPaymentsResultList,
        this.htmlContent,
          this.invoicePdfPath});

  Response.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    message = json['message'];
    if (json['loanPaymentsResultList'] != null) {
      loanPaymentsResultList = <LoanPaymentsResultList>[];
      json['loanPaymentsResultList'].forEach((v) {
        loanPaymentsResultList!.add(new LoanPaymentsResultList.fromJson(v));
      });
    }
    htmlContent = json['htmlContent'];
    invoicePdfPath = json['invoicePdfPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['message'] = this.message;
    if (this.loanPaymentsResultList != null) {
      data['loanPaymentsResultList'] =
          this.loanPaymentsResultList!.map((v) => v.toJson()).toList();
    }
    data['htmlContent'] = this.htmlContent;
    data['invoicePdfPath'] = this.invoicePdfPath;
    return data;
  }
}

class LoanPaymentsResultList {
  String? invoiceNo;
  String? withdrawalId;
  String? fieldInfo;
  int? fieldOldValue;
  int? fieldNewValue;

  LoanPaymentsResultList(
      {this.invoiceNo,
        this.withdrawalId,
        this.fieldInfo,
        this.fieldOldValue,
        this.fieldNewValue});

  LoanPaymentsResultList.fromJson(Map<String, dynamic> json) {
    invoiceNo = json['invoiceNo'];
    withdrawalId = json['withdrawalId'];
    fieldInfo = json['fieldInfo'];
    fieldOldValue = json['fieldOldValue'];
    fieldNewValue = json['fieldNewValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceNo'] = this.invoiceNo;
    data['withdrawalId'] = this.withdrawalId;
    data['fieldInfo'] = this.fieldInfo;
    data['fieldOldValue'] = this.fieldOldValue;
    data['fieldNewValue'] = this.fieldNewValue;
    return data;
  }
}