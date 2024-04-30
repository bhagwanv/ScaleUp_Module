import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/view/Bank_details_screen/BankDetailsScreen.dart';
import 'package:scale_up_module/view/aadhaar_screen/aadhaar_screen.dart';
import 'package:scale_up_module/view/business_details_screen/business_details_screen.dart';
import 'package:scale_up_module/view/dashboard_screen/transactions_screen/transactions_screen.dart';
import 'package:scale_up_module/view/dashboard_screen/vendors_screen/vendors_screen.dart';
import 'package:scale_up_module/view/login_screen/login_screen.dart';
import 'package:scale_up_module/view/otp_screens/OtpScreen.dart';
import 'package:scale_up_module/view/pancard_screen/PancardScreen.dart';
import 'package:scale_up_module/view/personal_info/PersonalInformation.dart';
import 'package:scale_up_module/view/profile_screen/components/credit_line_approved.dart';
import 'package:scale_up_module/view/splash_screen/SplashScreen.dart';
import 'package:scale_up_module/view/take_selfi/take_selfi_screen.dart';

import 'data_provider/DataProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static const platform = const MethodChannel('com.souvikbiswas.tipsy/result');

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var mobileNumber;
  var companyID;
  var ProductID;

  @override
  void initState() {
    MyApp.platform.setMethodCallHandler(_receiveFromHost);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scalup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      //home: LoginScreen(activityId: 1, subActivityId: 0, companyID: int.parse(companyID), ProductID:int.parse(ProductID), MobileNumber: mobileNumber.toString()),
    // home: LoginScreen(activityId: 1, subActivityId: 0, companyID: 2, ProductID:2, MobileNumber: "9755108415"),
       home: VendorsScreen(),
      /*AadhaarScreen(activityId: 2, subActivityId: 1)*/
      /*LoginScreen(activityId: 1, subActivityId: 0),*/
      //TakeSelfieScreen(activityId: 2, subActivityId: 1),
    );
  }

  Future<void> _receiveFromHost(MethodCall call) async {
    var jData;

    try {
      if (call.method == "getScaleUPData") {
        final String data = call.arguments;
        jData = await jsonDecode(data);

      }
    } on PlatformException catch (error) {
      print(error);
    }

    setState(() {
      if (jData != null) {
        mobileNumber = jData['mobileNumber'];
        companyID = jData['companyID'];
        ProductID = jData['productID'];
      } else {
        mobileNumber = "";
        companyID = 0;
        ProductID = 0;
      }
    });
  }
}
