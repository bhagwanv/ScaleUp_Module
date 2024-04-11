class SendOtpOnEmailResponce {
  SendOtpOnEmailResponce({
      this.status, 
      this.message, 
      this.otp,});

  SendOtpOnEmailResponce.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
  }
  bool? status;
  String? message;
  dynamic otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['otp'] = otp;
    return map;
  }

}