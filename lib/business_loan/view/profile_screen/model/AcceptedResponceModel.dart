class AcceptedResponceModel {
  AcceptedResponceModel({
      this.status, 
      this.message, 
      this.response,});

  AcceptedResponceModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    response = json['response'];
  }
  bool? status;
  String? message;
  bool? response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['response'] = response;
    return map;
  }

}