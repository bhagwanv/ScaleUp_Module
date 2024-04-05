class GenrateOptResponceModel {
  GenrateOptResponceModel({
      this.status, 
      this.message, 
      this.otp,});

  GenrateOptResponceModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
  }
  bool? status;
  String? message;
  String? otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['otp'] = otp;
    return map;
  }

}