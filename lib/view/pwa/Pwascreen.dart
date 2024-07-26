

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scale_up_module/view/profile_screen/components/ShowOffersScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../api/ApiService.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/PwaModel.dart';


class Pwascreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  const Pwascreen(
      {super.key, required this.activityId, required this.subActivityId});

  @override
  State<Pwascreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<Pwascreen> {
  PwaModel? pwaModel;
  bool ischeckBoxCheck = false;



  @override
  void initState() {
    super.initState();
    callApi(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pwaModel!=null ? Container(
                      height: 550,
                      width: MediaQuery.of(context).size.width,
                      child: WebViewWidget(
                          controller: WebViewController()
                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                            ..setBackgroundColor(const Color(0x00000000))
                            ..setNavigationDelegate(
                              NavigationDelegate(
                                onProgress: (int progress) {
                                },
                                onPageStarted: (String url) {
                                },
                                onPageFinished: (String url) {

                                },
                                onWebResourceError: (WebResourceError error) {
                                },
                              ),
                            )
                            ..loadRequest(
                                Uri.parse(pwaModel!.result!)))) :  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Image.asset('assets/images/scalup_gif_logo.gif')),
                  ],
                ),
              SizedBox(
                height: 30.0,
              ),
              CommonElevatedButton(
                onPressed: () {
                  callApi(context);
                },
                text: 'Next',
                upperCase: true,
              ),
            ],
          ),
                ),
              ),
        ));
    ;
  }

  void callApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    pwaModel = await ApiService().pwaData(leadId!,context);
    if(pwaModel!.isSuccess!) {
      if (pwaModel!.message == "Activity Completed") {
        //fetchData(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ShowOffersScreen(
                  activityId: widget.activityId,
                  subActivityId: widget.subActivityId,
                  pageType: "pushReplacement")),
        );
      } else {
        setState(() {

        });
      }
    }

  }

  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        userId: prefsUtil.getString(USER_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData = await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)as LeadCurrentResponseModel?;

      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

}