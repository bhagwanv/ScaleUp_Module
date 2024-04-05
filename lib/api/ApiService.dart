import 'dart:convert';
import 'dart:ffi';
import 'package:scale_up_module/api/ApiUrls.dart';
import 'package:scale_up_module/utils/InternetConnectivity.dart';
import 'package:scale_up_module/view/login_screen/model/GenrateOptResponceModel.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import '../view/pancard_screen/model/LeadPanResponseModel.dart';
import '../view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'Interceptor.dart';
import '../view/splash_screen/model/LeadCurrentResponseModel.dart';

class ApiService {
  final apiUrls = ApiUrls();
  final interceptor = Interceptor();
  final internetConnectivity = InternetConnectivity();

  Future<GetLeadResponseModel> getLeads(
      int mobile, int productId, int companyId, int leadId) async {
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
        final GenrateOptResponceModel responseModel = GenrateOptResponceModel.fromJson(
            jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
