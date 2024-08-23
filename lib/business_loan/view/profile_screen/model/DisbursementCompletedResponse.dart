class DisbursementCompletedResponse {
  bool? status;
  String? message;
  Response? response;

  DisbursementCompletedResponse({this.status, this.message, this.response});

  DisbursementCompletedResponse.fromJson(Map<String, dynamic> json) {
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
  int? accountId;
  int? leadId;
  String? mobileNo;
  String? leadCode;
  String? userName;
  int? disbursalAmount;
  int? convenienceFeeRate;
  int? processingFeeRate;
  String? accountCode;
  int? gstRate;
  int? processingFeeAmount;
  int? gstProcessingFeeAmount;
  String? processingFeeType;
  String? payableBy;
  String? thirdPartyLoanCode;
  String? anchorName;
  String? productType;
  int? interestRate;
  String? interestRateType;

  Response(
      {this.accountId,
        this.leadId,
        this.mobileNo,
        this.leadCode,
        this.userName,
        this.disbursalAmount,
        this.convenienceFeeRate,
        this.processingFeeRate,
        this.accountCode,
        this.gstRate,
        this.processingFeeAmount,
        this.gstProcessingFeeAmount,
        this.processingFeeType,
        this.payableBy,
        this.thirdPartyLoanCode,
        this.anchorName,
        this.productType,
        this.interestRate,
        this.interestRateType});

  Response.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    leadId = json['leadId'];
    mobileNo = json['mobileNo'];
    leadCode = json['leadCode'];
    userName = json['userName'];
    disbursalAmount = json['disbursalAmount'];
    convenienceFeeRate = json['convenienceFeeRate'];
    processingFeeRate = json['processingFeeRate'];
    accountCode = json['accountCode'];
    gstRate = json['gstRate'];
    processingFeeAmount = json['processingFeeAmount'];
    gstProcessingFeeAmount = json['gstProcessingFeeAmount'];
    processingFeeType = json['processingFeeType'];
    payableBy = json['payableBy'];
    thirdPartyLoanCode = json['thirdPartyLoanCode'];
    anchorName = json['anchorName'];
    productType = json['productType'];
    interestRate = json['interestRate'];
    interestRateType = json['interestRateType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountId'] = this.accountId;
    data['leadId'] = this.leadId;
    data['mobileNo'] = this.mobileNo;
    data['leadCode'] = this.leadCode;
    data['userName'] = this.userName;
    data['disbursalAmount'] = this.disbursalAmount;
    data['convenienceFeeRate'] = this.convenienceFeeRate;
    data['processingFeeRate'] = this.processingFeeRate;
    data['accountCode'] = this.accountCode;
    data['gstRate'] = this.gstRate;
    data['processingFeeAmount'] = this.processingFeeAmount;
    data['gstProcessingFeeAmount'] = this.gstProcessingFeeAmount;
    data['processingFeeType'] = this.processingFeeType;
    data['payableBy'] = this.payableBy;
    data['thirdPartyLoanCode'] = this.thirdPartyLoanCode;
    data['anchorName'] = this.anchorName;
    data['productType'] = this.productType;
    data['interestRate'] = this.interestRate;
    data['interestRateType'] = this.interestRateType;
    return data;
  }
}