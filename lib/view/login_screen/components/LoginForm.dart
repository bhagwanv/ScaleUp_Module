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
  int? activityId;
  int? subActivityId;

  LoginForm(
      {required this.productProvider,
      required this.activityId,
      required this.subActivityId,
      super.key});

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
    bool isTermsChecks = false;
    final TextEditingController _mobileNumberCl = TextEditingController();
    String _code = "";

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
              text:
                  "I acknowledge and consent to the sharing of my data for the purpose of Scaleup pay application. I understand that my data may be used in accordance with the scaleup privacy policy. By proceeding, I agree to these terms.",
              upperCase: false,
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
                  } else if (!isTermsChecks) {
                    Utils.showToast("Please Check Terms And Conditions");
                  } else {
                    Utils.hideKeyBored(context);

                    final prefsUtil = await SharedPref.getInstance();
                    Utils.onLoading(context, "Loading....");
                    await Provider.of<DataProvider>(context, listen: false)
                        .genrateOtp(_mobileNumberCl.text,
                            prefsUtil.getInt(COMPANY_ID)!);
                    Navigator.of(context, rootNavigator: true).pop();

                    if (widget.productProvider!.genrateOptData != null) {
                      widget.productProvider!.genrateOptData!.when(
                        success: (GenrateOptResponceModel) async {
                          // Handle successful response
                          var genrateOptResponceModel = GenrateOptResponceModel;

                          if (!genrateOptResponceModel.status!) {
                            Utils.showToast(genrateOptResponceModel.message!);
                          } else {
                            await prefsUtil.saveString(LOGIN_MOBILE_NUMBER,
                                _mobileNumberCl.text.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return OtpScreen(
                                      activityId: widget.activityId!,
                                      subActivityId: widget.subActivityId!);
                                },
                              ),
                            );
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
