class GetLeadDocumentDetailResModel {
  List<GetLeadDocumentDetail>? result;
  bool? isSuccess;
  String? message;

  GetLeadDocumentDetailResModel({this.result, this.isSuccess, this.message});

  GetLeadDocumentDetailResModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <GetLeadDocumentDetail>[];
      json['result'].forEach((v) {
        result!.add(new GetLeadDocumentDetail.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    return data;
  }
}

class GetLeadDocumentDetail {
  int? leadId;
  String? documentNumber;
  String? documentName;
  String? fileUrl;
  Null? pdfPassword;
  int? leadDocDetailId;
  int? sequence;
  int? docId;

  GetLeadDocumentDetail(
      {this.leadId,
        this.documentNumber,
        this.documentName,
        this.fileUrl,
        this.pdfPassword,
        this.leadDocDetailId,
        this.sequence,
        this.docId});

  GetLeadDocumentDetail.fromJson(Map<String, dynamic> json) {
    leadId = json['leadId'];
    documentNumber = json['documentNumber'];
    documentName = json['documentName'];
    fileUrl = json['fileUrl'];
    pdfPassword = json['pdfPassword'];
    leadDocDetailId = json['leadDocDetailId'];
    sequence = json['sequence'];
    docId = json['docId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadId'] = this.leadId;
    data['documentNumber'] = this.documentNumber;
    data['documentName'] = this.documentName;
    data['fileUrl'] = this.fileUrl;
    data['pdfPassword'] = this.pdfPassword;
    data['leadDocDetailId'] = this.leadDocDetailId;
    data['sequence'] = this.sequence;
    data['docId'] = this.docId;
    return data;
  }
}