
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

   /* var mobile = "9522392801";
    SharedPref sharedPref = SharedPref();
    sharedPref.addStringToSF(sharedPref.MOBILE_NUMBER, mobile);

    sharedPref.getStringValuesSF(sharedPref.MOBILE_NUMBER).then((value) {
      mobileNumber = value;
      print("Mobile Number: $mobileNumber");

    });*/


   /* Provider.of<DataProvider>(context, listen: false).getLeads(8319552433,2,2,0);


    var leadCurrentRequestModel=LeadCurrentRequestModel(
      companyId: 2,
      productId: 2,
      leadId: 30,
      mobileNo: "8319552433",
      activityId: 0,
      subActivityId: 0,
      userId: "ddf8360f-ef82-4310-bf6c-a64072728ec3",
      monthlyAvgBuying: 0,
      vintageDays: 0,
      isEditable: true,);
     Provider.of<DataProvider>(context, listen: false).leadCurrentActivityAsync(leadCurrentRequestModel );*/
    SharedPref sharedPref = SharedPref();
    sharedPref.getStringValuesSF(sharedPref.MOBILE_NUMBER).then((value) {value;});

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: Consumer<DataProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.leadCurrentActivityAsyncData == null) {
            // Show CircularProgressIndicator when data is being fetched
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else {// Close the CircularProgressIndicator when data is fetched// Close the dialog
            if (productProvider.getLeadData == null) {
              // Show CircularProgressIndicator when data is being fetched
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(
                    'Your Text Here${productProvider.leadCurrentActivityAsyncData?.currentSequence}',
                    style: TextStyle(fontSize: 50),
                  ),
                ],
              );
            }
          }
        },

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // Provider.of<DataProvider>(context, listen: false).getLeads(8319552433,2,2,0);
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  YourCustomWidget({required data}) {
    print(data);
  }
}
