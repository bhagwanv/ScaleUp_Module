class GetLeadResponseModel {
  final int? sequenceNo;
  final int? leadId;
  final String? userId;

  GetLeadResponseModel({ this.sequenceNo,  this.leadId, this.userId});

  factory GetLeadResponseModel.fromJson(Map<String, dynamic> json) {
    return GetLeadResponseModel(
      sequenceNo: json['sequenceNo'] as int?,
      leadId: json['leadId'] as int?,
      userId: json['userId'] as String?,
    );
  }
}
