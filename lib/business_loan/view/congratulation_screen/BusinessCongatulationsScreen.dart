import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../supply_chain/utils/common_elevted_button.dart';
import '../../utils/constants.dart';

class BusinessCongatulationsScreen extends StatefulWidget {

  const BusinessCongatulationsScreen(
      {super.key,});



  @override
  State<BusinessCongatulationsScreen> createState() => _BusinesscongatulationsscreenState();
}

class _BusinesscongatulationsscreenState extends State<BusinessCongatulationsScreen> {
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
        style: GoogleFonts.urbanist(
          fontSize: 15,
          color:Colors.blue,
          fontWeight: FontWeight.w400,
        ),
      ),
      interval: Duration(seconds: 1),
      onFinished: () {
        setState(() {
          /*redirect(widget.transactionReqNo,widget.amount,widget.mobileNo!,widget.loanAccountId!,widget.creditDay!);*/
         // SystemNavigator.pop();
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
                      height: 70,
                    ),

                    Container(
                        height: 250,
                        width: 250,
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset("assets/images/congratulation.svg")),

                    Center(
                      child: Text(
                        "Congratulations",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 17,
                          color:kPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Congratulations on sucessfully completing your loan journey with us.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color:Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "We will be in touch with you soon to guide you through the process of E-mandate and E-signing the loan agreement. ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color:Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "While the loan disbursal process may take a little time. please rest assured that our dedicated experts are committed to expenditing the procedure while maintaining the highest standards of security and compliance. ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color:Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "For more details you can call us at Phone no: +91 99815 31563 ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color:Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    /*Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You will be redirected in ",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              color:kPrimaryColor,
                              fontWeight: FontWeight.w400,
                            ),

                          ),
                          buildCountdown(),
                        ],
                      ),
                    ),*/

                    CommonElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      text: "BACK TO HOME",
                      upperCase: true,
                    )


                  ],
                ),
              )),
        ),
      ),
    );
  }
}
