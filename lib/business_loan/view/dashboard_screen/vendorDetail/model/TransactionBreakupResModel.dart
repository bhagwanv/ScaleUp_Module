import 'TransactionList.dart';

class TransactionBreakupResModel {
  TransactionBreakupResModel({
      this.totalPayableAmount, 
      this.transactionList,});

  TransactionBreakupResModel.fromJson(dynamic json) {
    totalPayableAmount = json['totalPayableAmount'];
    if (json['transactionList'] != null) {
      transactionList = [];
      json['transactionList'].forEach((v) {
        transactionList?.add(TransactionList.fromJson(v));
      });
    }
  }
  dynamic? totalPayableAmount;
  List<TransactionList>? transactionList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalPayableAmount'] = totalPayableAmount;
    if (transactionList != null) {
      map['transactionList'] = transactionList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}