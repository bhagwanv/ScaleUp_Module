import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../login_screen/components/LoginForm.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0,),
                  Text(
                    "Agreement",
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w100,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 30.0,),
                  Text(
                    "Billing and Credit Card Information",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Billing and Credit Card Information Our Services comprise, generally business coaching Webinars, Seminars and materials distributed on a subscription basis. To enable payment, we collect and store name, address, telephone number, email address, credit card information, and other billing information. This information will only be shared with third parties who facilitate completion of the purchase transaction, such as by fulfilling orders and processing credit card payments.We will not disclose your billing and/or credit card information unless required by law or a court order, or unless disclosure is required to address an issue implicated by the financial transaction. For instance, if you claim that your billing and/or credit card information was used to make a purchase you did not authorize, details about the transaction may be disclosed to law enforcement and any party we deem necessary to address the matter.",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: blackSmall,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 16.0,),
                  CustomCheckbox1(onChanged: (bool isChecked) {
                    // Handle the state change here
                    print('Checkbox state changed: $isChecked');
                  },),

                  SizedBox(height: 30.0,),
                  CommonElevatedButton(
                    onPressed: () {},
                    text: 'Proceed to E-sign',
                    upperCase: true,
                  ),

                ],
              ),
            ),
          )),
    );;
  }
}

class CustomCheckbox1 extends StatefulWidget {
  final ValueChanged<bool>? onChanged;

  CustomCheckbox1({Key? key, this.onChanged}) : super(key: key);
  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox1> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          widget.onChanged?.call(isChecked);
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
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
            Text('Terms & Conditions. '),
          ],
        ),
      ),
    );
  }
}
