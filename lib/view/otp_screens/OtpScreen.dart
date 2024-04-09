
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/common_elevted_button.dart';
import 'package:scale_up_module/utils/kyc_faild_widgets.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../api/ApiService.dart';
import '../../data_provider/DataProvider.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/VarifayOtpRequest.dart';

class OtpScreen extends StatefulWidget {
  int? activityId;
  int? subActivityId;


  OtpScreen({ required this.activityId, required this.subActivityId, super.key });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  String? appSignature;
  String? otpCode;
  DataProvider? productProvider;
  late Timer _timer;
  int _start = 30;
  String? userLoginMobile;
  bool isReSendDisable = true;
  var isLoading = true;

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
      print("Code ######## " + otpCode!);
    });
  }

  @override
  void initState() {
    super.initState();
    listenOtp();
    startTimer();
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
        print("MUkesh " + appSignature!);
      });
    });
  }

  void startTimer() async {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            isReSendDisable = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void listenOtp() async {
    SharedPref().getString(SharedPref().LOGIN_MOBILE_NUMBER).then((value) {
      userLoginMobile = value;
    });
    await SmsAutoFill().listenForCode();
    print("OTP listen  Called");
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: textFiledBackgroundColour,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<DataProvider>(builder: (context, productProvider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 50, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 69,
                    width: 51,
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/images/scale.png')),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Enter \nVerification Code',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 35, color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'We just sent to +91 $userLoginMobile',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                const SizedBox(
                  height: 55,
                ),
                Center(
                  child: Pinput(
                    controller: pinController,
                    length: 6,
                    androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
                    showCursor: true,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: kPrimaryColor),
                      ),
                    ),
                    onCompleted: (pin) => debugPrint(pin),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Resend Code in ${_start} s',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'If you didn’t received a code!',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                            children: <TextSpan>[
                              isReSendDisable
                                  ? TextSpan(
                                      text: '  Resend',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {})
                                  : TextSpan(
                                      text: '  Resend',
                                      style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          isReSendDisable = true;
                                          listenOtp();
                                          reSendOpt(context, productProvider,userLoginMobile!);
                                          _start = 30;
                                          startTimer();
                                        })
                            ]),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                CommonElevatedButton(
                  onPressed: () {
                    callVerifyOtpApi(context, pinController.text,productProvider, widget.activityId!, widget.subActivityId!);
                  },
                  text: "Verify Code",
                  upperCase: true,
                )
              ],
            ),
          ),
        );
      }),
    ));
  }
}

void callVerifyOtpApi(BuildContext context, String otpText, DataProvider productProvider, int activityId, int subActivityId) async {
  if (otpText.isEmpty) {
    Utils.showToast("Please Enter Opt");
  } else if (otpText.length < 6) {
    Utils.showToast("PLease Enter Valid Otp");
  } else {
    Utils.onLoading(context, "Loading....");
    await Provider.of<DataProvider>(context, listen: false).verifyOtp(VarifayOtpRequest(activityId: activityId,companyId: SharedPref().COMPANY_ID,mobileNo: SharedPref().getString(SharedPref().LOGIN_MOBILE_NUMBER).then((value) { value;}).toString(),otp: otpText,productId: SharedPref().PRODUCT_ID,subActivityId: subActivityId,vintageDays: 0,monthlyAvgBuying: 0,screen: "MobileOtp"));

    if (!productProvider.getVerifyData!.status!) {
      Navigator.of(context, rootNavigator: true).pop();
      Utils.showToast("Something went wrong");
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      SharedPref().save(SharedPref().USER_ID, productProvider.getVerifyData?.userId);
      SharedPref().save(SharedPref().TOKEN, productProvider.getVerifyData?.userTokan);
      SharedPref().save(SharedPref().LEADE_ID, productProvider.getVerifyData?.leadId);
    fetchData(context);


    }
  }
}

Future<void> fetchData(BuildContext context) async {
  try {
    LeadCurrentResponseModel? leadCurrentActivityAsyncData;
    var leadCurrentRequestModel = LeadCurrentRequestModel(
      companyId: SharedPref().COMPANY_ID,
      productId: SharedPref().PRODUCT_ID,
      leadId: 0,
      mobileNo:  SharedPref().getString(SharedPref().LOGIN_MOBILE_NUMBER).then((value) { value;}).toString(),
      activityId: 0,
      subActivityId: 0,
      userId: "",
      monthlyAvgBuying: 0,
      vintageDays: 0,
      isEditable: true,
    );
    leadCurrentActivityAsyncData =
    await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
    as LeadCurrentResponseModel?;

    GetLeadResponseModel? getLeadData;
    getLeadData = await ApiService().getLeads( SharedPref().getString(SharedPref().LOGIN_MOBILE_NUMBER).then((value) { value;}).toString(), 2, 2, 0)
    as GetLeadResponseModel?;

    customerSequence(context, getLeadData, leadCurrentActivityAsyncData);
  } catch (error) {
    if (kDebugMode) {
      print('Error occurred during API call: $error');
    }
  }
}


void reSendOpt(BuildContext context, DataProvider productProvider, String userLoginMobile) async {
  Utils.onLoading(context, "Loading....");

  await Provider.of<DataProvider>(context, listen: false).genrateOtp(userLoginMobile, 2);
  if (!productProvider.genrateOptData!.status!) {
    Navigator.of(context, rootNavigator: true).pop();
    Utils.showToast("Something went wrong");

  } else {
    Navigator.of(context, rootNavigator: true).pop();

  }
}

void bottomSheetMenu(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return const KycFailedWidgets();
      });
}
