import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../data_provider/DataProvider.dart';
import '../../../shared_preferences/SharedPref.dart';
import '../../../utils/Utils.dart';
import '../../../utils/common_elevted_button.dart';
import '../../../utils/constants.dart';
import '../../../utils/customer_sequence_logic.dart';
import '../../../utils/loader.dart';
import '../../splash_screen/model/GetLeadResponseModel.dart';
import '../../splash_screen/model/LeadCurrentRequestModel.dart';
import '../../splash_screen/model/LeadCurrentResponseModel.dart';
import '../model/DisbursementCompletedResponse.dart';

class DisbursementCompleted extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final bool isDisbursement;

  const DisbursementCompleted(
      {super.key,
        required this.activityId,
        required this.subActivityId,
        required this.isDisbursement});

  @override
  State<DisbursementCompleted> createState() => _DisbursementCompletedState();
}

class _DisbursementCompletedState extends State<DisbursementCompleted> {
  late DisbursementCompletedResponse? disbursementResponce = null;
  var isLoading = true;
  var congratulations = "";

  @override
  void initState() {
    super.initState();
    callDisbursementApi(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Consumer<DataProvider>(builder: (context, productProvider, child) {
          if (productProvider.getDisbursementData == null && isLoading) {
            return Center(child: Loader());
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            isLoading = false;
            if (productProvider.getDisbursementData != null) {
              productProvider.getDisbursementData!.when(
                success: (DisbursementCompletedResponse) {
                  disbursementResponce = DisbursementCompletedResponse;
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
            return Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      child: SvgPicture.asset(
                          'assets/images/dis_completed.svg'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Thank You For Choosing Us!Your Disbursement Amount",
                          style: TextStyle(color: kPrimaryColor, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        disbusmentWidget(),
                      ],
                    ),
                    SizedBox(height: 30),
                    CommonElevatedButton(
                      onPressed: () async {},
                      text: "Next",
                      upperCase: true,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  void callDisbursementApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<DataProvider>(context, listen: false).GetDisbursement(leadId!);
  }

  Widget disbusmentWidget() {
    if (disbursementResponce != null) {
      if (disbursementResponce!.status!) {
        return Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Text(
                "₹ ${disbursementResponce!.response?.disbursalAmount.toString()}",
                style: TextStyle(color: Colors.black, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      } else {
        return Container();
      }
    } else {
      return Container();
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
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        userId: prefsUtil.getString(USER_ID),
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
}