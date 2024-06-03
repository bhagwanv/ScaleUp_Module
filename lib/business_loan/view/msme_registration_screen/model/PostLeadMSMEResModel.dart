class PostLeadMsmeResModel {
  PostLeadMsmeResModel({
      this.result, 
      this.isSuccess, 
      this.message,});

  PostLeadMsmeResModel.fromJson(dynamic json) {
    result = json['result'];
    isSuccess = json['isSuccess'];
    message = json['message'];
  }
  int? result;
  bool? isSuccess;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['isSuccess'] = isSuccess;
    map['message'] = message;
    return map;
  }

}