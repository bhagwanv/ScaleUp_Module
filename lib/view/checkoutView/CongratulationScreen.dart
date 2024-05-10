import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../utils/constants.dart';

class CongratulationScreen extends StatefulWidget {


  CongratulationScreen({Key? key,}) : super(key: key);

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
         // SystemNavigator.pop();
          redirect();
        });
      },
    );
  }

  static Future<void> redirect() async {
    try {
      await platform.invokeMethod('returnToPayment');
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
