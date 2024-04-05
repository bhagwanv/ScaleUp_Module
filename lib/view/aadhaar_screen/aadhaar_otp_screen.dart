import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:scale_up_module/view/take_selfi/take_selfi.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/kyc_faild_widgets.dart';

class AadhaarOtpScreen extends StatefulWidget {
  const AadhaarOtpScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 30,top: 50,right: 30,bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 69,width: 51,
                      alignment:Alignment.topLeft,
                      child:  Image.asset('assets/images/scale.png')
                  ),
                  const SizedBox(height: 50,),
                  const Text(
                    'Enter \nVerification Code',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 35, color: Colors.black),
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    'Enter the verification code sent on Aadhaar registered mobile number',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  const SizedBox(height: 55,),
                  Center(
                    child: Pinput(
                      length: 6,
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
                  const SizedBox(height: 40,),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Resend Code in 55 s',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: kPrimaryColor,fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'If you didn’t received a code!',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14,fontWeight: FontWeight.normal),
                              children: <TextSpan>[
                                TextSpan(text: '  Resend',
                                    style: const TextStyle(
                                        color: kPrimaryColor, fontSize: 14,fontWeight: FontWeight.normal),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // navigate to desired screen
                                      }
                                )
                              ]
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  CommonElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const TakeSelfie();
                        },
                      ),
                    );


                  }, text: "Verify Code",upperCase: true, )
                ],
              ),
            ),
          ),
        ));
  }
}

