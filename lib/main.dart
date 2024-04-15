import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/Bank_details_screen/BankDetailsScreen.dart';
import 'package:scale_up_module/view/aadhaar_screen/aadhaar_screen.dart';
import 'package:scale_up_module/view/login_screen/login_screen.dart';
import 'package:scale_up_module/view/otp_screens/OtpScreen.dart';
import 'package:scale_up_module/view/pancard_screen/PancardScreen.dart';
import 'package:scale_up_module/view/personal_info/PersonalInformation.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scalup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: SplashScreen(),


     /*AadhaarScreen(activityId: 2, subActivityId: 1)*/
     /*LoginScreen(activityId: 1, subActivityId: 0),*/
      //TakeSelfieScreen(activityId: 2, subActivityId: 1),
    );
  }
}
