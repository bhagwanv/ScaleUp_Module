import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/view/checkoutView/CheckOutOtpScreen.dart';
import 'package:scale_up_module/view/checkoutView/CongratulationScreen.dart';
import 'package:scale_up_module/view/splash_screen/SplashScreen.dart';
import 'data_provider/DataProvider.dart';

var mobileNumber = "";
var company = "";
var product = "";
var isPayNow = false;
// var transactionId = "202420";
var transactionId = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static const platform = MethodChannel('com.ScaleUP');

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var mobileNumber = "";
  var company = "";
  var product = "";
  var isPayNow = false;
  var transactionId = "";

  @override
  void initState() {
    super.initState();
    _initPlatform();
  }

  void _initPlatform() {
    MyApp.platform.setMethodCallHandler(_receiveFromHost);
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await MyApp.platform.invokeMethod('ScaleUP');
    } catch (e) {
      print("Error initializing data: $e");
    }
  }

  Widget _buildHome() {
    if (transactionId.isNotEmpty) {
      return CheckOutOtpScreen(transactionId: transactionId);
    } else if (mobileNumber.isNotEmpty) {
      return SplashScreen(mobileNumber: mobileNumber, companyID: company, ProductID: product,);
    } else {
      return EmptyContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scaleup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: _initializeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          } else {
           //return _buildHome();
            //return CheckOutOtpScreen(transactionId: "202423");
           //return CongratulationScreen();
          return SplashScreen(mobileNumber: "6263246384", companyID: "CN_1", ProductID: "CreditLine",);


          }
        },
      ),
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

    if (jData != null) {
      setState(() {
        mobileNumber = jData['mobileNumber'] ?? "";
        company = jData['companyID'] ?? "";
        product = jData['productID'] ?? "";
        isPayNow = jData['isPayNow'] ?? false;
        transactionId = jData['transactionId'] ?? jData['transactionId'];
       // transactionId = "202420" ?? "202420";
      });
    }
  }
}
class EmptyContainer extends StatelessWidget {
  const EmptyContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Hello")));
  }
}
