import 'dart:ffi';

import 'package:flutter/cupertino.dart';

import '../api/ApiService.dart';
import '../view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import '../view/aadhaar_screen/models/AadhaarGenerateOTPResponseModel.dart';
import '../view/login_screen/model/GenrateOptResponceModel.dart';
import '../view/pancard_screen/model/LeadPanResponseModel.dart';
import '../view/pancard_screen/model/ValidPanCardResponsModel.dart';
import '../view/splash_screen/model/GetLeadResponseModel.dart';
import '../view/splash_screen/model/LeadCurrentRequestModel.dart';
import '../view/splash_screen/model/LeadCurrentResponseModel.dart';

class DataProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  GetLeadResponseModel? _getLeadData;

  GetLeadResponseModel? get getLeadData => _getLeadData;

  LeadCurrentResponseModel? _leadCurrentActivityAsyncData;

  LeadCurrentResponseModel? get leadCurrentActivityAsyncData =>
      _leadCurrentActivityAsyncData;
  GenrateOptResponceModel? _genrateOptData;

  GenrateOptResponceModel? get genrateOptData => _genrateOptData;

  LeadPanResponseModel? _getLeadPANData;

  LeadPanResponseModel? get getLeadPANData => _getLeadPANData;

  ValidPanCardResponsModel? _getLeadValidPanCardData;

  ValidPanCardResponsModel? get getLeadValidPanCardData =>
      _getLeadValidPanCardData;

  ValidPanCardResponsModel? _getLeadAadhaar;

  ValidPanCardResponsModel? get getLeadAadhaar => _getLeadAadhaar;

  AadhaarGenerateOTPResponseModel? _getLeadAadharGenerateOTP;

  AadhaarGenerateOTPResponseModel? get getLeadAadharGenerateOTP => _getLeadAadharGenerateOTP;

  Future<void> getLeads(
      String mobile, int productId, int companyId, int leadId) async {
    _getLeadData =
        await apiService.getLeads(mobile, productId, companyId, leadId);
    notifyListeners();
  }

  Future<void> getLeadPAN(String userId) async {
    _getLeadPANData = await apiService.getLeadPAN(userId);
    notifyListeners();
  }

  Future<void> genrateOtp(String mobileNumber, int CompanyID) async {
    _genrateOptData = await apiService.genrateOtp(mobileNumber, CompanyID);
    notifyListeners();
  }

  Future<void> getLeadValidPanCard(String panNumber) async {
    _getLeadValidPanCardData = await apiService.getLeadValidPanCard(panNumber);
    notifyListeners();
  }

  Future<void> leadCurrentActivityAsync(
      LeadCurrentRequestModel leadCurrentRequestModel) async {
    _leadCurrentActivityAsyncData =
        await apiService.leadCurrentActivityAsync(leadCurrentRequestModel);
    notifyListeners();
  }

  Future<void> getLeadAadhar(String userId) async {
    _getLeadAadhaar = await apiService.getLeadAadhar(userId);
    notifyListeners();
  }

  Future<void> leadAadharGenerateOTP(
      AadhaarGenerateOTPRequestModel aadhaarGenerateOTPRequestModel) async {
    _getLeadAadharGenerateOTP =
    await apiService.getLeadAadharGenerateOTP(aadhaarGenerateOTPRequestModel);
    notifyListeners();
  }
}
