
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Utils {
  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
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

  static  onLoading(BuildContext context, String msg) {
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