class RepaymentAccountDetailsResModel {
  bool? status;
  String? message;
  RepaymentAccountDetailsResModelData? result;

  RepaymentAccountDetailsResModel({this.status, this.message, this.result});

  RepaymentAccountDetailsResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? RepaymentAccountDetailsResModelData.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class RepaymentAccountDetailsResModelData {
  String? virtualAccountNumber;
  String? virtualBankName;
  String? virtualIFSCCode;
  String? virtualUPIId;

  RepaymentAccountDetailsResModelData(
      {this.virtualAccountNumber,
        this.virtualBankName,
        this.virtualIFSCCode,
        this.virtualUPIId});

  RepaymentAccountDetailsResModelData.fromJson(Map<String, dynamic> json) {
    virtualAccountNumber = json['virtualAccountNumber'];
    virtualBankName = json['virtualBankName'];
    virtualIFSCCode = json['virtualIFSCCode'];
    virtualUPIId = json['virtualUPIId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['virtualAccountNumber'] = this.virtualAccountNumber;
    data['virtualBankName'] = this.virtualBankName;
    data['virtualIFSCCode'] = this.virtualIFSCCode;
    data['virtualUPIId'] = this.virtualUPIId;
    return data;
  }
}
