class TransactionList {
  TransactionList({
      this.amount, 
      this.transactionType,});

  TransactionList.fromJson(dynamic json) {
    amount = json['amount'];
    transactionType = json['transactionType'];
  }
  dynamic? amount;
  String? transactionType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = amount;
    map['transactionType'] = transactionType;
    return map;
  }

}