import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scale_up_module/main.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../utils/constants.dart';
import '../bank_details_screen/model/TransactionDetailModel.dart';

class CongratulationScreen extends StatefulWidget {
   final String transactionReqNo;
   final dynamic amount;
  final String mobileNo;
  final int loanAccountId;
  final int creditDay;

  const CongratulationScreen(
      {super.key,required this.transactionReqNo,required this.amount,required this.mobileNo,required this.loanAccountId,required this.creditDay});



  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  int _start = 5;
  static const platform = MethodChannel('com.ScaleUP');


  final CountdownController _controller = CountdownController(autoStart: true);

  @override
  void initState() {
    _start = 5;
    buildCountdown();
    super.initState();
  }

  Widget buildCountdown() {
    return Countdown(
      controller: _controller,
      seconds: _start,
      build: (_, double time) => Text(
        time.toStringAsFixed(0) + " S",
        style: TextStyle(
          fontSize: 15,
          color: Colors.blue,
          fontWeight: FontWeight.normal,
        ),
      ),
      interval: Duration(seconds: 1),
      onFinished: () {
        setState(() {
         redirect(widget.transactionReqNo,widget.amount,widget.mobileNo!,widget.loanAccountId!,widget.creditDay!);
         SystemNavigator.pop();
        });
      },
    );
  }

  static Future<void> redirect(String? transactionReqNo,dynamic amount,String mobileNumber,int loanAccountId,int creditDay) async {
    try {
      await platform.invokeMethod('returnToPayment', {
        'transactionReqNo': transactionReqNo,
        'amount': amount,
        'mobileNo': mobileNumber,
        'loanAccountId': loanAccountId,
        'creditDay': creditDay,
      });

    } on PlatformException catch (e) {
      print("Failed to redirect: '${e.message}'.");
    }
  }

    @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.transparent, //could change this to Color(0xFF737373),
        //so you don't have to change MaterialApp canvasColor
        child: Container(
          decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))),
          child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     SizedBox(
                      height: 100,
                    ),

                    Container(
                        height: 250,
                        width: 250,
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset("assets/images/congratulation.svg")),
                     SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        "Congratulation",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, color: kPrimaryColor,fontWeight: FontWeight.bold),
                      ),
                    ),
                     SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Your order is Confirmed. To complete the process, avoid clicking back or closing the page. Thank you for choosing us!",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15, color: Colors.black,),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You will be redirected in ",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 15, color: kPrimaryColor,),
                          ),
                          buildCountdown(),
                        ],
                      ),
                    ),

                  ],
                ),
              )),
        ),
      ),
    );
  }
}
