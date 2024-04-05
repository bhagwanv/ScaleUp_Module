import 'LeadProductActivity.dart';

class LeadCurrentResponseModel {
  LeadCurrentResponseModel({
      this.currentSequence, 
      this.leadProductActivity,});

  LeadCurrentResponseModel.fromJson(dynamic json) {
    currentSequence = json['currentSequence'];
    if (json['leadProductActivity'] != null) {
      leadProductActivity = [];
      json['leadProductActivity'].forEach((v) {
        leadProductActivity?.add(LeadProductActivity.fromJson(v));
      });
    }
  }
  int? currentSequence;
  List<LeadProductActivity>? leadProductActivity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currentSequence'] = currentSequence;
    if (leadProductActivity != null) {
      map['leadProductActivity'] = leadProductActivity?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}