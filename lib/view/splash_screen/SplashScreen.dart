import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/ProductCompanyDetailResponseModel.dart';
import 'package:scale_up_module/api/ApiService.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/Utils.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../login_screen/login_screen.dart';
import 'model/LeadCurrentResponseModel.dart';

class SplashScreen extends StatefulWidget {
  String mobileNumber;
  String companyID;
  String ProductID;
  LeadCurrentResponseModel? leadCurrentActivityAsyncData;


  SplashScreen({super.key,
        required this.mobileNumber,
        required this.ProductID,
        required this.companyID});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    productCompanyDetail(
        context, widget.ProductID, widget.companyID);
  }

  @override
  Widget build(BuildContext context) {
    var activityId = 0;
    var subActivityId = 0;

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Scaleup')),
        ),
        body:
            Consumer<DataProvider>(builder: (context, productProvider, child) {
          if (productProvider.productCompanyDetailResponseModel != null) {
            if (productProvider.productCompanyDetailResponseModel!.status!) {

              SaveData(productProvider.productCompanyDetailResponseModel!.response!).then((leadCurrentActivityAsyncData) {
                // Handle the returned LeadCurrentResponseModel here
                if (leadCurrentActivityAsyncData != null) {
                  setState(() {
                    // Update state variables
                    activityId = leadCurrentActivityAsyncData.leadProductActivity!.first.activityMasterId!;
                    subActivityId = leadCurrentActivityAsyncData.leadProductActivity!.first.subActivityMasterId!;
                  });
                  print("activityId $activityId");
                   WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          activityId: activityId,
                          subActivityId: subActivityId,
                          companyID: productProvider
                              .productCompanyDetailResponseModel!
                              .response!
                              .productId,
                          ProductID: productProvider
                              .productCompanyDetailResponseModel!
                              .response!
                              .companyId,
                          MobileNumber: widget.mobileNumber,
                        ),
                      ),
                    );
                  });                }
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
                        : "",
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

  Future<void> productCompanyDetail(
      BuildContext context, product, company) async {
     Provider.of<DataProvider>(context, listen: false).productCompanyDetail(product, company);

  }

  Future<LeadCurrentResponseModel?> SaveData(ProductCompanyDetailResponse response) async {
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
    return await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel) as LeadCurrentResponseModel?;
  }

/*  Future<void> fetchData() async {
    final String? mobile = widget.mobileNumber.toString();
    final prefsUtil = await SharedPref.getInstance();
    */ /*await prefsUtil.saveInt(COMPANY_ID, int.parse(widget.companyID));
    await prefsUtil.saveInt(PRODUCT_ID, int.parse(widget.ProductID));
    await prefsUtil.saveString(LOGIN_MOBILE_NUMBER, widget.mobileNumber.toString());*/ /*

    //lead id
    var leadId = 0;
    var userID = "";
    if (prefsUtil.getInt(LEADE_ID) != null) {
      leadId = prefsUtil.getInt(LEADE_ID)!;
    }
    if (prefsUtil.getString(USER_ID) != null) {
      userID = prefsUtil.getString(USER_ID)!;
    }

    if (mobile == null ||
        prefsUtil.getString(USER_ID) == null ||
        prefsUtil.getInt(LEADE_ID) == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => LoginScreen(
                activityId: 1,
                subActivityId: 0,
                companyID: widget.companyID,
                ProductID: widget.ProductID,
                MobileNumber: widget.mobileNumber)),
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
            await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
                as LeadCurrentResponseModel?;
        GetLeadResponseModel? getLeadData;
        getLeadData = await ApiService()
                .getLeads(mobile!, widget.companyID, widget.ProductID, leadId)
            as GetLeadResponseModel?;
        if (getLeadData!.userId != null) {
          prefsUtil.saveString(USER_ID, getLeadData.userId!);
        } else {
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
  }*/
}
