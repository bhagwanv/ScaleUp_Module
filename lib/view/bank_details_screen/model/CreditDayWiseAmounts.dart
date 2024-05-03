import 'CreditDayAmountCals.dart';

class CreditDayWiseAmounts {
  CreditDayWiseAmounts({
      this.days, 
      this.amount, 
      this.creditDayAmountCals, 
      this.finalAmount,});

  CreditDayWiseAmounts.fromJson(dynamic json) {
    days = json['days'];
    amount = json['amount'];
    creditDayAmountCals = json['creditDayAmountCals'] != null ? CreditDayAmountCals.fromJson(json['creditDayAmountCals']) : null;
    finalAmount = json['finalAmount'];
  }
  int? days;
  int? amount;
  CreditDayAmountCals? creditDayAmountCals;
  int? finalAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['days'] = days;
    map['amount'] = amount;
    if (creditDayAmountCals != null) {
      map['creditDayAmountCals'] = creditDayAmountCals?.toJson();
    }
    map['finalAmount'] = finalAmount;
    return map;
  }

}