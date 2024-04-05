class LeadProductActivity {
  LeadProductActivity({
      this.activityMasterId, 
      this.subActivityMasterId, 
      this.kycMasterCode, 
      this.activityName, 
      this.subActivityName, 
      this.sequence, 
      this.leadId, 
      this.isEditable, 
      this.rejectedReason,});

  LeadProductActivity.fromJson(dynamic json) {
    activityMasterId = json['activityMasterId'];
    subActivityMasterId = json['subActivityMasterId'];
    kycMasterCode = json['kycMasterCode'];
    activityName = json['activityName'];
    subActivityName = json['subActivityName'];
    sequence = json['sequence'];
    leadId = json['leadId'];
    isEditable = json['isEditable'];
    rejectedReason = json['rejectedReason'];
  }
  int? activityMasterId;
  int? subActivityMasterId;
  dynamic kycMasterCode;
  String? activityName;
  String? subActivityName;
  int? sequence;
  int? leadId;
  bool? isEditable;
  dynamic rejectedReason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['activityMasterId'] = activityMasterId;
    map['subActivityMasterId'] = subActivityMasterId;
    map['kycMasterCode'] = kycMasterCode;
    map['activityName'] = activityName;
    map['subActivityName'] = subActivityName;
    map['sequence'] = sequence;
    map['leadId'] = leadId;
    map['isEditable'] = isEditable;
    map['rejectedReason'] = rejectedReason;
    return map;
  }

}