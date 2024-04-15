class SaveBankDetailsRequestModel {
  SaveBankDetailsRequestModel({
      this.accountType, 
      this.bankName, 
      this.iFSCCode, 
      this.leadId, 
      this.eNach, 
      this.activityId, 
      this.subActivityId, 
      this.accountNumber, 
      this.accountHolderName,});

  SaveBankDetailsRequestModel.fromJson(dynamic json) {
    accountType = json['AccountType'];
    bankName = json['BankName'];
    iFSCCode = json['IFSCCode'];
    leadId = json['LeadId'];
    eNach = json['ENach'];
    activityId = json['ActivityId'];
    subActivityId = json['SubActivityId'];
    accountNumber = json['AccountNumber'];
    accountHolderName = json['AccountHolderName'];
  }
  String? accountType;
  String? bankName;
  String? iFSCCode;
  int? leadId;
  String? eNach;
  int? activityId;
  int? subActivityId;
  String? accountNumber;
  String? accountHolderName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AccountType'] = accountType;
    map['BankName'] = bankName;
    map['IFSCCode'] = iFSCCode;
    map['LeadId'] = leadId;
    map['ENach'] = eNach;
    map['ActivityId'] = activityId;
    map['SubActivityId'] = subActivityId;
    map['AccountNumber'] = accountNumber;
    map['AccountHolderName'] = accountHolderName;
    return map;
  }

}