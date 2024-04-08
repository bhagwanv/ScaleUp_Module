class ApiUrls{

  final String baseUrl = 'https://gateway-uat.scaleupfin.com';


  final String getLeadCurrentActivity="/services/lead/v1/GetLeadCurrentActivity";
  final String leadCurrentActivityAsync="/aggregator/LeadAgg/LeadCurrentActivityAsync";

  final String getLeadPAN="/aggregator/LeadAgg/GetLeadPAN";

  final String generateOtp="/aggregator/LeadAgg/GenerateOtp";
  final String getLeadValidPanCard="/services/kyc/v1/KYCDoc/GetLeadValidPanCard";
  final String getLeadAadhar="/aggregator/LeadAgg/GetLeadAadhar";
  final String getLeadAadharGenerateOTP="/services/kyc/v1/KYCDoc/GetLeadAadharGenerateOTP";
  final String getFathersNameByValidPanCard="/services/kyc/v1/KYCDoc/GetFathersNameByValidPanCard";
  final String postSingleFile="/services/media/v1/PostSingleFile";
  final String postLeadPAN="/services/lead/v1/PostLeadPAN";


}