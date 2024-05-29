class Response {
  Response({
    this.leadNo,
    this.appliedDate,
    this.creditLimit,
    this.processingFeeAmount,
    this.gstAmount,
    this.processingFeePayableBy,
    this.convenionFeeRate,
    this.convenionGSTAmount,
    this.convenionFeePayableBy,});

  Response.fromJson(dynamic json) {
    leadNo = json['leadNo'];
    appliedDate = json['appliedDate'];
    creditLimit = json['creditLimit'];
    processingFeeAmount = json['processingFeeAmount'];
    gstAmount = json['gstAmount'];
    processingFeePayableBy = json['processingFeePayableBy'];
    convenionFeeRate = json['convenionFeeRate'];
    convenionGSTAmount = json['convenionGSTAmount'];
    convenionFeePayableBy = json['convenionFeePayableBy'];
  }
  String? leadNo;
  String? appliedDate;
  int? creditLimit;
  int? processingFeeAmount;
  int? gstAmount;
  String? processingFeePayableBy;
  int? convenionFeeRate;
  int? convenionGSTAmount;
  String? convenionFeePayableBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadNo'] = leadNo;
    map['appliedDate'] = appliedDate;
    map['creditLimit'] = creditLimit;
    map['processingFeeAmount'] = processingFeeAmount;
    map['gstAmount'] = gstAmount;
    map['processingFeePayableBy'] = processingFeePayableBy;
    map['convenionFeeRate'] = convenionFeeRate;
    map['convenionGSTAmount'] = convenionGSTAmount;
    map['convenionFeePayableBy'] = convenionFeePayableBy;
    return map;
  }

}