class CustomerTransactionListTwoReqModel {
  CustomerTransactionListTwoReqModel({
      this.leadId, 
      this.skip, 
      this.take,});

  CustomerTransactionListTwoReqModel.fromJson(dynamic json) {
    leadId = json['LeadId'];
    skip = json['Skip'];
    take = json['Take'];
  }
  int? leadId;
  int? skip;
  int? take;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['LeadId'] = leadId;
    map['Skip'] = skip;
    map['Take'] = take;
    return map;
  }

}