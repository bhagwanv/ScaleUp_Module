class Response {
  Response({
      this.token, 
      this.transactionReqNo, 
      this.customerName, 
      this.imageUrl, 
      this.customerCareMoblie, 
      this.customerCareEmail,});

  Response.fromJson(dynamic json) {
    token = json['token'];
    transactionReqNo = json['transactionReqNo'];
    customerName = json['customerName'];
    imageUrl = json['imageUrl'];
    customerCareMoblie = json['customerCareMoblie'];
    customerCareEmail = json['customerCareEmail'];
  }
  String? token;
  String? transactionReqNo;
  String? customerName;
  String? imageUrl;
  String? customerCareMoblie;
  String? customerCareEmail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['transactionReqNo'] = transactionReqNo;
    map['customerName'] = customerName;
    map['imageUrl'] = imageUrl;
    map['customerCareMoblie'] = customerCareMoblie;
    map['customerCareEmail'] = customerCareEmail;
    return map;
  }

}