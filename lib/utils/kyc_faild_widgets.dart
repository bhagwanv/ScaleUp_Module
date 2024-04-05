import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view/pancard_screen/PancardScreen.dart';
import 'common_elevted_button.dart';
import 'constants.dart';

class KycFailedWidgets extends StatelessWidget {

  const KycFailedWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 450.0,
      color: Colors.transparent, //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                  alignment:Alignment.topCenter,
                  child:  Image.asset('assets/images/kyc_faild.png')
              ),
            ),
            const SizedBox(height: 40,),

            const Center(
              child: Text(
                'Oops ...',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18, color: redColor),
              ),
            ),

            const SizedBox(height: 20,),

            const Center(
              child: Text(
                'Your Aadhaar could not be validated due to technical reason. Please re-try after sometime.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),

            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 40,right: 20,left: 20),
              child:
              CommonElevatedButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PancardScreen();
                    },
                  ),
                );

              }, text: "RETRY",upperCase: true, ),
            )

          ],
        )),),

    );
  }
}