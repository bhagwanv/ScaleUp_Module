class ProductSlabConfigResponse {
  ProductSlabConfigResponse({
      this.companyId, 
      this.productId, 
      this.slabType, 
      this.minLoanAmount, 
      this.maxLoanAmount, 
      this.minValue, 
      this.maxValue, 
      this.valueType, 
      this.isFixed, 
      this.sharePercentage,});

  ProductSlabConfigResponse.fromJson(dynamic json) {
    companyId = json['companyId'];
    productId = json['productId'];
    slabType = json['slabType'];
    minLoanAmount = json['minLoanAmount'];
    maxLoanAmount = json['maxLoanAmount'];
    minValue = json['minValue'];
    maxValue = json['maxValue'];
    valueType = json['valueType'];
    isFixed = json['isFixed'];
    sharePercentage = json['sharePercentage'];
  }
  int? companyId;
  int? productId;
  String? slabType;
  int? minLoanAmount;
  int? maxLoanAmount;
  int? minValue;
  int? maxValue;
  String? valueType;
  bool? isFixed;
  int? sharePercentage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['companyId'] = companyId;
    map['productId'] = productId;
    map['slabType'] = slabType;
    map['minLoanAmount'] = minLoanAmount;
    map['maxLoanAmount'] = maxLoanAmount;
    map['minValue'] = minValue;
    map['maxValue'] = maxValue;
    map['valueType'] = valueType;
    map['isFixed'] = isFixed;
    map['sharePercentage'] = sharePercentage;
    return map;
  }

}