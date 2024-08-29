class Result {
  Result({
      this.dueDate, 
      this.outStandingAmount, 
      this.prin, 
      this.interestAmount, 
      this.emiAmount, 
      this.principalAmount,});

  Result.fromJson(dynamic json) {
    dueDate = json['dueDate'];
    outStandingAmount = json['outStandingAmount'];
    prin = json['prin'];
    interestAmount = json['interestAmount'];
    emiAmount = json['emiAmount'];
    principalAmount = json['principalAmount'];
  }
  String? dueDate;
  int? outStandingAmount;
  double? prin;
  double? interestAmount;
  double? emiAmount;
  double? principalAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dueDate'] = dueDate;
    map['outStandingAmount'] = outStandingAmount;
    map['prin'] = prin;
    map['interestAmount'] = interestAmount;
    map['emiAmount'] = emiAmount;
    map['principalAmount'] = principalAmount;
    return map;
  }

}