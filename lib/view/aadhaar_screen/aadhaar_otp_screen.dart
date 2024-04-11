import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/aadhaar_screen/models/ValidateAadhaarOTPRequestModel.dart';
import 'package:scale_up_module/view/take_selfi/take_selfi_screen.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../api/ApiService.dart';
import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/Utils.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/kyc_faild_widgets.dart';
import '../login_screen/login_screen.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'models/AadhaaGenerateOTPRequestModel.dart';

class AadhaarOtpScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final AadhaarGenerateOTPRequestModel? document;
  String? requestId;

  AadhaarOtpScreen(
      {super.key,
      required this.activityId,
      required this.subActivityId,
      required this.document,
      required this.requestId});

  @override
  State<AadhaarOtpScreen> createState() => _AadhaarOtpScreenState();
}

class _AadhaarOtpScreenState extends State<AadhaarOtpScreen> {
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
  int _start = 60;
  final CountdownController _controller = CountdownController(autoStart: true);
  bool isReSendDisable = true;

  Widget buildCountdown() {
    print("_start $_start");
    return Countdown(
      controller: _controller,
      seconds: _start,
      build: (_, double time) => Text(
        time.toString(),
        style: TextStyle(
          fontSize: 15,
          color: Colors.blue,
          fontWeight: FontWeight.normal,
        ),
      ),
      interval: Duration(seconds: 1),
      onFinished: () {
        setState(() {
          isReSendDisable = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();

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
                const Text(
                  'Enter the verification code sent on Aadhaar registered mobile number',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                const SizedBox(
                  height: 55,
                ),
                Center(
                  child: Pinput(
                    length: 6,
                    controller: pinController,
                    showCursor: true,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Resend Code in ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                      buildCountdown(),
                    ],
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
                                          generateAadhaarOTPAPI(
                                              context, productProvider);
                                        })
                            ]),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                CommonElevatedButton(
                  onPressed: () {
                    validateAadhaar(
                        context, pinController.text, productProvider);
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

  void validateAadhaar(
    BuildContext context,
    String otpText,
    DataProvider productProvider,
  ) async {
    if (otpText.isEmpty) {
      Utils.showToast("Please Enter OTP");
    } else if (otpText.length < 6) {
      Utils.showToast("PLease Enter Valid Otp");
    } else {
      Utils.onLoading(context, "Loading....");

      final prefsUtil = await SharedPref.getInstance();

      var req = ValidateAadhaarOTPRequestModel(
          leadId: prefsUtil.getInt(LEADE_ID),
          userId: prefsUtil.getString(USER_ID),
          activityId: widget.activityId,
          subActivityId: widget.subActivityId,
          documentNumber: widget.document?.DocumentNumber!,
          frontFileUrl: widget.document?.FrontFileUrl!,
          backFileUrl: widget.document?.BackFileUrl!,
          frontDocumentId: widget.document?.FrontDocumentId!,
          backDocumentId: widget.document?.BackDocumentId!,
          otp: otpText,
          requestId: widget.requestId!,
          companyId: prefsUtil.getInt(COMPANY_ID));

      await Provider.of<DataProvider>(context, listen: false)
          .validateAadhaarOtp(req);

      if (!productProvider.getValidateAadhaarOTPData!.isSuccess!) {
        Navigator.of(context, rootNavigator: true).pop();
        Utils.showToast("Something went wrong");
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        fetchData(context);
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

  void generateAadhaarOTPAPI(
    BuildContext context,
    DataProvider productProvider,
  ) async {
    Utils.onLoading(context, "Loading....");

    var request = AadhaarGenerateOTPRequestModel(
        DocumentNumber: widget.document?.DocumentNumber!,
        FrontFileUrl: widget.document?.FrontFileUrl!,
        BackFileUrl: widget.document?.BackFileUrl!,
        FrontDocumentId: widget.document?.FrontDocumentId!,
        BackDocumentId: widget.document?.BackDocumentId!,
        otp: "",
        requestId: "");

    await Provider.of<DataProvider>(context, listen: false)
        .leadAadharGenerateOTP(request);

    if (productProvider.getLeadAadharGenerateOTP?.errorCode != 401) {
      if (productProvider.getLeadAadharGenerateOTP != null) {
        Navigator.of(context, rootNavigator: true).pop();
        Utils.showToast(
            " ${productProvider.getLeadAadharGenerateOTP!.data!.message!}");
        widget.requestId = productProvider.getLeadAadharGenerateOTP!.requestId!;
        Utils.showToast(
            " ${productProvider.getLeadAadharGenerateOTP!.data!.message!}");
      } else {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              LoginScreen(activityId: 1, subActivityId: 0),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    }
  }
}
