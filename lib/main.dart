import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/dashboard_screen/bottom_navigation.dart';
import 'package:scale_up_module/view/dashboard_screen/vendorDetail/vendor_detail_screen.dart';
import 'package:scale_up_module/view/login_screen/login_screen.dart';
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

  static const platform = const MethodChannel('com.souvikbiswas.tipsy/result');

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var mobileNumber;
  var company;
  var product;

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

       // home: SplashScreen(companyID: int.parse(company), ProductID:int.parse(product), mobileNumber: mobileNumber.toString())
       // home: SplashScreen(mobileNumber:  "7803994667",ProductID:  2,companyID: 2)
       // home: BottomNav()
            //VendorDetailScreen()
          //home: LoginScreen(activityId: 1, subActivityId: 0, companyID: int.parse(companyID), ProductID:int.parse(ProductID), MobileNumber: mobileNumber.toString()),
          home: LoginScreen(activityId: 10, subActivityId: 0, companyID: 2, ProductID:5, MobileNumber: "7509764461"),
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
        company = jData['companyID'];
        product = jData['productID'];

      //  productCompanyDetail(context, company, Product);
      } else {
        mobileNumber = "";
        company = "";
        product = "";
      }
    });
  }
}
