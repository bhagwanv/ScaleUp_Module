import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/login_screen/login_screen.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';

import '../../data_provider/DataProvider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? mobileNumber;
  String? list;

  @override
  Widget build(BuildContext context) {
    var mobile = "9522392801";

    var leadCurrentRequestModel = LeadCurrentRequestModel(
      companyId: 2,
      productId: 2,
      leadId: 30,
      mobileNo: mobile,
      activityId: 0,
      subActivityId: 0,
      userId: "ddf8360f-ef82-4310-bf6c-a64072728ec3",
      monthlyAvgBuying: 0,
      vintageDays: 0,
      isEditable: true,
    );
    Provider.of<DataProvider>(context, listen: false).leadCurrentActivityAsync(leadCurrentRequestModel);

    Provider.of<DataProvider>(context, listen: false).getLeads("8959311437", 2, 2, 0);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Scaleup')),
      ),
      body: Consumer<DataProvider>(builder: (context, provider, child) {
        if ((provider.getLeadData != null) &&
            (provider.leadCurrentActivityAsyncData != null)) {
          return customerSequence(context);
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/images/scalup_gif_logo.gif')),
            ],
          );
        }
      }),
    );
  }

  customerSequence(BuildContext context) {
    var provider = Provider.of<DataProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
