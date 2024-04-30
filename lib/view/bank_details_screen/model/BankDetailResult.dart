class BankDetailResult {
  BankDetailResult({
      this.leadId, 
      this.eNach, 
      this.bankName, 
      this.ifscCode, 
      this.accountType, 
      this.activityId, 
      this.subActivityId, 
      this.accountNumber, 
      this.accountHolderName,});

  BankDetailResult.fromJson(dynamic json) {
    leadId = json['leadId'];
    eNach = json['eNach'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
    accountType = json['accountType'];
    activityId = json['activityId'];
    subActivityId = json['subActivityId'];
    accountNumber = json['accountNumber'];
    accountHolderName = json['accountHolderName'];
  }
  int? leadId;
  String? eNach;
  String? bankName;
  String? ifscCode;
  String? accountType;
  int? activityId;
  int? subActivityId;
  String? accountNumber;
  String? accountHolderName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadId'] = leadId;
    map['eNach'] = eNach;
    map['bankName'] = bankName;
    map['ifscCode'] = ifscCode;
    map['accountType'] = accountType;
    map['activityId'] = activityId;
    map['subActivityId'] = subActivityId;
    map['accountNumber'] = accountNumber;
    map['accountHolderName'] = accountHolderName;
    return map;
  }
}