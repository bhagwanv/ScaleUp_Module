class OfferPersonNameResponceModel {
  OfferPersonNameResponceModel({
      this.status, 
      this.message, 
      this.response,});

  OfferPersonNameResponceModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    response = json['response'];
  }
  bool? status;
  dynamic message;
  String? response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['response'] = response;
    return map;
  }

}