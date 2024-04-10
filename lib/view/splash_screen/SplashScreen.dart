import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scale_up_module/api/ApiService.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/constants.dart';
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
    final prefsUtil = await SharedPref.getInstance();
    await prefsUtil.saveString(LOGIN_MOBILE_NUMBER, '7803994667');
    await prefsUtil.saveInt(COMPANY_ID, 2);
    await prefsUtil.saveInt(PRODUCT_ID, 2);
    final String? mobile = prefsUtil.getString(LOGIN_MOBILE_NUMBER);

    //lead id
    var leadId = 0;
    var userID = "";
    if (prefsUtil.getInt(LEADE_ID) != null) {
      leadId = prefsUtil.getInt(LEADE_ID)!;
    }
    if (prefsUtil.getString(USER_ID) != null) {
      userID = prefsUtil.getString(USER_ID)!;
    }

    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      print("dsdsdd::: $mobile");
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: leadId,
        mobileNo: mobile,
        activityId: 0,
        subActivityId: 0,
        userId: userID,
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData =
          await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
              as LeadCurrentResponseModel?;
      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          mobile!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          leadId) as GetLeadResponseModel?;

      prefsUtil.saveString(USER_ID, getLeadData!.userId!);
      prefsUtil.saveInt(LEADE_ID, getLeadData!.leadId!);
      customerSequence(context, getLeadData, leadCurrentActivityAsyncData);
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
