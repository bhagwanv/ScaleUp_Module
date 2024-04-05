import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/data_provider/DataProvider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/common_elevted_button.dart';
import 'package:scale_up_module/view/otp_screens/OtpScreen.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../shared_preferences/SharedPref.dart';
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
            CustomCheckbox(),
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
                  } else {
                    Utils.hideKeyBored(context);
                    sharedPref.save(
                        SharedPref.LOGIN_MOBILE_NUMBER, _mobileNumberCl.text);

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

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({super.key});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Container(
        child: Row(
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: isChecked
                  ? Container(
                      color: Color(0xff0196CE),
                      child: Icon(
                        Icons.check,
                        size: 18.0,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ),
            SizedBox(width: 8.0),
            Text('Terms & Conditions.'),
          ],
        ),
      ),
    );
  }
}
