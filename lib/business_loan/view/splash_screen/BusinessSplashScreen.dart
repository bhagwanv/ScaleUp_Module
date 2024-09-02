import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/ProductCompanyDetailResponseModel.dart';
import 'package:scale_up_module/business_loan/api/ApiService.dart';
import 'package:scale_up_module/business_loan/data_provider/BusinessDataProvider.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/business_loan/utils/Utils.dart';
import 'package:scale_up_module/business_loan/utils/constants.dart';
import 'package:scale_up_module/business_loan/utils/customer_sequence_logic.dart';
import 'package:scale_up_module/business_loan/view/login_screen/login_screen.dart';
import 'package:scale_up_module/business_loan/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/business_loan/view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'package:scale_up_module/business_loan/view/splash_screen/model/LeadCurrentResponseModel.dart';

class BusinessLoanSplashScreen extends StatefulWidget {
  final String mobileNumber;
  final String companyID;
  final String productID;
  LeadCurrentResponseModel? leadCurrentActivityAsyncData;
  GetLeadResponseModel? getLeadData;
  bool isLoggedIn = false;

  BusinessLoanSplashScreen({
    Key? key,
    required this.mobileNumber,
    required this.productID,
    required this.companyID,
  }) : super(key: key);

  @override
  State<BusinessLoanSplashScreen> createState() => _BusinessLoanSplashScreenState();
}

class _BusinessLoanSplashScreenState extends State<BusinessLoanSplashScreen> {
  @override
  void initState() {
    super.initState();
    productCompanyDetail(widget.productID, widget.companyID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
                child: Text('Scaleup',
                    style: GoogleFonts.urbanist(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    )))),
        body:
        Consumer<BusinessDataProvider>(builder: (context, productProvider, child) {
          if (productProvider.productCompanyDetailResponseModel != null) {
            if (productProvider.productCompanyDetailResponseModel!.status!) {
              SaveData(productProvider
                  .productCompanyDetailResponseModel!.response!)
                  .then((leadCurrentActivityAsyncData) {
                // Handle the returned LeadCurrentResponseModel here
                if (leadCurrentActivityAsyncData != null) {
                  if (leadCurrentActivityAsyncData
                      .leadProductActivity!.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Utils.showToast("Configuration issue please connect to our team.",
                          context);
                    });
                  } else {
                    if (widget.isLoggedIn && leadCurrentActivityAsyncData.currentSequence != 1) {
                      customerSequence(context, widget.getLeadData,
                          leadCurrentActivityAsyncData, "pushReplacement");
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(
                              activityId: leadCurrentActivityAsyncData
                                  .leadProductActivity!.first.activityMasterId!,
                              subActivityId: leadCurrentActivityAsyncData
                                  .leadProductActivity!
                                  .first
                                  .subActivityMasterId!,
                              companyID: productProvider
                                  .productCompanyDetailResponseModel!
                                  .response!
                                  .companyId,
                              ProductID: productProvider
                                  .productCompanyDetailResponseModel!
                                  .response!
                                  .productId,
                              MobileNumber: widget.mobileNumber,
                            ),
                          ),
                        );
                      });
                    }
                  }
                }
              }).catchError((error) {
                // Handle errors that might occur during saving data
                print("Error saving data: $error");
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Utils.showToast(
                    productProvider
                        .productCompanyDetailResponseModel!.message !=
                        null
                        ? productProvider
                        .productCompanyDetailResponseModel!.message!
                        .toString()
                        : "Something went wrong",
                    context);
              });
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset('assets/images/scalup_gif_logo.gif')),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset('assets/images/scalup_gif_logo.gif')),
              ],
            );
          }
        }));
  }

  Future<void> productCompanyDetail(product, company) async {
    final prefsUtil = await SharedPref.getInstance();
    if (prefsUtil.getBool(IS_LOGGED_IN) != null) {
      widget.isLoggedIn = prefsUtil.getBool(IS_LOGGED_IN)!;
    }
    Provider.of<BusinessDataProvider>(context, listen: false)
        .productCompanyDetail(product, company);
  }

  Future<LeadCurrentResponseModel?> SaveData(
      ProductCompanyDetailResponse response) async {
    final prefsUtil = await SharedPref.getInstance();
    ValueType checkValueType<T>(T value) {
      if (value is bool) {
        return ValueType.boolean;
      } else if (value is String) {
        return ValueType.string;
      } else if (value is int) {
        return ValueType.integer;
      } else {
        return ValueType.unknown;
      }
    }

    if (checkValueType(response.companyId) == ValueType.integer) {
      prefsUtil.saveInt(COMPANY_ID, response.companyId!);
    } else {
      prefsUtil.saveString(COMPANY_ID, response.companyId!.toString());
    }
    if (checkValueType(response.productId) == ValueType.integer) {
      prefsUtil.saveInt(PRODUCT_ID, response.productId!);
    } else {
      prefsUtil.saveString(PRODUCT_ID, response.productId!.toString());
    }
    prefsUtil.saveString(PRODUCT_CODE, response.productCode!);
    prefsUtil.saveString(COMPANY_CODE, response.companyCode!);

    var leadCurrentRequestModel = LeadCurrentRequestModel(
      companyId: response.companyId,
      productId: response.productId,
      leadId: 0,
      mobileNo: widget.mobileNumber,
      activityId: 0,
      subActivityId: 0,
      userId: "",
      monthlyAvgBuying: 0,
      vintageDays: 0,
      isEditable: true,
    );

    var leadId = 0;
    if (prefsUtil.getInt(LEADE_ID) != null) {
      leadId = prefsUtil.getInt(LEADE_ID)!;
    }
    widget.getLeadData = await ApiService().getLeads(
        widget.mobileNumber, response.companyId, response.productId, leadId)
    as GetLeadResponseModel?;
    return await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
    as LeadCurrentResponseModel?;
  }
}
