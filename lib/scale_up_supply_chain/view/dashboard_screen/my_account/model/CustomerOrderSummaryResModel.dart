class CustomerOrderSummaryResModel {
  CustomerOrderSummaryResModel({
      this.totalOutStanding, 
      this.availableLimit, 
      this.totalPayableAmount, 
      this.totalPendingInvoiceCount, 
      this.customerInvoice, 
      this.customerName,
    this.customerImage,
  });

  CustomerOrderSummaryResModel.fromJson(dynamic json) {
    totalOutStanding = json['totalOutStanding'];
    availableLimit = json['availableLimit'];
    totalPayableAmount = json['totalPayableAmount'];
    totalPendingInvoiceCount = json['totalPendingInvoiceCount'];
    customerInvoice = json['customerInvoice'];
    customerName = json['customerName'];
    customerImage = json['customerImage'];
  }
  int? totalOutStanding;
  int? availableLimit;
  dynamic totalPayableAmount;
  int? totalPendingInvoiceCount;
  dynamic customerInvoice;
  String? customerName;
  String? customerImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalOutStanding'] = totalOutStanding;
    map['availableLimit'] = availableLimit;
    map['totalPayableAmount'] = totalPayableAmount;
    map['totalPendingInvoiceCount'] = totalPendingInvoiceCount;
    map['customerInvoice'] = customerInvoice;
    map['customerName'] = customerName;
    map['customerImage'] = customerImage;
    return map;
  }

}