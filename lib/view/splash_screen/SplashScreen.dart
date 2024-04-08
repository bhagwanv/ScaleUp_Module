import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scale_up_module/api/ApiService.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/customer_sequence_logic.dart';
import 'model/LeadCurrentResponseModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Scaleup')),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/scalup_gif_logo.gif')),
          ],
        ));
  }

  Future<void> fetchData() async {
    String? mobile = "8959311437";
    SharedPref sharedPref = SharedPref();
    sharedPref.save(sharedPref.LOGIN_MOBILE_NUMBER, mobile);

    sharedPref.getString(sharedPref.LOGIN_MOBILE_NUMBER).then((value) {
      mobile = value;
    });
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;

      print("mobile::: ${mobile}");
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: 2,
        productId: 2,
        leadId: 0,
        mobileNo: mobile,
        activityId: 0,
        subActivityId: 0,
        userId: "",
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData = await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel) as LeadCurrentResponseModel?;
      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(mobile!, 2, 2, 0) as GetLeadResponseModel?;

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData);



    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
