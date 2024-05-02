class CustomerOrderSummaryResModel {
  CustomerOrderSummaryResModel({
      this.totalOutStanding, 
      this.availableLimit, 
      this.totalPayableAmount, 
      this.totalPendingInvoiceCount, 
      this.customerInvoice, 
      this.customerName,});

  CustomerOrderSummaryResModel.fromJson(dynamic json) {
    totalOutStanding = json['totalOutStanding'];
    availableLimit = json['availableLimit'];
    totalPayableAmount = json['totalPayableAmount'];
    totalPendingInvoiceCount = json['totalPendingInvoiceCount'];
    customerInvoice = json['customerInvoice'];
    customerName = json['customerName'];
  }
  int? totalOutStanding;
  int? availableLimit;
  double? totalPayableAmount;
  int? totalPendingInvoiceCount;
  dynamic customerInvoice;
  String? customerName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalOutStanding'] = totalOutStanding;
    map['availableLimit'] = availableLimit;
    map['totalPayableAmount'] = totalPayableAmount;
    map['totalPendingInvoiceCount'] = totalPendingInvoiceCount;
    map['customerInvoice'] = customerInvoice;
    map['customerName'] = customerName;
    return map;
  }

}