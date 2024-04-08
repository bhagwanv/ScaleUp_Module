import 'dart:convert';
import 'dart:ffi';
import 'package:scale_up_module/api/ApiUrls.dart';
import 'package:scale_up_module/utils/InternetConnectivity.dart';
import 'package:scale_up_module/view/login_screen/model/GenrateOptResponceModel.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import '../view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import '../view/aadhaar_screen/models/AadhaarGenerateOTPResponseModel.dart';
import '../view/pancard_screen/model/LeadPanResponseModel.dart';
import '../view/pancard_screen/model/ValidPanCardResponsModel.dart';
import '../view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'Interceptor.dart';
import '../view/splash_screen/model/LeadCurrentResponseModel.dart';

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
              'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkVENjQ5MzE3NjYwNkM0OTZDODIxOUU5OUYwMDhFOTM5RUMwMThGNDhSUzI1NiIsInR5cCI6ImF0K2p3dCJ9.eyJ1c2VySWQiOiJlNzM3MTVmYS1kMmUxLTQ4OGItYTBiZi0xZWNmZDRlNWQwNDIiLCJ1c2VybmFtZSI6Ijk1MjIzOTI4MDEiLCJsb2dnZWRvbiI6IjA0LzA4LzIwMjQgMDU6MzQ6MjAiLCJzY29wZSI6ImNybUFwaSIsInVzZXJ0eXBlIjoiQ3VzdG9tZXIiLCJtb2JpbGUiOiI5NTIyMzkyODAxIiwiZW1haWwiOiIiLCJyb2xlcyI6IiIsImNvbXBhbnlpZCI6IjIiLCJwcm9kdWN0aWQiOiIyIiwibmJmIjoxNzEyNTU0NDYwLCJleHAiOjE3MTI2NDA4NjAsImlhdCI6MTcxMjU1NDQ2MCwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eS11YXQuc2NhbGV1cGZpbi5jb20iLCJhdWQiOiJjcm1BcGkifQ.PYqOJsgsTyUsdanHTCkrPA6msGsaZZAWog0uzNcUgf1NrHE66g-G09mH41OrNnxZL-4Di1LxEFHfV7saPQE55_5F7s2YYQaXMBDT5G9oMd5c7MBbFo2WbzkU98qYaUqAZbVcmRG-f9h_OHgAQehE3Ud90tEt0vaENnzv8RxRI8FgubapUegTKutqlgxy755s_4Q3_Ygomb0hc-hK3RD0lYBII66e1Bo6cc3VVOvlMYpPSFLehn0E3oMo7uVLld3KrPGXc-0aGTYduLXJ9dnMdKdAFGfANp4ep3s13md1nxBeANyXpn2oyN5UJ2NequrQroJIOw9LuzyySgkkzJ9vcw'
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

  Future<ValidPanCardResponsModel> getLeadAadhar(String userId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.get(Uri.parse(
          '${apiUrls.baseUrl + apiUrls.getLeadAadhar}?UserId=$userId'));
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

  Future<AadhaarGenerateOTPResponseModel> getLeadAadharGenerateOTP(
      AadhaarGenerateOTPRequestModel aadhaarGenerateOTPRequestModel) async {
    if (await internetConnectivity.networkConnectivity()) {
      final response = await interceptor.post(
          Uri.parse('${apiUrls.baseUrl + apiUrls.getLeadAadharGenerateOTP}'),
          headers: {
            'Content-Type': 'application/json', // Set the content type as JSON
          },
          body: json.encode(aadhaarGenerateOTPRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final AadhaarGenerateOTPResponseModel responseModel =
            AadhaarGenerateOTPResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
