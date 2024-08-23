class CheckOutLogInOtpResponse {
  CheckOutLogInOtpResponse({
    this.mobileNo,
    this.customerName,
    this.imageUrl,
    this.customerCareMoblie,
    this.customerCareEmail,});

  CheckOutLogInOtpResponse.fromJson(dynamic json) {
    mobileNo = json['mobileNo'];
    customerName = json['customerName'];
    imageUrl = json['imageUrl'];
    customerCareMoblie = json['customerCareMoblie'];
    customerCareEmail = json['customerCareEmail'];
  }
  String? mobileNo;
  String? customerName;
  String? imageUrl;
  String? customerCareMoblie;
  String? customerCareEmail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileNo'] = mobileNo;
    map['customerName'] = customerName;
    map['imageUrl'] = imageUrl;
    map['customerCareMoblie'] = customerCareMoblie;
    map['customerCareEmail'] = customerCareEmail;
    return map;
  }

}