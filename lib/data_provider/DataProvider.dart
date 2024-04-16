
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:scale_up_module/view/aadhaar_screen/models/ValidateAadhaarOTPRequestModel.dart';
import 'package:scale_up_module/view/aadhaar_screen/models/ValidateAadhaarOTPResponseModel.dart';
import 'package:scale_up_module/view/pancard_screen/model/PostLeadPANRequestModel.dart';
import 'package:scale_up_module/view/pancard_screen/model/PostSingleFileResponseModel.dart';
import 'package:scale_up_module/view/personal_info/model/PostPersonalDetailsResponseModel.dart';

import '../api/ApiService.dart';
import '../api/ExceptionHandling.dart';
import '../view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import '../view/aadhaar_screen/models/AadhaarGenerateOTPResponseModel.dart';
import '../view/aadhaar_screen/models/LeadAadhaarResponse.dart';
import '../view/bank_details_screen/model/BankDetailsResponceModel.dart';
import '../view/bank_details_screen/model/BankListResponceModel.dart';
import '../view/business_details_screen/model/CustomerDetailUsingGSTResponseModel.dart';
import '../view/business_details_screen/model/LeadBusinessDetailResponseModel.dart';
import '../view/business_details_screen/model/PostLeadBuisnessDetailRequestModel.dart';
import '../view/business_details_screen/model/PostLeadBuisnessDetailResponsModel.dart';
import '../view/login_screen/model/GenrateOptResponceModel.dart';
import '../view/otp_screens/model/VarifayOtpRequest.dart';
import '../view/otp_screens/model/VerifyOtpResponce.dart';
import '../view/pancard_screen/model/FathersNameByValidPanCardResponseModel.dart';
import '../view/pancard_screen/model/LeadPanResponseModel.dart';
import '../view/pancard_screen/model/PostLeadPANResponseModel.dart';
import '../view/pancard_screen/model/ValidPanCardResponsModel.dart';
import '../view/personal_info/model/AllStateResponce.dart';
import '../view/personal_info/model/CityResponce.dart';
import '../view/personal_info/model/EmailExistRespoce.dart';
import '../view/personal_info/model/OTPValidateForEmailRequest.dart';
import '../view/personal_info/model/PersonalDetailsRequestModel.dart';
import '../view/personal_info/model/PersonalDetailsResponce.dart';
import '../view/personal_info/model/SendOtpOnEmailResponce.dart';
import '../view/personal_info/model/ValidEmResponce.dart';
import '../view/splash_screen/model/GetLeadResponseModel.dart';
import '../view/splash_screen/model/LeadCurrentRequestModel.dart';
import '../view/splash_screen/model/LeadCurrentResponseModel.dart';
import '../view/take_selfi/model/LeadSelfieResponseModel.dart';
import '../view/take_selfi/model/PostLeadSelfieRequestModel.dart';
import '../view/take_selfi/model/PostLeadSelfieResponseModel.dart';

class DataProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();


  GetLeadResponseModel? _getLeadData;

  GetLeadResponseModel? get getLeadData => _getLeadData;

  LeadCurrentResponseModel? _leadCurrentActivityAsyncData;

  LeadCurrentResponseModel? get leadCurrentActivityAsyncData =>
      _leadCurrentActivityAsyncData;
  GenrateOptResponceModel? _genrateOptData;

  GenrateOptResponceModel? get genrateOptData => _genrateOptData;

  Result< LeadPanResponseModel, Exception>? _getLeadPANData;
  Result< LeadPanResponseModel, Exception>? get getLeadPANData => _getLeadPANData;

  Result<ValidPanCardResponsModel,Exception>? _getLeadValidPanCardData;
  Result<ValidPanCardResponsModel,Exception>? get getLeadValidPanCardData =>
      _getLeadValidPanCardData;

  LeadAadhaarResponse? _getLeadAadhaar;

  LeadAadhaarResponse? get getLeadAadhaar => _getLeadAadhaar;

  AadhaarGenerateOTPResponseModel? _getLeadAadharGenerateOTP;

  AadhaarGenerateOTPResponseModel? get getLeadAadharGenerateOTP => _getLeadAadharGenerateOTP;

  Result<FathersNameByValidPanCardResponseModel,Exception>? _getFathersNameByValidPanCardData;
  Result<FathersNameByValidPanCardResponseModel,Exception>? get getFathersNameByValidPanCardData => _getFathersNameByValidPanCardData;

  PostSingleFileResponseModel? _getPostSingleFileData;
  PostSingleFileResponseModel? get getPostSingleFileData => _getPostSingleFileData;

  PostSingleFileResponseModel? _getpostElectricityBillDocumentSingleFileData;
  PostSingleFileResponseModel? get getpostElectricityBillDocumentSingleFileData => _getpostElectricityBillDocumentSingleFileData;

  PostSingleFileResponseModel? _getpostBusineesDoumentSingleFileData;
  PostSingleFileResponseModel? get getpostBusineesDoumentSingleFileData => _getpostBusineesDoumentSingleFileData;

  PostSingleFileResponseModel? _getPostBackAadhaarSingleFileData;
  PostSingleFileResponseModel? get getPostBackAadhaarSingleFileData => _getPostBackAadhaarSingleFileData;

  PostSingleFileResponseModel? _getPostFrontAadhaarSingleFileData;
  PostSingleFileResponseModel? get getPostFrontAadhaarSingleFileData => _getPostFrontAadhaarSingleFileData;

  Result<PostLeadPanResponseModel,Exception>? _getPostLeadPanData;
  Result<PostLeadPanResponseModel,Exception>? get getPostLeadPaneData => _getPostLeadPanData;


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

  List<CityResponce?>? _getAllCityData;
  List<CityResponce?>? get getAllCityData => _getAllCityData;

  List<CityResponce?>? _getCurrentAllCityData;
  List<CityResponce?>? get getCurrentAllCityData => _getCurrentAllCityData;

  LeadSelfieResponseModel? _getLeadSelfieData;

  LeadSelfieResponseModel? get getLeadSelfieData => _getLeadSelfieData;

  PostLeadSelfieResponseModel? _getPostLeadSelfieData;

  PostLeadSelfieResponseModel? get getPostLeadSelfieData =>
      _getPostLeadSelfieData;

  ValidateAadhaarOTPResponseModel? _getValidateAadhaarOTPData;

  ValidateAadhaarOTPResponseModel? get getValidateAadhaarOTPData => _getValidateAadhaarOTPData;

  EmailExistRespoce? _getEmailExistData;

  EmailExistRespoce? get getEmailExistData => _getEmailExistData;

  SendOtpOnEmailResponce? _getOtpOnEmailData;

  SendOtpOnEmailResponce? get getOtpOnEmailData => _getOtpOnEmailData;

  ValidEmResponce? _getValidOtpEmailData;

  ValidEmResponce? get getValidOtpEmailData => _getValidOtpEmailData;

  PostPersonalDetailsResponseModel? _getPostPersonalDetailsResponseModel;

  PostPersonalDetailsResponseModel? get getPostPersonalDetailsResponseModel =>
      _getPostPersonalDetailsResponseModel;

  LeadBusinessDetailResponseModel? _getLeadBusinessDetailData;
  LeadBusinessDetailResponseModel? get getLeadBusinessDetailData => _getLeadBusinessDetailData;

  CustomerDetailUsingGstResponseModel? _getCustomerDetailUsingGSTData;
  CustomerDetailUsingGstResponseModel? get getCustomerDetailUsingGSTData => _getCustomerDetailUsingGSTData;

  PostLeadBuisnessDetailResponsModel? _getPostLeadBuisnessDetailData;
  PostLeadBuisnessDetailResponsModel? get getPostLeadBuisnessDetailData => _getPostLeadBuisnessDetailData;

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

  Future<void> postElectricityBillDocumentSingleFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getpostElectricityBillDocumentSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> PostFrontAadhaarSingleFileData(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getPostFrontAadhaarSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> postBusineesDoumentSingleFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getpostBusineesDoumentSingleFileData = await apiService.postSingleFile(
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

  Future<void> getCurrentAllCity(int stateID) async {
    _getCurrentAllCityData = await apiService.GetCityByStateId(stateID);
    notifyListeners();
  }

  Future<void> postAadhaarBackSingleFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getPostBackAadhaarSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> validateAadhaarOtp(ValidateAadhaarOTPRequestModel verifayOtp) async {
    _getValidateAadhaarOTPData = await apiService.validateAadhaarOtp(verifayOtp);
    notifyListeners();
  }

  Future<void> isEmailExist(String UserID,String Emailid) async {
    _getEmailExistData = await apiService.emailExist(UserID,Emailid);
    notifyListeners();
  }

  Future<void> getSendOtpOnEmail(String Emailid) async {
    _getOtpOnEmailData = await apiService.sendOtpOnEmail(Emailid);
    notifyListeners();
  }

  Future<void> otpValidateForEmail(OtpValidateForEmailRequest model) async {
    _getValidOtpEmailData = await apiService.otpValidateForEmail(model);
    notifyListeners();
  }

  Future<void> getLeadSelfie(String userId) async {
    _getLeadSelfieData = await apiService.getLeadSelfie(userId);
    notifyListeners();
  }

  Future<void> postLeadSelfie(
      PostLeadSelfieRequestModel postLeadSelfieRequestModel) async {
    _getPostLeadSelfieData =
    await apiService.postLeadSelfie(postLeadSelfieRequestModel);

  }

  Future<void> postLeadPersonalDetail(
      PersonalDetailsRequestModel personalDetailsRequestModel) async {
    _getPostPersonalDetailsResponseModel =
    await apiService.postLeadPersonalDetail(personalDetailsRequestModel);

  }

  Future<void> getLeadBusinessDetail(String userId) async {
    _getLeadBusinessDetailData = await apiService.getLeadBusinessDetail(userId);
    notifyListeners();
  }

  Future<void> getCustomerDetailUsingGST(String GSTNumber) async {
    _getCustomerDetailUsingGSTData = await apiService.getCustomerDetailUsingGST(GSTNumber);
    notifyListeners();
  }

  Future<void> postLeadBuisnessDetail(PostLeadBuisnessDetailRequestModel postLeadBuisnessDetailRequestModel) async {
    _getPostLeadBuisnessDetailData = await apiService.postLeadBuisnessDetail(postLeadBuisnessDetailRequestModel);
    notifyListeners();
  }
}

