import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/business_loan/utils/Utils.dart';
import 'package:scale_up_module/business_loan/utils/common_elevted_button.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../api/ApiService.dart';
import '../../data_provider/BusinessDataProvider.dart';
import '../../utils/constants.dart';
import 'model/OTPValidateForEmailRequest.dart';
import 'model/SendOtpOnEmailResponce.dart';

class EmailOtpScreen extends StatefulWidget {
  String? emailID;

  EmailOtpScreen({required this.emailID, super.key});

  @override
  State<EmailOtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<EmailOtpScreen> {
  String? appSignature;
  String? otpCode;
  BusinessDataProvider? productProvider;
  int _start = 60;
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
          time.toStringAsFixed(0)+" S",
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
      textStyle:  GoogleFonts.urbanist(
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
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
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
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9\]")),],
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
                  isReSendDisable?SizedBox(
                    width: double.infinity,
                    child: Row(
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
                    ),
                  ):Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'If you didnt received a code click',
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
                                        reSendOpt(context, productProvider, _controller, widget.emailID);
                                        isReSendDisable = true;
                                      })
                              ]),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'Back',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
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
      ),
    );
  }

  void callVerifyOtpApi(BuildContext context, String otpText, String email,
      BusinessDataProvider productProvider) async {
    var isValid = false;
    if (otpText.isEmpty) {
      Utils.showToast("Please Enter Opt",context);
    } else if (otpText.length < 6) {
      Utils.showToast("PLease Enter Valid Otp",context);
    } else {
      Utils.onLoading(context, "");
      try {
        await productProvider.otpValidateForEmail(
            OtpValidateForEmailRequest(email: email, otp: otpText));
        if (productProvider.getValidOtpEmailData != null &&
            productProvider.getValidOtpEmailData!.status != null &&
            !productProvider.getValidOtpEmailData!.status!) {
          Utils.showToast(productProvider.getValidOtpEmailData!.message!,context);
        } else {
          isValid = true;
          Navigator.of(context, rootNavigator: true).pop();
        }
      } catch (error) {
        // Handle any errors that occur during the API call
        Utils.showToast("An error occurred: $error",context);
      } finally {
        Navigator.of(context, rootNavigator: true).pop({
          'isValid': isValid,
          'Email': email,
        });
      }
    }
  }

  void reSendOpt(BuildContext context, BusinessDataProvider productProvider, CountdownController controller, String? emailID) async {
    Utils.onLoading(context, "");
    SendOtpOnEmailResponce sendOtpOnEmailResponce;
    sendOtpOnEmailResponce = await ApiService().sendOtpOnEmail(emailID!);
    Navigator.of(context, rootNavigator: true).pop();
    if (sendOtpOnEmailResponce != null && sendOtpOnEmailResponce.status!) {
      controller.restart();
      Utils.showToast(sendOtpOnEmailResponce.message!,context);
    }

  }
}