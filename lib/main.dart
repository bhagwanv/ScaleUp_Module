import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/checkoutView/PaymentConfirmation.dart';
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

     // home: LoginScreen(activityId: 1, subActivityId: 0, companyID: int.parse(companyID), ProductID:int.parse(ProductID), MobileNumber: mobileNumber.toString()),
     // home: LoginScreen(activityId: 1, subActivityId: 0, companyID: 2, ProductID:2, MobileNumber: "9179173021"),
     //home:  CreditLineApproved(activityId: 2, subActivityId: 1,isDisbursement: false)
      /*LoginScreen(activityId: 1, subActivityId: 0),*/
     // home:CheckOutOtpScreen()
      home:PaymentConfirmation(transactionReqNo: "2024620",customerName: "Bhagwan",imageUrl: "",customerCareEmail: "",customerCareMoblie: "",)
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
