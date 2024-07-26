
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../login_screen/components/LoginForm.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/AggrementDetailsResponce.dart';

class AgreementScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final String? pageType;

  const AgreementScreen(
      {super.key, required this.activityId, required this.subActivityId, this.pageType});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  AggrementDetailsResponce? aggrementDetails;
  bool ischeckBoxCheck = false;
  var isLoading = true;

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
          child: Consumer<DataProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.getCheckSignData == null && isLoading) {
                  return Loader();
                } else {
                  if (productProvider.getCheckSignData != null && isLoading) {
                    Navigator.of(context, rootNavigator: true).pop();
                    isLoading = false;
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {});
                    });
                  }

                  if (productProvider.getCheckSignData != null) {
                    productProvider.getCheckSignData!.when(
                      success: (CheckSignResponceModel) async {
                        var eSignModel = CheckSignResponceModel;
                        if (eSignModel.result!) {
                          await fetchData(context);
                        } else {
                          await callAggrementDetailsApi(false, context,false);
                        }
                      },
                      failure: (exception) {
                        if (exception is ApiException) {
                          if(exception.statusCode==401){
                            productProvider.disposeAllProviderData();
                            ApiService().handle401(context);
                          }else{
                            Utils.showToast(exception.errorMessage,context);
                          }
                        }

                      },
                    );
                  }

                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16.0,
                          ),
                          Center(
                            child: Text(
                              "Agreement",
                              style: TextStyle(
                                fontSize: 40.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          aggrementDetails != null
                              ? Container(
                              height: 500,
                              width: MediaQuery.of(context).size.width,
                              child: WebViewWidget(
                                  controller: WebViewController()
                                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                    ..setBackgroundColor(const Color(0x00000000))

                                    ..setNavigationDelegate(
                                      NavigationDelegate(
                                        onProgress: (int progress) {
                                          // Update loading bar.
                                        },
                                        onPageStarted: (String url) {
                                        },
                                        onPageFinished: (String url) {
                                        },
                                        onWebResourceError:
                                            (WebResourceError error) {},
                                      ),
                                    )
                                    ..loadRequest(
                                        Uri.parse(aggrementDetails!.response!)))) : Container(),
                          SizedBox(
                            height: 30.0,
                          ),
                          CommonElevatedButton(
                            onPressed: () async {
                              await callAggrementDetailsApi(true, context,true);
                            },
                            text: 'Next',
                            upperCase: true,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
        ));
  }

  void callApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<DataProvider>(context, listen: false).checkEsignStatus(leadId!);
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
      leadCurrentActivityAsyncData =
      await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
      as LeadCurrentResponseModel?;

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

  Future<void> callAggrementDetailsApi(
      bool accept,
      BuildContext context,
      bool isSubmit,
      ) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final int? companyID = prefsUtil.getInt(COMPANY_ID);
   // Utils.onLoading(context,"");
    aggrementDetails = await ApiService().GetAgreemetDetail(leadId!, accept, companyID!,context);
  //  Navigator.of(context, rootNavigator: true).pop();

    if(isSubmit){
      await fetchData(context);
    }else{
      /*setState(() {
      });*/
    }
  }
}


