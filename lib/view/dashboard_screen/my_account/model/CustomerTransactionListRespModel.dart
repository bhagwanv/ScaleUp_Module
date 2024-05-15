class CustomerTransactionListRespModel {
  CustomerTransactionListRespModel({
      this.anchorName, 
      this.dueDate, 
      this.orderId, 
      this.status, 
      this.amount, 
      this.transactionId, 
      this.invoiceId, 
      this.paidAmount, 
      this.invoiceNo,});

  CustomerTransactionListRespModel.fromJson(dynamic json) {
    anchorName = json['anchorName'];
    dueDate = json['dueDate'];
    orderId = json['orderId'];
    status = json['status'];
    amount = json['amount'];
    transactionId = json['transactionId'];
    invoiceId = json['invoiceId'];
    paidAmount = json['paidAmount'];
    invoiceNo = json['invoiceNo'];
  }
  String? anchorName;
  dynamic dueDate;
  String? orderId;
  String? status;
  dynamic? amount;
  int? transactionId;
  int? invoiceId;
  dynamic paidAmount;
  dynamic invoiceNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['anchorName'] = anchorName;
    map['dueDate'] = dueDate;
    map['orderId'] = orderId;
    map['status'] = status;
    map['amount'] = amount;
    map['transactionId'] = transactionId;
    map['invoiceId'] = invoiceId;
    map['paidAmount'] = paidAmount;
    map['invoiceNo'] = invoiceNo;
    return map;
  }

}