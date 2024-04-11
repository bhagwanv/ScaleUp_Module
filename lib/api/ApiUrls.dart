class ApiUrls{

  final String baseUrl = 'https://gateway-uat.scaleupfin.com';
  final String getLeadCurrentActivity="/services/lead/v1/GetLeadCurrentActivity";
  final String leadCurrentActivityAsync="/aggregator/LeadAgg/LeadCurrentActivityAsync";
  final String getLeadPAN="/aggregator/LeadAgg/GetLeadPAN";
  final String generateOtp="/aggregator/LeadAgg/GenerateOtp";
  final String getLeadValidPanCard="/services/kyc/v1/KYCDoc/GetLeadValidPanCard";
  final String getLeadAadhar="/aggregator/LeadAgg/GetLeadAadhar";
  final String getLeadAadharGenerateOTP="/services/kyc/v1/KYCDoc/GetLeadAadharGenerateOTP";
  final String postLeadAadharVerifyOTP="/services/lead/v1/PostLeadAadharVerifyOTP";
  final String getFathersNameByValidPanCard="/services/kyc/v1/KYCDoc/GetFathersNameByValidPanCard";
  final String postSingleFile="/services/media/v1/PostSingleFile";
  final String postLeadPAN="/services/lead/v1/PostLeadPAN";
  final String LeadMobileValidate="/aggregator/LeadAgg/LeadMobileValidate";
  final String bankListApi="/services/lead/v1/api/eNach/BankList";
  final String GetLeadBankDetail="/services/lead/v1/api/LeadBankDetail/GetLeadBankDetail";
  final String GetLeadPersonalDetail="/aggregator/LeadAgg/GetLeadPersonalDetail";
  final String GetAllState="/services/location/v1/State/GetAllState";
  final String GetCityByStateId="/services/location/v1/City/GetCityByStateId";
  final String getLeadSelfie="/aggregator/LeadAgg/GetLeadSelfie";
  final String postLeadSelfie="/services/lead/v1/PostLeadSelfie";
  final String EmailExist="/services/kyc/v1/KYCDoc/EmailExist";
  final String SendOtpOnEmail="/aggregator/LeadAgg/SendOtpOnEmail";
  final String OTPValidateForEmail="/aggregator/LeadAgg/OTPValidateForEmail";

}