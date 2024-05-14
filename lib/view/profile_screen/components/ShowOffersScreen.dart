import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/profile_screen/model/AcceptedResponceModel.dart';
import 'package:scale_up_module/view/profile_screen/model/DisbursementResponce.dart';
import 'package:scale_up_module/view/profile_screen/model/OfferPersonNameResponceModel.dart';
import 'package:scale_up_module/view/profile_screen/model/OfferResponceModel.dart';
import 'package:scale_up_module/view/pwa/Pwascreen.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'package:scale_up_module/view/splash_screen/model/LeadCurrentResponseModel.dart';
import '../../../api/ApiService.dart';
import '../../../data_provider/DataProvider.dart';
import '../../../shared_preferences/SharedPref.dart';
import '../../../utils/Utils.dart';
import '../../../utils/common_elevted_button.dart';
import '../../../utils/constants.dart';
import '../../../utils/customer_sequence_logic.dart';
import '../../../utils/loader.dart';
import '../model/CheckStatusModel.dart';

class ShowOffersScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  const ShowOffersScreen(
      {super.key, required this.activityId, required this.subActivityId});

  @override
  State<ShowOffersScreen> createState() => _DisbursementScreenState();
}

class _DisbursementScreenState extends State<ShowOffersScreen> {
  var isLoading = true;
  String? userID = "";
  late OfferResponceModel? offerResponceModel = null;
  late OfferPersonNameResponceModel? offerPersonNameResponceModel = null;
  late AcceptedResponceModel? acceptedResponceModel = null;
  var isCheckStatus = false;

  @override
  void initState() {
    super.initState();
    callApi(context);
  }

  void callApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    userID = prefsUtil.getString(USER_ID);
    await Provider.of<DataProvider>(context, listen: false).GetLeadOffer(leadId!, prefsUtil.getInt(COMPANY_ID)!);
    getLeadNameApi(context, productCode!);
   await getCheckStatus(context, leadId);
  }

  Future<void> getLeadNameApi(BuildContext context, String productCode) async {
    Provider.of<DataProvider>(context, listen: false)
        .getLeadName(userID!, productCode);
  }

  Future<void> getCheckStatus(BuildContext context, int leadID) async {
    CheckStatusModel checkStatus = await ApiService().checkStatus(leadID);
    if (checkStatus.isSuccess!) {
      isCheckStatus = checkStatus.isSuccess!;
      print("object Status $isCheckStatus");
    } else {
      isCheckStatus = checkStatus.isSuccess!;
      print("object Status $isCheckStatus");
    }
  }

  Future<void> NextCall(
      BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false).getAcceptOffer(leadId!);
    Navigator.of(context, rootNavigator: true).pop();

    // var responce = await ApiService().getAcceptOffer(leadId!);
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
        Utils.showToast(offerResponceModel!.message!, context);
        return Container();
      }
    } else {
      return Container();
    }
  }

  /*Show Offers*/
  Widget SetCutomerOfferWidget(DataProvider productProvider) {
    if (offerResponceModel != null) {
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
                    'Interest Rate : ${offerResponceModel!.response?.convenionGSTAmount} ',
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
        Utils.showToast(offerResponceModel!.message!, context);
        return Container();
      }
    } else {
      return Container();
    }
  }

  Future<void> acceptOffer(
      BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Utils.onLoading(context, "");
    Provider.of<DataProvider>(context, listen: false).getAcceptOffer(leadId!);
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getAcceptOfferData != null) {
      productProvider.getAcceptOfferData!.when(
        success: (AcceptedResponceModel) {
          // Handle successful response
          acceptedResponceModel = AcceptedResponceModel;

          if (acceptedResponceModel!.status!) {
            fetchData(context);
          } else {
            Utils.showToast(acceptedResponceModel!.message!, context);
          }
        },
        failure: (exception) {
          print("Failure!");
        },
      );
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

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData);
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        top: true,
        bottom: true,
        child:
            Consumer<DataProvider>(builder: (context, productProvider, child) {
          if (productProvider.getOfferResponceata == null && isLoading) {
            return Center(child: Loader());
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            isLoading = false;
          }
          if (productProvider.getOfferResponceata != null) {
            productProvider.getOfferResponceata!.when(
              success: (OfferResponceModel) {
                offerResponceModel = OfferResponceModel;
              },
              failure: (exception) {
                print("Failure");
              },
            );
          }

          if (productProvider.getLeadNameData != null) {
            productProvider.getLeadNameData!.when(
              success: (OfferPersonNameResponceModel) {
                offerPersonNameResponceModel = OfferPersonNameResponceModel;
              },
              failure: (exception) {
                print("Failure");
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
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                        'assets/images/credit_line_approved.svg'),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        textAlign: TextAlign.center,
                        "Congratulations ${offerPersonNameResponceModel?.response ?? ''}!! ",
                        style: TextStyle(color: kPrimaryColor, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "You are qualified for credit limit of",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      offerResponceModel != null &&
                              offerResponceModel!.response != null &&
                              offerResponceModel!
                                      .response!.processingFeePayableBy ==
                                  "Anchor"
                          ? SetOfferWidget(productProvider)
                          : SetCutomerOfferWidget(productProvider),
                    ],
                  ),
                  const SizedBox(height: 30),
                  offerResponceModel != null && offerResponceModel!.response != null && offerResponceModel!.response!.processingFeePayableBy == "Customer" && !isCheckStatus
                      ? CommonElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Pwascreen(
                                      activityId: widget.activityId,
                                      subActivityId: widget.subActivityId);
                                },
                              ),
                            );
                          },
                          text: "Pay Now",
                          upperCase: true,
                        )
                      : CommonElevatedButton(
                          onPressed: () async {
                            await acceptOffer(context, productProvider);
                          },
                          text: "Proceed to e-Agreement",
                          upperCase: true,
                        ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        }));
  }
}