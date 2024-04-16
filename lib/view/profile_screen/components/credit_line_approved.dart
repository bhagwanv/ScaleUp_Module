

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/api/ApiService.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/view/Bank_details_screen/BankDetailsScreen.dart';
import 'package:scale_up_module/view/profile_screen/model/OfferPersonNameResponceModel.dart';
import 'package:scale_up_module/view/profile_screen/model/OfferResponceModel.dart';

import '../../../data_provider/DataProvider.dart';
import '../../../utils/common_elevted_button.dart';
import '../../../utils/constants.dart';
import '../../../utils/customer_sequence_logic.dart';
import '../../../utils/loader.dart';
import '../../splash_screen/model/GetLeadResponseModel.dart';
import '../../splash_screen/model/LeadCurrentRequestModel.dart';
import '../../splash_screen/model/LeadCurrentResponseModel.dart';

class CreditLineApproved extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  const CreditLineApproved(
      {super.key, required this.activityId, required this.subActivityId});

  @override
  State<CreditLineApproved> createState() => _CreditLineApprovedState();
}

class _CreditLineApprovedState extends State<CreditLineApproved> {
  OfferPersonNameResponceModel? offerNameResponceModel;
  OfferResponceModel? offerResponceModel;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    callApi(context);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child:  Consumer<DataProvider>(builder: (context, productProvider, child) {
        if (productProvider.getOfferResponceata == null && isLoading) {
          return Center(child: Loader());
        } else {
          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child:
                    SvgPicture.asset('assets/images/credit_line_approved.svg'),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Congratulations ${offerNameResponceModel?.response}!! ",
                        style: TextStyle(color: kPrimaryColor, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "You are qualified for credit limit of",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      productProvider.getOfferResponceata!.response!.processingFeePayableBy=="Anchor"
                          ? SetOfferWidget(productProvider)
                          : SetCutomerOfferWidget(productProvider),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CommonElevatedButton(
                    onPressed: () {

acceptOffer(context);
                      /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const BankDetailsScreen();
                      },
                    ),
                  );*/
                    },
                    text: "Proceed to e-mandate",
                    upperCase: true,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        }
      }),

    );
  }

  void callApi(BuildContext context)async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final String? userID = prefsUtil.getString(USER_ID);
    Provider.of<DataProvider>(context, listen: false).GetLeadOffer(leadId!,prefsUtil.getInt(COMPANY_ID)!);
    offerNameResponceModel = await ApiService().GetLeadName(userID!);
  }

  Widget SetOfferWidget(DataProvider productProvider) {
    if(productProvider.getOfferResponceata!=null){
      if(productProvider.getOfferResponceata!.status!){
        Navigator.of(context, rootNavigator: true).pop();
        isLoading = false;
        return  Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Text("₹ ${productProvider.getOfferResponceata!.response?.creditLimit}",
                style: TextStyle(color: Colors.black, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 20),
            Text.rich(TextSpan(
                text: 'Interest Rate : ${productProvider.getOfferResponceata!.response?.convenionFeeRate} %',)),
            Text(
              "(will be charged on every transaction)",
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }else{
        Utils.showToast(productProvider.getOfferResponceata!.message!);
        return Container();
      }
    }else {
      return Container();
    }

  }
  Widget SetCutomerOfferWidget(DataProvider productProvider) {
    if(productProvider.getOfferResponceata!=null){
      if(productProvider.getOfferResponceata!.status!){
        Navigator.of(context, rootNavigator: true).pop();
        isLoading = false;
        return  Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Text("₹ ${productProvider.getOfferResponceata!.response?.creditLimit}",
                style: TextStyle(color: Colors.black, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Text.rich(TextSpan(
                text: 'PF Charges :',
                style: TextStyle(color: Colors.black, fontSize: 15),
                children: <InlineSpan>[
                  TextSpan(
                    text: '₹ ${productProvider.getOfferResponceata!.response!.processingFeeAmount}',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ])),
            Text(
              "(Inclusive of GST)",
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text.rich(TextSpan(
                text: 'Interest Rate : ${productProvider.getOfferResponceata!.response?.convenionGSTAmount}',
                style: TextStyle(color: Colors.black, fontSize: 15),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'per annum',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ])),
            Text(
              "(will be charged on every transaction)",
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }else{
        Utils.showToast(productProvider.getOfferResponceata!.message!);
        return Container();
      }
    }else {
      return Container();
    }

  }

  void acceptOffer(BuildContext context)async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
   var responce = await ApiService().getAcceptOffer(leadId!);
   if(responce.status!){
     fetchData(context);
   }else{
     Utils.showToast(responce.message!);
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
        activityId:widget.activityId,
        subActivityId: widget.subActivityId,
        userId:  prefsUtil.getString(USER_ID),
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

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData);
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
