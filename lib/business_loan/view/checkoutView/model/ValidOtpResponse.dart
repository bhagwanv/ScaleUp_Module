class ValidOtpResponse {
  ValidOtpResponse({
      this.token, 
      this.transactionReqNo,});

  ValidOtpResponse.fromJson(dynamic json) {
    token = json['token'];
    transactionReqNo = json['transactionReqNo'];
  }
  String? token;
  String? transactionReqNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['transactionReqNo'] = transactionReqNo;
    return map;
  }

}