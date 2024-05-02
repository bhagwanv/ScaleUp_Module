class ApiUrls{

  //final String baseUrl = 'https://gateway-uat.scaleupfin.com';
  final String baseUrl = 'https://gateway-qa.scaleupfin.com';
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
  final String GetAllState="/services/location/v1/State/GetAllState";
  final String GetCityByStateId="/services/location/v1/City/GetCityByStateId";
  final String getLeadSelfie="/aggregator/LeadAgg/GetLeadSelfie";
  final String postLeadSelfie="/services/lead/v1/PostLeadSelfie";
  final String EmailExist="/services/kyc/v1/KYCDoc/EmailExist";
  final String SendOtpOnEmail="/aggregator/LeadAgg/SendOtpOnEmail";
  final String OTPValidateForEmail="/aggregator/LeadAgg/OTPValidateForEmail";
  final String GetLeadPersonalDetail="/aggregator/LeadAgg/GetLeadPersonalDetail";
  final String PostLeadPersonalDetail="/services/lead/v1/PostLeadPersonalDetail";
  final String getLeadBusinessDetail="/aggregator/LeadAgg/GetLeadBusinessDetail";
  final String getCustomerDetailUsingGST="/aggregator/LeadAgg/GetCustomerDetailUsingGST";
  final String postLeadBuisnessDetail="/services/lead/v1/PostLeadBuisnessDetail";
  final String saveLeadBankDetail="/services/lead/v1/api/LeadBankDetail/SaveLeadBankDetail";
  final String GetLeadOffer="/aggregator/LeadAgg/GetLeadOffer";
  final String GetLeadName="/aggregator/LeadAgg/GetLeadName";
  final String AcceptOffer="/aggregator/LeadAgg/AcceptOffer";
  final String CheckEsignStatus="/services/lead/v1/NBFCSchedular/CheckEsignStatus";
  final String GetAgreemetDetail="/aggregator/LeadAgg/GetAgreemetDetail";
  final String GetDisbursementProposal="/aggregator/LeadAgg/GetDisbursementProposal";
  final String GetDisbursement="/aggregator/LeadAgg/GetDisbursement";
  final String getCustomerOrderSummary="/services/loanaccount/v1/GetCustomerOrderSummary";
  final String getCustomerTransactionList="/services/loanaccount/v1/GetCustomerTransactionList";
  final String getCustomerOrderSummaryForAnchor="/services/loanaccount/v1/GetCustomerOrderSummaryForAnchor";
  final String getCustomerTransactionListTwo="/services/loanaccount/v1/GetCustomerTransactionListTwo";

}