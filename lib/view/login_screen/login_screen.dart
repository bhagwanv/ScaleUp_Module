import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/data_provider/DataProvider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/constants.dart';
import 'components/LoginForm.dart';

class LoginScreen extends StatelessWidget {
  final int activityId;
  final int subActivityId;
  final int? companyID;
  final int?  ProductID;
  final String?  MobileNumber;

  const LoginScreen(
      {super.key, required this.activityId, required this.subActivityId, this.companyID, this.ProductID,this.MobileNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          SafeArea(
            top: false,
            child: Consumer<DataProvider>(builder: (context, productProvider, child) {
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
    );
  }
}

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          debugPrint("didPop1: $didPop");
          if (didPop) {
            return;
          }
          final bool shouldPop = await _onback(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: 100, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30, top: 50),
                child: Text(
                  "Enter\nPhone Number",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 35.5),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, left: 30),
                child: Text(
                  "Please Enter Your registered number.",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 30),
                child: Text(
                  "Enter Your Number",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: gryColor),
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
        ));
  }


  Future<bool> _onback(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit an App'),
          actions: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                SharedPref preferences = await SharedPref.getInstance();
                await preferences.clear();
                Navigator.of(context).pop(true);
              },
              child: Text("YES"),
            ),
          ],
        );
      }),
    );

    return exitApp ?? false;
  }

}
