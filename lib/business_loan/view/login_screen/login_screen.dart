import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/business_loan/data_provider/BusinessDataProvider.dart';
import 'package:scale_up_module/business_loan/utils/Utils.dart';

import '../../utils/constants.dart';
import 'components/LoginForm.dart';

class LoginScreen extends StatelessWidget {
  final int activityId;
  final int subActivityId;
  final int? companyID;
  final int?  ProductID;
  final String?  MobileNumber;
  final String?  pageType;

  const LoginScreen(
      {super.key, required this.activityId, required this.subActivityId, this.companyID, this.ProductID,this.MobileNumber, this.pageType});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        debugPrint("didPop1: $didPop");
        if (didPop) {
          return;
        }
        final bool shouldPop = await Utils().onback(context);
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
              top: false,
              child: Consumer<BusinessDataProvider>(builder: (context, productProvider, child) {
                      return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  LoginScreenTopImage(),
                  Row(
                    children: [
                      Spacer(),
                      Expanded(
                        flex: 8,
                        child: LoginForm(
                          productProvider: productProvider,
                          activityId: activityId,
                          subActivityId: subActivityId,
                          companyID: companyID,
                          ProductID: ProductID,
                            MobileNumber:MobileNumber
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
                      );
                    }),
            ),
      ),
    );
  }
}

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 100, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30, top: 50),
            child: Text(
              "Enter\nPhone Number",
              style: GoogleFonts.urbanist(
                fontSize:  35.5,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 30),
            child: Text(
              "Please Enter Your registered number.",
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 30),
            child: Text(
              "Enter Your Number",
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: gryColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Row(
            children: [
              Spacer(),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
