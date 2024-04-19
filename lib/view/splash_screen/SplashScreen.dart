import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scale_up_module/api/ApiService.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/Utils.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../login_screen/login_screen.dart';
import 'model/LeadCurrentResponseModel.dart';

class SplashScreen extends StatefulWidget {
  var mobileNumber;
  int companyID;
  int ProductID;
   SplashScreen({super.key,required this.mobileNumber,required this.companyID,required this.ProductID});

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

    final String? mobile = widget.mobileNumber.toString();
    Utils.showToast("Splash:: "+mobile.toString());
    final prefsUtil = await SharedPref.getInstance();
    /*await prefsUtil.saveInt(COMPANY_ID, int.parse(widget.companyID));
    await prefsUtil.saveInt(PRODUCT_ID, int.parse(widget.ProductID));
    await prefsUtil.saveString(LOGIN_MOBILE_NUMBER, widget.mobileNumber.toString());*/

    //lead id
    var leadId = 0;
    var userID = "";
    if (prefsUtil.getInt(LEADE_ID) != null) {
      leadId = prefsUtil.getInt(LEADE_ID)!;
    }
    if (prefsUtil.getString(USER_ID) != null) {
      userID = prefsUtil.getString(USER_ID)!;
    }

    if(mobile == null || prefsUtil.getString(USER_ID) == null || prefsUtil.getInt(LEADE_ID) == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen(activityId: 1, subActivityId: 0,companyID: widget.companyID,ProductID: widget.ProductID, MobileNumber:widget.mobileNumber)),
      );
    } else {
      try {
        LeadCurrentResponseModel? leadCurrentActivityAsyncData;
        var leadCurrentRequestModel = LeadCurrentRequestModel(
          companyId: widget.companyID,
          productId: widget.ProductID,
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
        await ApiService().leadCurrentActivityAsync(
            leadCurrentRequestModel) as LeadCurrentResponseModel?;
        GetLeadResponseModel? getLeadData;
        getLeadData = await ApiService().getLeads(
            mobile!,
            widget.companyID,
            widget.ProductID,
            leadId) as GetLeadResponseModel?;
        if (getLeadData!.userId != null){
          prefsUtil.saveString(USER_ID, getLeadData.userId!);
        }else{
          prefsUtil.saveString(USER_ID, "");
        }
        prefsUtil.saveInt(LEADE_ID, getLeadData!.leadId!);

        customerSequence(context, getLeadData, leadCurrentActivityAsyncData);
      } catch (error) {
        if (kDebugMode) {
          print('Error occurred during API call: $error');
        }
      }
    }
  }
}
