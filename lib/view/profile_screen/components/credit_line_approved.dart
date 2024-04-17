

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/api/ApiService.dart';
import 'package:scale_up_module/api/ExceptionHandling.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/view/Bank_details_screen/BankDetailsScreen.dart';
import 'package:scale_up_module/view/profile_screen/model/DisbursementResponce.dart';
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
import '../model/AcceptedResponceModel.dart';

class CreditLineApproved extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final bool isDisbursement;

  const CreditLineApproved({super.key, required this.activityId, required this.subActivityId,required this.isDisbursement});

  @override
  State<CreditLineApproved> createState() => _CreditLineApprovedState();
}

class _CreditLineApprovedState extends State<CreditLineApproved> {
  late OfferPersonNameResponceModel? offerPersonNameResponceModel=null;
  late OfferResponceModel? offerResponceModel=null;
  late AcceptedResponceModel? acceptedResponceModel=null;
  late DisbursementResponce? disbursementResponce=null;
  var isLoading = true;
  var congratulations = "";

  @override
  void initState() {
    super.initState();
    if(widget.isDisbursement){
      callDisbursementApi(context);
    }else{
      callApi(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Consumer<DataProvider>(builder: (context, productProvider, child) {
        if(widget.isDisbursement){
          if (productProvider.getDisbursementData == null && isLoading) {
            return Center(child: Loader());
          }else {
            Navigator.of(context, rootNavigator: true).pop();
            isLoading = false;
          }
        }else {
          if (productProvider.getOfferResponceata == null && isLoading) {
            return Center(child: Loader());
          }else {
            Navigator.of(context, rootNavigator: true).pop();
            isLoading = false;
          }
        }


          if(widget.isDisbursement){
            if (productProvider.getDisbursementData != null) {
              productProvider.getDisbursementData!.when(
                success: (DisbursementResponce) {
                  disbursementResponce = DisbursementResponce;

                },
                failure: (exception) {
                  // Handle failure
                  print("Failure");
                  //print('Failure! Error: ${exception.message}');
                },
              );
            }
          }else{
            if (productProvider.getOfferResponceata != null) {
              productProvider.getOfferResponceata!.when(
                success: (OfferResponceModel) async {
                  // Handle successful response
                  offerResponceModel = OfferResponceModel;

                  await getLeadNameApi(context,productProvider);


                },
                failure: (exception) {
                  // Handle failure
                  print("Failure");
                  //print('Failure! Error: ${exception.message}');
                },
              );
            }
          }

          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                        'assets/images/credit_line_approved.svg'),
                  ),
                  widget.isDisbursement? Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        " Thank You For Choosing Us!Your Account Setup has been successfully Completed for Credit Limit",
                        style: TextStyle(color: kPrimaryColor, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      disbusmentWidget(),
                    ],
                  ):
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                          "Congratulations ${offerPersonNameResponceModel?.response ?? ''}!! ",
                        style: TextStyle(color: kPrimaryColor, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "You are qualified for credit limit of",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),

                      offerResponceModel != null && offerResponceModel!.response != null && offerResponceModel!.response!.processingFeePayableBy == "Anchor"
                          ? SetOfferWidget(productProvider)
                          : SetCutomerOfferWidget(productProvider),
                    ],
                  ),
                  const SizedBox(height: 30),
                  widget.isDisbursement?Container():
                  CommonElevatedButton(
                    onPressed: () async{
                      await acceptOffer(context,productProvider);
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
      }),

    );
  }


  void callDisbursementApi(BuildContext context)async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<DataProvider>(context, listen: false).getDisbursementProposal(leadId!);
  }

  void callApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final String? userID = prefsUtil.getString(USER_ID);
    Provider.of<DataProvider>(context, listen: false).GetLeadOffer(leadId!, prefsUtil.getInt(COMPANY_ID)!);
  }

  Future<void> getLeadNameApi(BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userID = prefsUtil.getString(USER_ID);
    Utils.onLoading(context,"");
    await Provider.of<DataProvider>(context, listen: false).getLeadName(userID!);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getLeadNameData != null) {
      productProvider.getLeadNameData!.when(
        success: (OfferPersonNameResponceModel) {
          // Handle successful response
          offerPersonNameResponceModel = OfferPersonNameResponceModel;
          //  congratulations= offerPersonNameResponceModel!.response!;

        },
        failure: (exception) {
          // Handle failure
          print("Failure");
          //print('Failure! Error: ${exception.message}');
        },
      );
    }

  }


  Widget SetOfferWidget(DataProvider productProvider) {
    if (productProvider.getOfferResponceata != null) {
      if (offerResponceModel!.status!) {
        return Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Text(
                "₹ ${offerResponceModel!.response?.creditLimit}",
                style: TextStyle(color: Colors.black, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Text.rich(TextSpan(
              text:
                  'Interest Rate : ${offerResponceModel!.response?.convenionFeeRate} %',
            )),
            Text(
              "(will be charged on every transaction)",
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        );
      } else {
        Utils.showToast(offerResponceModel!.message!);
        return Container();
      }
    } else {
      return Container();
    }
  }
  Widget disbusmentWidget() {
    if(disbursementResponce!=null){
      if (disbursementResponce!.status!) {
        return Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Text(
                "₹ ${disbursementResponce!.response?.creditLimit}",
                style: TextStyle(color: Colors.black, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Text.rich(TextSpan(
              text:
              'Interest Rate : ${disbursementResponce!.response?.convenionFeeRate} %',
            )),
            Text(
              "(will be charged on every transaction)",
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Our Team will review your application and will activate your account within 48 Hrs. Wishing you success and prosperity ahead.",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),),

          ],
        );
      } else {
        Utils.showToast(offerResponceModel!.message!);
        return Container();
      }
    }else {
      return Container();
    }
  }

  Widget SetCutomerOfferWidget(DataProvider productProvider) {
    if (offerResponceModel!= null) {
      if (offerResponceModel!.status!) {
        Navigator.of(context, rootNavigator: true).pop();
        isLoading = false;
        return Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Text(
                "₹ ${offerResponceModel!.response?.creditLimit}",
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
                    text:
                        '₹ ${offerResponceModel!.response!.processingFeeAmount}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ])),
            Text(
              "(Inclusive of GST)",
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text.rich(TextSpan(
                text:
                    'Interest Rate : ${offerResponceModel!.response?.convenionGSTAmount}',
                style: TextStyle(color: Colors.black, fontSize: 15),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'per annum',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ])),
            Text(
              "(will be charged on every transaction)",
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        );
      } else {
        Utils.showToast(offerResponceModel!.message!);
        return Container();
      }
    } else {
      return Container();
    }

  }

  Future<void> acceptOffer(BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Utils.onLoading(context,"");
    await Provider.of<DataProvider>(context, listen: false).getAcceptOffer(leadId!);
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getAcceptOfferData != null) {
      productProvider.getAcceptOfferData!.when(
        success: (AcceptedResponceModel) {
          // Handle successful response
          acceptedResponceModel = AcceptedResponceModel;

          if (acceptedResponceModel!.status!) {
            fetchData(context);
          } else {
            Utils.showToast(acceptedResponceModel!.message!);
          }

        },
        failure: (exception) {
          // Handle failure
          print("Failure!");
          //print('Failure! Error: ${exception.message}');
        },
      );
    }

   // var responce = await ApiService().getAcceptOffer(leadId!);

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
