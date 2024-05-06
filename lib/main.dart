import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/view/checkoutView/CheckOutOtpScreen.dart';
import 'package:scale_up_module/view/splash_screen/SplashScreen.dart';
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

  static const platform = MethodChannel('com.ScaleUP');

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mobileNumber="";
  String company="";
  String product ="";
  bool isPayNow =false;

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

           home: isPayNow? CheckOutOtpScreen():mobileNumber.isNotEmpty?SplashScreen(mobileNumber: mobileNumber ,companyID: company, ProductID:product):Container()

       //home: SplashScreen(mobileNumber:  "7803994667",ProductID:  "CreditLine",companyID: "CN_1")
            //VendorDetailScreen()
          //home: LoginScreen(activityId: 1, subActivityId: 0, companyID: int.parse(companyID), ProductID:int.parse(ProductID), MobileNumber: mobileNumber.toString()),
          //home: LoginScreen(activityId: 10, subActivityId: 0, companyID: 2, ProductID:5, MobileNumber: "7509764461"),
            /*AadhaarScreen(activityId: 2, subActivityId: 1)*/
            /*LoginScreen(activityId: 1, subActivityId: 0),*/
            //TakeSelfieScreen(activityId: 2, subActivityId: 1),
            );
  }

  Future<void> _receiveFromHost(MethodCall call) async {
    var jData;
    try {
      if (call.method == "ScaleUP") {
        final String data = call.arguments;
        jData = await jsonDecode(data);
      }
    } on PlatformException catch (error) {
      print(error);
    }

    setState(() {
      if (jData != null) {
        mobileNumber = jData['mobileNumber'];
        company = jData['companyID'];
        product = jData['productID'];
        isPayNow = jData['isPayNow'];

      //  productCompanyDetail(context, company, Product);
      } else {
        mobileNumber = "";
        company = "";
        product = "";
      }
    });
  }
}
