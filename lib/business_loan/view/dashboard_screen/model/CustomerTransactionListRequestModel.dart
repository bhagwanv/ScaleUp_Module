class CustomerTransactionListRequestModel {
  CustomerTransactionListRequestModel({
      this.anchorCompanyID, 
      this.leadId, 
      this.skip, 
      this.take, 
      this.transactionType,});

  CustomerTransactionListRequestModel.fromJson(dynamic json) {
    anchorCompanyID = json['AnchorCompanyID'];
    leadId = json['LeadId'];
    skip = json['Skip'];
    take = json['Take'];
    transactionType = json['TransactionType'];
  }
  String? anchorCompanyID;
  String? leadId;
  String? skip;
  String? take;
  String? transactionType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AnchorCompanyID'] = anchorCompanyID;
    map['LeadId'] = leadId;
    map['Skip'] = skip;
    map['Take'] = take;
    map['TransactionType'] = transactionType;
    return map;
  }

}