
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:scale_up_module/view/pancard_screen/model/PostLeadPANRequestModel.dart';
import 'package:scale_up_module/view/pancard_screen/model/PostSingleFileResponseModel.dart';

import '../api/ApiService.dart';
import '../view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import '../view/aadhaar_screen/models/AadhaarGenerateOTPResponseModel.dart';
import '../view/bank_details_screen/model/BankDetailsResponceModel.dart';
import '../view/bank_details_screen/model/BankListResponceModel.dart';
import '../view/login_screen/model/GenrateOptResponceModel.dart';
import '../view/otp_screens/model/VarifayOtpRequest.dart';
import '../view/otp_screens/model/VerifyOtpResponce.dart';
import '../view/pancard_screen/model/LeadPanResponseModel.dart';
import '../view/pancard_screen/model/PostLeadPANResponseModel.dart';
import '../view/pancard_screen/model/ValidPanCardResponsModel.dart';
import '../view/personal_info/model/AllStateResponce.dart';
import '../view/personal_info/model/CityResponce.dart';
import '../view/personal_info/model/PersonalDetailsResponce.dart';
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

  ValidPanCardResponsModel? _getFathersNameByValidPanCardData;
  ValidPanCardResponsModel? get getFathersNameByValidPanCardData => _getFathersNameByValidPanCardData;

  PostSingleFileResponseModel? _getPostSingleFileData;
  PostSingleFileResponseModel? get getPostSingleFileData => _getPostSingleFileData;

  PostLeadPanResponseModel? _getPostLeadPanData;
  PostLeadPanResponseModel? get getPostLeadPaneData => _getPostLeadPanData;


  VerifyOtpResponce? _getVerifyData;

  VerifyOtpResponce? get getVerifyData => _getVerifyData;

  BankListResponceModel? _getBankListData;

  BankListResponceModel? get getBankListData => _getBankListData;

  BankDetailsResponceModel? _getBankDetailsData;

  BankDetailsResponceModel? get getBankDetailsData => _getBankDetailsData;

  PersonalDetailsResponce? _getPersonalDetailsData;

  PersonalDetailsResponce? get getPersonalDetailsData => _getPersonalDetailsData;

  AllStateResponce? _getAllStateData;

  AllStateResponce? get getAllStateData => _getAllStateData;

  List<CityResponce>? _getAllCityData;List<CityResponce> ? get getAllCityData => _getAllCityData;



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

  Future<void> verifyOtp(VarifayOtpRequest verifayOtp) async {
    _getVerifyData = await apiService.verifyOtp(verifayOtp);
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

  Future<void> getFathersNameByValidPanCard(String panNumber) async {
    _getFathersNameByValidPanCardData =
        await apiService.getFathersNameByValidPanCard(panNumber);
    notifyListeners();
  }

  Future<void> postSingleFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getPostSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> postLeadPAN(
      PostLeadPanRequestModel postLeadPanRequestModel) async {
    _getPostLeadPanData = await apiService.postLeadPAN(postLeadPanRequestModel);
    notifyListeners();
  }

  Future<void> getBankList() async {
    _getBankListData = await apiService.getBankList();
    notifyListeners();
  }

  Future<void> getBankDetails(int leadID) async {
    _getBankDetailsData = await apiService.GetLeadBankDetail(leadID);
    notifyListeners();
  }


  Future<void> getLeadPersonalDetails(String leadID) async {
    _getPersonalDetailsData = await apiService.getLeadPersnalDetails(leadID);
    notifyListeners();
  }

  Future<void> getAllState() async {
    _getAllStateData = await apiService.getAllState();
    notifyListeners();
  }

  Future<void> getAllCity(int stateID) async {
    _getAllCityData = await apiService.GetCityByStateId(stateID);
    notifyListeners();
  }
}

