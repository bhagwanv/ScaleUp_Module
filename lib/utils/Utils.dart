
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'adhar_faild_widgets.dart';
import 'kyc_faild_widgets.dart';

class Utils {
  static void showToast(String msg,BuildContext context) {

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert",
      style: TextStyle(),),
      content: Text(msg, textAlign: TextAlign.justify),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showBottomToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static void showBottomSheet(BuildContext context,String msg,String imagePath) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              child: KycFailedWidgets(message: msg, imagePath: imagePath));
        });
  }
  static void showBottomSheetKeyFailed(BuildContext context,String msg,String imagePath,int activityId,int subActivityId) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              child: AdharFailedWidgets(message: msg, imagePath: imagePath,activityId: activityId,subActivityId: subActivityId,));
        });
  }

  static bool isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null) return false;
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phoneNo);
  }

 static bool validateEmail(String value) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
  }


  static bool isValidIFSCCode(String? ifscCode) {
    if (ifscCode == null) return false;
    final regExp = RegExp(r"^[A-Za-z]{4}[a-zA-Z0-9]{7}$");
    return regExp.hasMatch(ifscCode);
  }

  static void showMsgDialog(BuildContext context, String title, String msg,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

 /* static  onLoading(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 20.0,height: 60.0),
              new CircularProgressIndicator(),
              SizedBox(width: 20.0,height: 60.0),
              new Text(msg),
            ],
          ),
        ),
      ),
    );
  }*/

  static onLoading(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20.0, height: 60.0),
              // Replace CircularProgressIndicator with your custom image
              Image.asset(
                'assets/images/scalup_loder.gif',
                width: 200.0,
                height: 200.0,
                // Adjust width and height according to your image size
              ),
              SizedBox(width: 20.0, height: 60.0),
              Text(msg),
            ],
          ),
        ),
      ),
    );
  }


  static void hideKeyBored(BuildContext context){
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static String dateFormate(BuildContext context,String date){
    String inputString = date;

    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(inputString);

    // Format the DateTime into "dd/MM/yyyy" using intl package
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate;

  }
}