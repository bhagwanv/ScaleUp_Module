class GenerateKarzaAadhaarOtpForNbfcResModel {
  String? msg;
  bool? status;
  GenerateKarzaAadhaarOtpForNbfcResModelData? data;
  bool? isNotEditable;
  var nameOnCard;
  var arthMateOffer;
  var companyIdentificationCode;
  bool? isActivation;
  int? nbfcCompanyId;

  GenerateKarzaAadhaarOtpForNbfcResModel(
      {this.msg,
        this.status,
        this.data,
        this.isNotEditable,
        this.nameOnCard,
        this.arthMateOffer,
        this.companyIdentificationCode,
        this.isActivation,
        this.nbfcCompanyId});

  GenerateKarzaAadhaarOtpForNbfcResModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    data = json['data'] != null ? new GenerateKarzaAadhaarOtpForNbfcResModelData.fromJson(json['data']) : null;
    isNotEditable = json['isNotEditable'];
    nameOnCard = json['nameOnCard'];
    arthMateOffer = json['arthMateOffer'];
    companyIdentificationCode = json['companyIdentificationCode'];
    isActivation = json['isActivation'];
    nbfcCompanyId = json['nbfcCompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['isNotEditable'] = this.isNotEditable;
    data['nameOnCard'] = this.nameOnCard;
    data['arthMateOffer'] = this.arthMateOffer;
    data['companyIdentificationCode'] = this.companyIdentificationCode;
    data['isActivation'] = this.isActivation;
    data['nbfcCompanyId'] = this.nbfcCompanyId;
    return data;
  }
}

class GenerateKarzaAadhaarOtpForNbfcResModelData {
  String? requestId;
  GenerateKarzaAadhaarOtpForNbfcResModelDataResult? result;
  int? statusCode;
  String? error;
  String? personId;

  GenerateKarzaAadhaarOtpForNbfcResModelData(
      {this.requestId,
        this.result,
        this.statusCode,
        this.error,
        this.personId});

  GenerateKarzaAadhaarOtpForNbfcResModelData.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    result =
    json['result'] != null ? new GenerateKarzaAadhaarOtpForNbfcResModelDataResult.fromJson(json['result']) : null;
    statusCode = json['statusCode'];
    error = json['error'];
    personId = json['personId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['error'] = this.error;
    data['personId'] = this.personId;
    return data;
  }
}

class GenerateKarzaAadhaarOtpForNbfcResModelDataResult {
  String? message;

  GenerateKarzaAadhaarOtpForNbfcResModelDataResult({this.message});

  GenerateKarzaAadhaarOtpForNbfcResModelDataResult.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
