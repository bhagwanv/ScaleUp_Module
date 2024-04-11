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
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import '../shared_preferences/SharedPref.dart';
import '../view/aadhaar_screen/models/LeadAadhaarResponse.dart';
import '../view/aadhaar_screen/models/ValidateAadhaarOTPRequestModel.dart';
import '../view/bank_details_screen/model/BankDetailsResponceModel.dart';
import '../view/bank_details_screen/model/BankListResponceModel.dart';
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
import '../view/personal_info/model/PersonalDetailsResponce.dart';
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
      final response = await interceptor.get(
        Uri.parse(
            '${apiUrls.baseUrl + apiUrls.getLeadValidPanCard}?PanNumber=$panNumber'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkVENjQ5MzE3NjYwNkM0OTZDODIxOUU5OUYwMDhFOTM5RUMwMThGNDhSUzI1NiIsInR5cCI6ImF0K2p3dCJ9.eyJ1c2VySWQiOiJlNzM3MTVmYS1kMmUxLTQ4OGItYTBiZi0xZWNmZDRlNWQwNDIiLCJ1c2VybmFtZSI6Ijk1MjIzOTI4MDEiLCJsb2dnZWRvbiI6IjA0LzA5LzIwMjQgMDY6NDc6NTkiLCJzY29wZSI6ImNybUFwaSIsInVzZXJ0eXBlIjoiQ3VzdG9tZXIiLCJtb2JpbGUiOiI5NTIyMzkyODAxIiwiZW1haWwiOiIiLCJyb2xlcyI6IiIsImNvbXBhbnlpZCI6IjIiLCJwcm9kdWN0aWQiOiIyIiwibmJmIjoxNzEyNjQ1Mjc5LCJleHAiOjE3MTI3MzE2NzksImlhdCI6MTcxMjY0NTI3OSwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eS11YXQuc2NhbGV1cGZpbi5jb20iLCJhdWQiOiJjcm1BcGkifQ.Os-9IT2eM_jkCPuzaLhfep_W5ggvZ-Hg7CRkox3uv_26uXpqrZxpwDO0iBz30oSw13RweSM9CCJlNp2Yt_Cw-0amzo488JtRogjG0aOmJ7lwzc6ed6z396BRGSBi1u3tLpeMJxrgLYBj8eOK-kyaUk9moV4JktjGYP-0T1ixP3U5Jr4-mT_voGLUXdscQTG8Mvkjd2jfLGsxnwP2HNrV0sIlgJN7cO0mXddUt9bm1Hgzd7PgwkyXZTOnYh46CNBszY7XEX6ZSdptGzrJe1upeZg2kSYVBTp2YwPRCvx7ZKA3xlkXdrK4F9WUOF5oHturar4nptgianOFQO0WFdBKRA'
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
      final response = await interceptor.post(
          Uri.parse('${apiUrls.baseUrl + apiUrls.getLeadAadharGenerateOTP}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkVENjQ5MzE3NjYwNkM0OTZDODIxOUU5OUYwMDhFOTM5RUMwMThGNDhSUzI1NiIsInR5cCI6ImF0K2p3dCJ9.eyJ1c2VySWQiOiIwMjQ3ODViYS1kNjRiLTQ1YmYtODJjOS0yZmNmNWE3ZWFiMWIiLCJ1c2VybmFtZSI6Ijc4MDM5OTQ2NjciLCJsb2dnZWRvbiI6IjA0LzEwLzIwMjQgMTI6NTc6MjkiLCJzY29wZSI6ImNybUFwaSIsInVzZXJ0eXBlIjoiQ3VzdG9tZXIiLCJtb2JpbGUiOiI3ODAzOTk0NjY3IiwiZW1haWwiOiJkZnNkQGdtYWlsLmNvbSIsInJvbGVzIjoiIiwiY29tcGFueWlkIjoiMiIsInByb2R1Y3RpZCI6IjIiLCJuYmYiOjE3MTI3NTM4NDksImV4cCI6MTcxMjg0MDI0OSwiaWF0IjoxNzEyNzUzODQ5LCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5zY2FsZXVwZmluLmNvbSIsImF1ZCI6ImNybUFwaSJ9.cNK1EVTwAxoC06LZYcqv6FQlj5tGgozgRaIbWxiMbD1ep89EMy2VsenKg8xmj6pw8uH11jNo3cWDBmhw2-MMgUAD7iiVWHAVkzUTeJqTWwFtXgJxMNdh0I_x-R9yaDRMBAqD2BeyvxPEaKJxU5I5wQFB4pG7u9O-xF9reV_KUoGQalCyqxOLs29Q-bRKhY-YtXZ0ktGj2vhW21fvJKsI5RELSCP1zdOqCNYGuVfC6oYsADnXd9HM-fBY9y_dYlEQPXrAQjdpA7bClLl4DI80Tal0QF6QH01AYY923m0'
          },
          body: json.encode(aadhaarGenerateOTPRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        print("ewewewewewee11111");
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final AadhaarGenerateOTPResponseModel responseModel =
            AadhaarGenerateOTPResponseModel.fromJson(jsonData);
        return responseModel;
      } else if (response.statusCode == 401) {
        print("Unauthorized access. Please login again.");
        return AadhaarGenerateOTPResponseModel(errorCode: 401);
        return AadhaarGenerateOTPResponseModel(statusCode: 401);
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
      final response = await interceptor.get(
        Uri.parse(
            '${apiUrls.baseUrl + apiUrls.getFathersNameByValidPanCard}?PanNumber=$panNumber'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkVENjQ5MzE3NjYwNkM0OTZDODIxOUU5OUYwMDhFOTM5RUMwMThGNDhSUzI1NiIsInR5cCI6ImF0K2p3dCJ9.eyJ1c2VySWQiOiJlNzM3MTVmYS1kMmUxLTQ4OGItYTBiZi0xZWNmZDRlNWQwNDIiLCJ1c2VybmFtZSI6Ijk1MjIzOTI4MDEiLCJsb2dnZWRvbiI6IjA0LzA5LzIwMjQgMDY6NDc6NTkiLCJzY29wZSI6ImNybUFwaSIsInVzZXJ0eXBlIjoiQ3VzdG9tZXIiLCJtb2JpbGUiOiI5NTIyMzkyODAxIiwiZW1haWwiOiIiLCJyb2xlcyI6IiIsImNvbXBhbnlpZCI6IjIiLCJwcm9kdWN0aWQiOiIyIiwibmJmIjoxNzEyNjQ1Mjc5LCJleHAiOjE3MTI3MzE2NzksImlhdCI6MTcxMjY0NTI3OSwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eS11YXQuc2NhbGV1cGZpbi5jb20iLCJhdWQiOiJjcm1BcGkifQ.Os-9IT2eM_jkCPuzaLhfep_W5ggvZ-Hg7CRkox3uv_26uXpqrZxpwDO0iBz30oSw13RweSM9CCJlNp2Yt_Cw-0amzo488JtRogjG0aOmJ7lwzc6ed6z396BRGSBi1u3tLpeMJxrgLYBj8eOK-kyaUk9moV4JktjGYP-0T1ixP3U5Jr4-mT_voGLUXdscQTG8Mvkjd2jfLGsxnwP2HNrV0sIlgJN7cO0mXddUt9bm1Hgzd7PgwkyXZTOnYh46CNBszY7XEX6ZSdptGzrJe1upeZg2kSYVBTp2YwPRCvx7ZKA3xlkXdrK4F9WUOF5oHturar4nptgianOFQO0WFdBKRA'
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
            '${apiUrls.baseUrl + apiUrls.GetLeadBankDetail}?PanNumber=$leadID'),
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

  Future<PersonalDetailsResponce> getLeadPersnalDetails(String leadID) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(
        Uri.parse(
            '${apiUrls.baseUrl + apiUrls.GetLeadPersonalDetail}?UserId=$leadID'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
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
      final response = await interceptor.post(
          Uri.parse(apiUrls.baseUrl + apiUrls.LeadMobileValidate),
          headers: {
            'Content-Type': 'application/json', // Set the content type as JSON
          },
          body: json.encode(verifayOtp));
      if (kDebugMode) {
        print(response.body);
      } // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final ValidateAadhaarOTPResponseModel responseModel =
            ValidateAadhaarOTPResponseModel.fromJson(jsonData);
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
}
