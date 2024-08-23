import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/business_loan/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/business_loan/utils/Utils.dart';
import 'package:scale_up_module/business_loan/utils/common_elevted_button.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../api/ApiService.dart';
import '../../data_provider/BusinessDataProvider.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/VarifayOtpRequest.dart';

class OtpScreen extends StatefulWidget {
  int? activityId;
  int? subActivityId;

  OtpScreen({required this.activityId, required this.subActivityId, super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  String? appSignature;
  String? otpCode;
  BusinessDataProvider? productProvider;
  bool isReSendDisable = true;
  String? userLoginMobile;
  var isLoading = true;
  int _start = 30;
  final CountdownController _controller = CountdownController(autoStart: true);

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
    _start = 30;
    // startTimer();
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
        print("MUkesh " + appSignature!);
      });
    });
  }

  Widget buildCountdown() {
    return Countdown(
      controller: _controller,
      seconds: _start,
      build: (_, double time) => Text(
        time.toStringAsFixed(0) + " S",
        style: GoogleFonts.urbanist(
          fontSize: 15,
          color: Colors.blue,
          fontWeight: FontWeight.w400,
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

  void listenOtp() async {
    final prefsUtil = await SharedPref.getInstance();
    userLoginMobile = prefsUtil.getString(LOGIN_MOBILE_NUMBER);
    await SmsAutoFill().listenForCode();
    print("OTP listen  Called");
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.urbanist(
      fontSize: 22,
        color: Colors.black,
      fontWeight: FontWeight.w400,
    ),
      decoration: BoxDecoration(
        color: textFiledBackgroundColour,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPrimaryColor),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<BusinessDataProvider>(builder: (context, productProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 50, right: 30, bottom: 30),
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
                   Text(
                    'Enter \nVerification Code',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.urbanist(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  userLoginMobile != null
                      ? Text(
                          'We just sent to +91 XXXXXX${userLoginMobile!.substring(userLoginMobile!.length - 4)}',
                          textAlign: TextAlign.start,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),

                        )
                      : Container(),
                  const SizedBox(
                    height: 55,
                  ),
                  Center(
                    child: Pinput(
                      controller: pinController,
                      length: 6,
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsRetrieverApi,
                      showCursor: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9\]")),
                      ],
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
                    child: isReSendDisable
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Resend Code in ',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w400,
                                ),

                              ),
                              buildCountdown(),
                            ],
                          )
                        : Container(),
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
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),

                              children: <TextSpan>[
                                isReSendDisable
                                    ? TextSpan(
                                        text: '  Resend',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {})
                                    : TextSpan(
                                        text: '  Resend',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w400,
                                    ),

                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            listenOtp();
                                            pinController.clear();
                                            await reSendOpt(
                                                context,
                                                productProvider,
                                                userLoginMobile!,
                                                _controller);
                                            isReSendDisable = true;
                                          })
                              ]),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonElevatedButton(
                    onPressed: () async {
                      await callVerifyOtpApi(
                          context,
                          pinController.text,
                          productProvider,
                          widget.activityId!,
                          widget.subActivityId!,
                          userLoginMobile!,
                          pinController);
                    },
                    text: "Verify Code",
                    upperCase: true,
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> callVerifyOtpApi(
      BuildContext context,
      String otpText,
      BusinessDataProvider productProvider,
      int activityId,
      int subActivityId,
      String userLoginMobile,
      TextEditingController pinController) async {
    if (otpText.isEmpty) {
      Utils.showBottomSheet(
          context,
          "Please enter the OTP we just sent you on your mobile number",
          VALIDACTION_IMAGE_PATH);
    } else if (otpText.length < 6) {
      pinController.clear();
      Utils.showBottomSheet(
          context,
          "Please enter the OTP we just sent you on your mobile number",
          VALIDACTION_IMAGE_PATH);
    } else {
      productProvider.disposeAllProviderData();
      Utils.onLoading(context, "");

      var activityId=10;
      var companyId=2;
     var  productId=8;


      final prefsUtil = await SharedPref.getInstance();
      await Provider.of<BusinessDataProvider>(context, listen: false).verifyOtp(VarifayOtpRequest(
        activityId: activityId,
        companyId:2, //prefsUtil.getInt(COMPANY_ID),
        mobileNo: userLoginMobile,
        otp: otpText,
        productId:8, //prefsUtil.getInt(PRODUCT_ID),
        subActivityId: subActivityId,
        vintageDays: 0,
        monthlyAvgBuying: 0,
        screen: "MobileOtp",
        ProductCode: prefsUtil.getString(PRODUCT_CODE),
        CompanyCode: prefsUtil.getString(COMPANY_CODE),
      ));
      Navigator.of(context, rootNavigator: true).pop();
      if (productProvider.getVerifyData != null) {
        productProvider.getVerifyData!.when(
          success: (VerifyOtpResponce) async {
            // Handle successful response
            var verifyOtpResponce = VerifyOtpResponce;
            if (!verifyOtpResponce.status!) {
              pinController.clear();
              Utils.showToast(verifyOtpResponce.message!, context);
            } else {
              await prefsUtil.saveString(USER_ID, verifyOtpResponce.userId.toString());
              await prefsUtil.saveString(TOKEN, verifyOtpResponce.userTokan.toString());
              await prefsUtil.saveInt(LEADE_ID, verifyOtpResponce.leadId!);
              await prefsUtil.saveBool(IS_LOGGED_IN, true);

              fetchData(context, userLoginMobile);
            }
          },
          failure: (exception) {
            // Handle failure
            print("dfjsf2");
            //print('Failure! Error: ${exception.message}');
          },
        );
      }
    }
  }

  Future<void> fetchData(BuildContext context, String userLoginMobile) async {
    final prefsUtil = await SharedPref.getInstance();

    Utils.onLoading(context, "");
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        mobileNo: userLoginMobile,
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        userId: prefsUtil.getString(USER_ID),
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData = await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel) as LeadCurrentResponseModel?;
      Navigator.of(context, rootNavigator: true).pop();
      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          userLoginMobile,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;
      customerSequence(context, getLeadData, leadCurrentActivityAsyncData, "pushReplacement");
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

  Future<void> reSendOpt(BuildContext context, BusinessDataProvider productProvider,
      String userLoginMobile, CountdownController controller) async {
    final prefsUtil = await SharedPref.getInstance();

    Utils.onLoading(context, "");
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .genrateOtp(context, userLoginMobile, prefsUtil.getInt(COMPANY_ID)!);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.genrateOptData != null) {
      productProvider.genrateOptData!.when(
        success: (GenrateOptResponceModel) {
          // Handle successful response
          var genrateOptResponceModel = GenrateOptResponceModel;

          if (!genrateOptResponceModel.status!) {
            Utils.showToast(genrateOptResponceModel.message!, context);
          } else {
            controller.restart();
          }
        },
        failure: (exception) {
          // Handle failure
          print('Failure! Error: ${exception}');
        },
      );
    }
  }
}
