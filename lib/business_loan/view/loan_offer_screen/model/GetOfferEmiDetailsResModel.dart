class GetOfferEmiDetailsResModel {
  GetOfferEmiDetailsResModel({
      this.result, 
      this.isSuccess, 
      this.message,});

  GetOfferEmiDetailsResModel.fromJson(dynamic json) {
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(GetOfferEmiDetailList.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    message = json['message'];
  }
  List<GetOfferEmiDetailList>? result;
  bool? isSuccess;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    map['isSuccess'] = isSuccess;
    map['message'] = message;
    return map;
  }

}

class GetOfferEmiDetailList {
  GetOfferEmiDetailList({
    this.dueDate,
    this.outStandingAmount,
    this.prin,
    this.interestAmount,
    this.emiAmount,
    this.principalAmount,});

  GetOfferEmiDetailList.fromJson(dynamic json) {
    dueDate = json['dueDate'];
    outStandingAmount = json['outStandingAmount'];
    prin = json['prin'];
    interestAmount = json['interestAmount'];
    emiAmount = json['emiAmount'];
    principalAmount = json['principalAmount'];
  }
  String? dueDate;
  dynamic outStandingAmount;
  dynamic prin;
  dynamic interestAmount;
  dynamic emiAmount;
  dynamic principalAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dueDate'] = dueDate;
    map['outStandingAmount'] = outStandingAmount;
    map['prin'] = prin;
    map['interestAmount'] = interestAmount;
    map['emiAmount'] = emiAmount;
    map['principalAmount'] = principalAmount;
    return map;
  }

}