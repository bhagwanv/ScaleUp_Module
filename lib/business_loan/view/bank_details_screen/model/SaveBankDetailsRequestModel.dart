class SaveBankDetailsRequestModel {
  List<LeadBankDetailDTOs>? leadBankDetailDTOs;
  bool? isScaleUp;
  List<BankDocs>? bankDocs;

  SaveBankDetailsRequestModel(
      {this.leadBankDetailDTOs, this.isScaleUp, this.bankDocs});

  SaveBankDetailsRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['leadBankDetailDTOs'] != null) {
      leadBankDetailDTOs = <LeadBankDetailDTOs>[];
      json['leadBankDetailDTOs'].forEach((v) {
        leadBankDetailDTOs!.add(new LeadBankDetailDTOs.fromJson(v));
      });
    }
    isScaleUp = json['isScaleUp'];
    if (json['BankDocs'] != null) {
      bankDocs = <BankDocs>[];
      json['BankDocs'].forEach((v) {
        bankDocs!.add(new BankDocs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leadBankDetailDTOs != null) {
      data['leadBankDetailDTOs'] =
          this.leadBankDetailDTOs!.map((v) => v.toJson()).toList();
    }
    data['isScaleUp'] = this.isScaleUp;
    if (this.bankDocs != null) {
      data['BankDocs'] = this.bankDocs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeadBankDetailDTOs {
  String? accountType;
  String? bankName;
  String? iFSCCode;
  int? leadId;
  String? type;
  int? activityId;
  int? subActivityId;
  String? accountNumber;
  String? accountHolderName;
  String? pdfPassword;
  String? surrogateType;

  LeadBankDetailDTOs(
      {this.accountType,
        this.bankName,
        this.iFSCCode,
        this.leadId,
        this.type,
        this.activityId,
        this.subActivityId,
        this.accountNumber,
        this.accountHolderName,
        this.pdfPassword,
        this.surrogateType});

  LeadBankDetailDTOs.fromJson(Map<String, dynamic> json) {
    accountType = json['AccountType'];
    bankName = json['BankName'];
    iFSCCode = json['IFSCCode'];
    leadId = json['LeadId'];
    type = json['Type'];
    activityId = json['ActivityId'];
    subActivityId = json['SubActivityId'];
    accountNumber = json['AccountNumber'];
    accountHolderName = json['AccountHolderName'];
    pdfPassword = json['PdfPassword'];
    surrogateType = json['SurrogateType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AccountType'] = this.accountType;
    data['BankName'] = this.bankName;
    data['IFSCCode'] = this.iFSCCode;
    data['LeadId'] = this.leadId;
    data['Type'] = this.type;
    data['ActivityId'] = this.activityId;
    data['SubActivityId'] = this.subActivityId;
    data['AccountNumber'] = this.accountNumber;
    data['AccountHolderName'] = this.accountHolderName;
    data['PdfPassword'] = this.pdfPassword;
    data['SurrogateType'] = this.surrogateType;
    return data;
  }
}

class BankDocs {
  String? documentName;
  String? documentType;
  String? fileURL;
  int? sequence;
  String? pdfPassword;
  String? documentNumber;

  BankDocs(
      {this.documentName,
        this.documentType,
        this.fileURL,
        this.sequence,
        this.pdfPassword,
        this.documentNumber});

  BankDocs.fromJson(Map<String, dynamic> json) {
    documentName = json['DocumentName'];
    documentType = json['DocumentType'];
    fileURL = json['FileURL'];
    sequence = json['Sequence'];
    pdfPassword = json['PdfPassword'];
    documentNumber = json['DocumentNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocumentName'] = this.documentName;
    data['DocumentType'] = this.documentType;
    data['FileURL'] = this.fileURL;
    data['Sequence'] = this.sequence;
    data['PdfPassword'] = this.pdfPassword;
    data['DocumentNumber'] = this.documentNumber;
    return data;
  }
}