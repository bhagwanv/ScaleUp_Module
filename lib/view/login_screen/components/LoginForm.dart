import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/data_provider/DataProvider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/common_elevted_button.dart';
import 'package:scale_up_module/view/otp_screens/OtpScreen.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../shared_preferences/SharedPref.dart';
import '../../../utils/common_check_box.dart';
import '../../../utils/constants.dart';

class LoginForm extends StatefulWidget {
  DataProvider? productProvider;


  LoginForm({
    required this.productProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SharedPref sharedPref = SharedPref();
     bool isTermsChecks= false;
    final TextEditingController _mobileNumberCl = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          SizedBox(
            width: 58,
            child: TextField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 10,
              maxLines: 1,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                hintText: "+91",
                fillColor: textFiledBackgroundColour,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: kPrimaryColor)),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: SizedBox(
              child: TextField(
                controller: _mobileNumberCl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 10,
                maxLines: 1,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  hintText: "Enter Your Number",
                  fillColor: textFiledBackgroundColour,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
          )
        ]),
        const SizedBox(
          height: 50,
        ),
         Column(
          children: [
            CommonCheckBox(
              onChanged: (bool isChecked) {
                print("$isChecked");
                isTermsChecks = isChecked;
              },
              text: "I acknowledge and consent to the sharing of my data for the purpose of Scaleup pay application. I understand that my data may be used in accordance with the scaleup privacy policy. By proceeding, I agree to these terms.",
              upperCase: true,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              CommonElevatedButton(
                onPressed: () async {
                  if (_mobileNumberCl.text.isEmpty) {
                    Utils.showToast("Please Enter Mobile Number");
                  } else if (!Utils.isPhoneNoValid(_mobileNumberCl.text)) {
                    Utils.showToast("Please Enter Valid Mobile Number");
                  }else if(!isTermsChecks) {
                    Utils.showToast("Please Check Terms And Conditions");
                  } else {
                    Utils.hideKeyBored(context);

                    Utils.onLoading(context, "Loading....");
                    await Provider.of<DataProvider>(context, listen: false)
                        .genrateOtp(_mobileNumberCl.text, 2);
                    if (!widget.productProvider!.genrateOptData!.status!) {
                      Navigator.of(context, rootNavigator: true).pop();
                      Utils.showToast("Something went wrong");
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                      final signcode = await SmsAutoFill().getAppSignature;
                      print("Bhagwan " + signcode);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const OtpScreen();
                          },
                        ),
                      );
                    }
                  }
                  ;
                },
                text: "GET OTP",
                upperCase: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

