import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/common_elevted_button.dart';
import 'package:scale_up_module/utils/kyc_faild_widgets.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../api/ApiService.dart';
import '../../data_provider/DataProvider.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../otp_screens/model/VarifayOtpRequest.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/OTPValidateForEmailRequest.dart';

class EmailOtpScreen extends StatefulWidget {
  String? emailID;

  EmailOtpScreen({required this.emailID, super.key});

  @override
  State<EmailOtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<EmailOtpScreen> {
  String? appSignature;
  String? otpCode;
  DataProvider? productProvider;
  int _start = 60;
  String? userLoginMobile;
  bool isReSendDisable = true;
  var isLoading = true;
  final CountdownController _controller = CountdownController(autoStart: true);

  @override
  void initState() {
    super.initState();
    _start = 60;
  }

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
  void dispose() {
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
                Text(
                  'We just sent you an verification code on your emailID Please enter otp to verify',
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
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsRetrieverApi,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
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
                            text: 'If you didnt received a code click',
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
                                          reSendOpt(context, productProvider,
                                              userLoginMobile!, _controller);
                                          isReSendDisable = true;
                                        })
                            ]),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Back',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonElevatedButton(
                  onPressed: () {
                    callVerifyOtpApi(context, pinController.text,
                        widget.emailID!, productProvider);
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

  void callVerifyOtpApi(BuildContext context, String otpText, String email,
      DataProvider productProvider) async {
    var isValid = false;
    if (otpText.isEmpty) {
      Utils.showToast("Please Enter Opt");
    } else if (otpText.length < 6) {
      Utils.showToast("PLease Enter Valid Otp");
    } else {
      Utils.onLoading(context, "Loading....");
      try {
        await productProvider.otpValidateForEmail(
            OtpValidateForEmailRequest(email: email, otp: otpText));
        if (productProvider.getValidOtpEmailData != null &&
            productProvider.getValidOtpEmailData!.status != null &&
            !productProvider.getValidOtpEmailData!.status!) {
          Utils.showToast(productProvider.getValidOtpEmailData!.message!);
        } else {
          isValid = true;
          Navigator.of(context, rootNavigator: true).pop();
        }
      } catch (error) {
        // Handle any errors that occur during the API call
        Utils.showToast("An error occurred: $error");
      } finally {
        Navigator.of(context, rootNavigator: true).pop({
          'isValid': isValid,
          'Email': email,
        });
      }
    }
  }

  void reSendOpt(BuildContext context, DataProvider productProvider,
      String userLoginMobile, CountdownController controller) async {
    Utils.onLoading(context, "Loading....");
    final prefsUtil = await SharedPref.getInstance();

    await Provider.of<DataProvider>(context, listen: false)
        .genrateOtp(userLoginMobile, prefsUtil.getInt(COMPANY_ID)!);
    if (!productProvider.genrateOptData!.status!) {
      Navigator.of(context, rootNavigator: true).pop();
      Utils.showToast("Something went wrong");
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      controller.restart();
    }
  }
}