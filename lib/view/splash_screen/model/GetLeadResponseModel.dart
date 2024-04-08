class GetLeadResponseModel {
  GetLeadResponseModel({
      this.sequenceNo, 
      this.leadId, 
      this.userId,});

  GetLeadResponseModel.fromJson(dynamic json) {
    sequenceNo = json['sequenceNo'];
    leadId = json['leadId'];
    userId = json['userId'];
  }
  int? sequenceNo;
  int? leadId;
  dynamic userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sequenceNo'] = sequenceNo;
    map['leadId'] = leadId;
    map['userId'] = userId;
    return map;
  }

}