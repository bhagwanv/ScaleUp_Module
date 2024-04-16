import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:scale_up_module/api/ApiUrls.dart';
import 'package:scale_up_module/utils/InternetConnectivity.dart';
import 'package:scale_up_module/utils/constants.dart';
import 'package:scale_up_module/view/aadhaar_screen/models/ValidateAadhaarOTPResponseModel.dart';
import 'package:scale_up_module/view/login_screen/model/GenrateOptResponceModel.dart';
import 'package:scale_up_module/view/profile_screen/model/OfferPersonNameResponceModel.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import '../shared_preferences/SharedPref.dart';
import '../view/aadhaar_screen/models/LeadAadhaarResponse.dart';
import '../view/aadhaar_screen/models/ValidateAadhaarOTPRequestModel.dart';
import '../view/agreement_screen/model/AggrementDetailsResponce.dart';
import '../view/agreement_screen/model/CheckSignResponceModel.dart';
import '../view/bank_details_screen/model/BankDetailsResponceModel.dart';
import '../view/bank_details_screen/model/BankListResponceModel.dart';
import '../view/bank_details_screen/model/SaveBankDetailResponce.dart';
import '../view/bank_details_screen/model/SaveBankDetailsRequestModel.dart';
import '../view/business_details_screen/model/CustomerDetailUsingGSTResponseModel.dart';
import '../view/business_details_screen/model/LeadBusinessDetailResponseModel.dart';
import '../view/business_details_screen/model/PostLeadBuisnessDetailRequestModel.dart';
import '../view/business_details_screen/model/PostLeadBuisnessDetailResponsModel.dart';
import '../view/otp_screens/model/VarifayOtpRequest.dart';
import '../view/otp_screens/model/VerifyOtpResponce.dart';
import '../view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import '../view/aadhaar_screen/models/AadhaarGenerateOTPResponseModel.dart';
import '../view/pancard_screen/model/LeadPanResponseModel.dart';
import '../view/pancard_screen/model/PostLeadPANRequestModel.dart';
import '../view/pancard_screen/model/PostLeadPANResponseModel.dart';
import '../view/pancard_screen/model/PostSingleFileResponseModel.dart';
import '../view/pancard_screen/model/ValidPanCardResponsModel.dart';
import '../view/personal_info/model/AllStateResponce.dart';
import '../view/personal_info/model/CityResponce.dart';
import '../view/personal_info/model/EmailExistRespoce.dart';
import '../view/personal_info/model/OTPValidateForEmailRequest.dart';
import '../view/personal_info/model/PersonalDetailsRequestModel.dart';
import '../view/personal_info/model/PersonalDetailsResponce.dart';
import '../view/personal_info/model/PostPersonalDetailsResponseModel.dart';
import '../view/personal_info/model/SendOtpOnEmailResponce.dart';
import '../view/personal_info/model/ValidEmResponce.dart';
import '../view/profile_screen/model/AcceptedResponceModel.dart';
import '../view/profile_screen/model/OfferResponceModel.dart';
import '../view/splash_screen/model/LeadCurrentRequestModel.dart';
import '../view/take_selfi/model/LeadSelfieResponseModel.dart';
import '../view/take_selfi/model/PostLeadSelfieRequestModel.dart';
import '../view/take_selfi/model/PostLeadSelfieResponseModel.dart';
import 'Interceptor.dart';
import '../view/splash_screen/model/LeadCurrentResponseModel.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final apiUrls = ApiUrls();
  final interceptor = Interceptor();
  final internetConnectivity = InternetConnectivity();

  Future<GetLeadResponseModel> getLeads(
      String mobile, int productId, int companyId, int leadId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(Uri.parse(
          '${apiUrls.baseUrl + apiUrls.getLeadCurrentActivity}?MobileNo=$mobile&ProductId=$productId&CompanyId=$companyId&LeadId=$leadId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final GetLeadResponseModel responseModel =
            GetLeadResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<LeadCurrentResponseModel> leadCurrentActivityAsync(
      LeadCurrentRequestModel leadCurrentRequestModel) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.post(
          Uri.parse('${apiUrls.baseUrl + apiUrls.leadCurrentActivityAsync}'),
          headers: {
            'Content-Type': 'application/json', // Set the content type as JSON
          },
          body: json.encode(leadCurrentRequestModel));
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final LeadCurrentResponseModel responseModel =
            LeadCurrentResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<LeadPanResponseModel> getLeadPAN(String userId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(
          Uri.parse('${apiUrls.baseUrl + apiUrls.getLeadPAN}?UserId=$userId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final LeadPanResponseModel responseModel =
            LeadPanResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<GenrateOptResponceModel> genrateOtp(
      String mobileNumber, int CompanyID) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(Uri.parse(
          '${apiUrls.baseUrl + apiUrls.generateOtp}?MobileNo=$mobileNumber&companyId=$CompanyID'));

      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final GenrateOptResponceModel responseModel =
            GenrateOptResponceModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<ValidPanCardResponsModel> getLeadValidPanCard(String panNumber) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.get(
        Uri.parse(
            '${apiUrls.baseUrl + apiUrls.getLeadValidPanCard}?PanNumber=$panNumber'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token'
          // Set the content type as JSON
        },
      );

      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final ValidPanCardResponsModel responseModel =
            ValidPanCardResponsModel.fromJson(jsonData);
        return responseModel;
      } else if (response.statusCode == 401) {
        return ValidPanCardResponsModel(statusCode: 401);
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<LeadAadhaarResponse> getLeadAadhar(String userId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(Uri.parse(
          '${apiUrls.baseUrl + apiUrls.getLeadAadhar}?UserId=$userId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final LeadAadhaarResponse responseModel =
            LeadAadhaarResponse.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<AadhaarGenerateOTPResponseModel> getLeadAadharGenerateOTP(
      AadhaarGenerateOTPRequestModel aadhaarGenerateOTPRequestModel) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse('${apiUrls.baseUrl + apiUrls.getLeadAadharGenerateOTP}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(aadhaarGenerateOTPRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final AadhaarGenerateOTPResponseModel responseModel =
            AadhaarGenerateOTPResponseModel.fromJson(jsonData);
        return responseModel;
      } else if (response.statusCode == 401) {
        print("Unauthorized access. Please login again.");
        return AadhaarGenerateOTPResponseModel(errorCode: 401);
      } else if (response.statusCode == 500) {
        print("Unauthorized access. Please login again.");
        return AadhaarGenerateOTPResponseModel(errorCode: 500);
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<ValidPanCardResponsModel> getFathersNameByValidPanCard(
      String panNumber) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.get(
        Uri.parse(
            '${apiUrls.baseUrl + apiUrls.getFathersNameByValidPanCard}?PanNumber=$panNumber'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token'
          // Set the content type as JSON
        },
      );
      //   headers: {"eyJhbGciOiJSUzI1NiIsImtpZCI6IkVENjQ5MzE3NjYwNkM0OTZDODIxOUU5OUYwMDhFOTM5RUMwMThGNDhSUzI1NiIsInR5cCI6ImF0K2p3dCJ9.eyJ1c2VySWQiOiJlNzM3MTVmYS1kMmUxLTQ4OGItYTBiZi0xZWNmZDRlNWQwNDIiLCJ1c2VybmFtZSI6Ijk1MjIzOTI4MDEiLCJsb2dnZWRvbiI6IjA0LzA1LzIwMjQgMTE6MTE6MzUiLCJzY29wZSI6ImNybUFwaSIsInVzZXJ0eXBlIjoiQ3VzdG9tZXIiLCJtb2JpbGUiOiI5NTIyMzkyODAxIiwiZW1haWwiOiIiLCJyb2xlcyI6IiIsImNvbXBhbnlpZCI6IjIiLCJwcm9kdWN0aWQiOiIyIiwibmJmIjoxNzEyMzE1NDk1LCJleHAiOjE3MTI0MDE4OTUsImlhdCI6MTcxMjMxNTQ5NSwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eS11YXQuc2NhbGV1cGZpbi5jb20iLCJhdWQiOiJjcm1BcGkifQ.mTi2DTiQi5-OINhBrdOprmrebkR2oZGVTtweDSvY6xNvL27SbE0f9-A-E8j2CPeBvOYXLeDABVMy15h3ZY7NngjEV3LW_ISx0-NVdpUtv5jRtbjmy-QA4j0qBiszz-UebAGpZFWoyYB5VuyOKv5nI6nDkAb4gPveI6FvCTJx7nmLrJBz8JnNWv2tSVziSWncyl5R4OvQpYtq6NWR1MEzCqATjeTQqEYrjF85bhzOEFU-mrihgupy7Smho-9Mtz58g0vHIQXexHg_lllvHVvBwmwHGdyzeYHyXscmjvageOZTyo5n6fsIGadrm1xGZpas43TL5zmWoU8y0EcbeMhy5w");}

      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final ValidPanCardResponsModel responseModel =
            ValidPanCardResponsModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<VerifyOtpResponce> verifyOtp(VarifayOtpRequest verifayOtp) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.post(
          Uri.parse('${apiUrls.baseUrl + apiUrls.LeadMobileValidate}'),
          headers: {
            'Content-Type': 'application/json', // Set the content type as JSON
          },
          body: json.encode(verifayOtp));
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final VerifyOtpResponce responseModel =
            VerifyOtpResponce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<PostSingleFileResponseModel> postSingleFile(
    File file,
    bool isValidForLifeTime,
    String? validityInDays,
    String? subFolderName,
  ) async {
    if (await internetConnectivity.networkConnectivity()) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${apiUrls.baseUrl + apiUrls.postSingleFile}'),
        );

        // Add file to the request
        var filePart = await http.MultipartFile.fromPath(
          'FileDetails', // Field name for the file
          file.path,
          filename: file.path.split('/').last,
        );
        request.files.add(filePart);

        // Add other form fields to the request
        request.fields['IsValidForLifeTime'] = isValidForLifeTime.toString();
        if (validityInDays != null) {
          request.fields['ValidityInDays'] = validityInDays;
        }
        if (subFolderName != null) {
          request.fields['SubFolderName'] = subFolderName;
        }

        // Send the request using a http.Client
        var client = http.Client();
        var streamedResponse = await client.send(request);

        // Get the response as a string
        var responseString = await streamedResponse.stream.bytesToString();

        // Check the response status code
        if (streamedResponse.statusCode == 200) {
          // Parse the JSON response
          var jsonData = jsonDecode(responseString);
          var responseModel = PostSingleFileResponseModel.fromJson(jsonData);
          return responseModel;
        } else {
          throw Exception(
              'Failed to upload file: ${streamedResponse.reasonPhrase}');
        }
      } catch (e) {
        throw Exception('Error uploading file: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<PostLeadPanResponseModel> postLeadPAN(
      PostLeadPanRequestModel postLeadPanRequestModel) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse('${apiUrls.baseUrl + apiUrls.postLeadPAN}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON// Set the content type as JSON
          },
          body: json.encode(postLeadPanRequestModel));
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final PostLeadPanResponseModel responseModel =
            PostLeadPanResponseModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        return PostLeadPanResponseModel(statusCode: 401);
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<BankListResponceModel> getBankList() async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(
        Uri.parse('${apiUrls.baseUrl + apiUrls.bankListApi}'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final BankListResponceModel responseModel =
            BankListResponceModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<BankDetailsResponceModel> GetLeadBankDetail(int leadID) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(
        Uri.parse(
            '${apiUrls.baseUrl + apiUrls.GetLeadBankDetail}?LeadId=$leadID'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final BankDetailsResponceModel responseModel =
            BankDetailsResponceModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<PersonalDetailsResponce> getLeadPersnalDetails(String userId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.get(
        Uri.parse(
            '${apiUrls.baseUrl + apiUrls.GetLeadPersonalDetail}?UserId=${userId}'),
        headers: {
          'Content-Type': 'application/json',
         // 'Authorization': 'Bearer $token'// Set the content type as JSON
          'Authorization': '$token'},
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final PersonalDetailsResponce responseModel =
            PersonalDetailsResponce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<AllStateResponce> getAllState() async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(
        Uri.parse('${apiUrls.baseUrl + apiUrls.GetAllState}'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final AllStateResponce responseModel =
            AllStateResponce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<List<CityResponce>> GetCityByStateId(int stateID) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(
        Uri.parse(
            '${apiUrls.baseUrl + apiUrls.GetCityByStateId}?stateId=$stateID'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final List<CityResponce> responseModel = List<CityResponce>.from(
            jsonData.map((model) => CityResponce.fromJson(model)));
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<ValidateAadhaarOTPResponseModel> validateAadhaarOtp(
      ValidateAadhaarOTPRequestModel verifayOtp) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse(apiUrls.baseUrl + apiUrls.postLeadAadharVerifyOTP),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(verifayOtp));
      if (kDebugMode) {
        print(response.body);
      } // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final ValidateAadhaarOTPResponseModel responseModel =
            ValidateAadhaarOTPResponseModel.fromJson(jsonData);
        return responseModel;
      } else if (response.statusCode == 401) {
        print("Unauthorized access. Please login again.");
        return ValidateAadhaarOTPResponseModel(statusCode: 401);
      } else if (response.statusCode == 500) {
        return ValidateAadhaarOTPResponseModel(statusCode: 500);
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }


  Future<EmailExistRespoce> emailExist(String userID,String EmailId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(
        Uri.parse('${apiUrls.baseUrl + apiUrls.EmailExist}?UserId=$userID&EmailId=$EmailId'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final EmailExistRespoce responseModel =
        EmailExistRespoce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
  Future<SendOtpOnEmailResponce> sendOtpOnEmail(String EmailId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(
        Uri.parse('${apiUrls.baseUrl + apiUrls.SendOtpOnEmail}?email=$EmailId'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final SendOtpOnEmailResponce responseModel =
        SendOtpOnEmailResponce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<ValidEmResponce> otpValidateForEmail(OtpValidateForEmailRequest model) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.post(
        Uri.parse('${apiUrls.baseUrl + apiUrls.OTPValidateForEmail}'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
          body: json.encode(model)

      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final ValidEmResponce responseModel =
        ValidEmResponce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<LeadSelfieResponseModel> getLeadSelfie(String userId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(Uri.parse(
          '${apiUrls.baseUrl + apiUrls.getLeadSelfie}?UserId=$userId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final LeadSelfieResponseModel responseModel =
        LeadSelfieResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<PostLeadSelfieResponseModel> postLeadSelfie(
      PostLeadSelfieRequestModel postLeadSelfieRequestModel) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse('${apiUrls.baseUrl + apiUrls.postLeadSelfie}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON// Set the content type as JSON
          },
          body: json.encode(postLeadSelfieRequestModel));
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final PostLeadSelfieResponseModel responseModel =
        PostLeadSelfieResponseModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        return PostLeadSelfieResponseModel(statusCode: 401);
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }


  Future<LeadBusinessDetailResponseModel> getLeadBusinessDetail(String userId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(Uri.parse('${apiUrls.baseUrl + apiUrls.getLeadBusinessDetail}?UserId=$userId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final LeadBusinessDetailResponseModel responseModel =
        LeadBusinessDetailResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<CustomerDetailUsingGstResponseModel> getCustomerDetailUsingGST(String GSTNumber ) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(Uri.parse('${apiUrls.baseUrl + apiUrls.getCustomerDetailUsingGST}?GSTNO=$GSTNumber'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final CustomerDetailUsingGstResponseModel responseModel =
        CustomerDetailUsingGstResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }


  Future<PostLeadBuisnessDetailResponsModel> postLeadBuisnessDetail(
      PostLeadBuisnessDetailRequestModel postLeadBuisnessDetailRequestModel) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse('${apiUrls.baseUrl + apiUrls.postLeadBuisnessDetail}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON// Set the content type as JSON
          },
          body: json.encode(postLeadBuisnessDetailRequestModel));
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final PostLeadBuisnessDetailResponsModel responseModel =
        PostLeadBuisnessDetailResponsModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        return PostLeadBuisnessDetailResponsModel(statusCode: 401);
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<PostPersonalDetailsResponseModel> postLeadPersonalDetail(
      PersonalDetailsRequestModel personalDetailsRequestModel) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse(apiUrls.baseUrl + apiUrls.postLeadSelfie),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON// Set the content type as JSON
          },
          body: json.encode(personalDetailsRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final PostPersonalDetailsResponseModel responseModel =
        PostPersonalDetailsResponseModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        return PostPersonalDetailsResponseModel(statusCode: 401);
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<SaveBankDetailResponce> saveLeadBankDetail(SaveBankDetailsRequestModel model) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse(apiUrls.baseUrl + apiUrls.saveLeadBankDetail),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON// Set the content type as JSON
          },
          body: json.encode(model));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final SaveBankDetailResponce responseModel =
        SaveBankDetailResponce.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        return SaveBankDetailResponce(statusCode: 401);
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
  Future<OfferResponceModel> GetLeadOffer(int leadId ,int companyID) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.get(Uri.parse('${apiUrls.baseUrl + apiUrls.GetLeadOffer}?LeadId=$leadId&companyId=$companyID'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final OfferResponceModel responseModel =
        OfferResponceModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
  Future<OfferPersonNameResponceModel> GetLeadName(String UserId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.get(Uri.parse('${apiUrls.baseUrl + apiUrls.GetLeadName}?UserId=$UserId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final OfferPersonNameResponceModel responseModel =
        OfferPersonNameResponceModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
  Future<AcceptedResponceModel> getAcceptOffer(int leadId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.get(Uri.parse('${apiUrls.baseUrl + apiUrls.AcceptOffer}?leadId=$leadId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final AcceptedResponceModel responseModel =
        AcceptedResponceModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
  Future<CheckSignResponceModel> checkEsignStatus(int leadId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.get(Uri.parse('${apiUrls.baseUrl + apiUrls.CheckEsignStatus}?leadId=$leadId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final CheckSignResponceModel responseModel =
        CheckSignResponceModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
  Future<AggrementDetailsResponce> GetAgreemetDetail(int leadId,bool accept,int companyID) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.get(Uri.parse('${apiUrls.baseUrl + apiUrls.GetAgreemetDetail}?leadId=$leadId&IsAccept=$accept&companyId=$companyID'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final AggrementDetailsResponce responseModel =
        AggrementDetailsResponce.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
