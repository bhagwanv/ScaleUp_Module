import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants.dart';


class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: SingleChildScrollView(
            child: Container(
              color: kPrimaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://googleflutter.com/sample_image.jpg'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Welcome back',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 10,
                                    letterSpacing: 0.20000000298023224,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5)),
                            Text('Hello Vaibhav',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 15,
                                    letterSpacing: 0.20000000298023224,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5))
                          ],
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          'assets/icons/notification.svg',
                          semanticsLabel: 'notification SVG',
                          color: whiteColor,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: 190,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the value to change the roundness
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: SvgPicture.asset(
                                    'assets/images/dummy_image.svg',
                                    semanticsLabel: 'dummy_image SVG',
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Balance',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 10, color: gryColor),
                                    ),
                                    const Text(
                                      '₹30,000',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: text_green_color),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'Available to spend',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 10, color: gryColor),
                                    ),
                                    const Text(
                                      '₹3,30,000 ',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'Total Outstanding ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 10, color: gryColor),
                                    ),
                                    const Text(
                                      '₹30,000',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: text_orange_color),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Add more widgets as needed
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the value to change the roundness
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // Align children to the start and end of the row
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  child: SvgPicture.asset(
                                    'assets/icons/clock.svg',
                                    semanticsLabel: 'Verify PAN SVG',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Add some space between the icon and text
                                const Text(
                                  '₹30,000 Payable Today',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ],
                            ),
                            InkWell(
                              // Wrap the button in InkWell to make it clickable
                              onTap: () {
                                // Handle the pay now button tap
                              },
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: greenColor,
                                    width: 5.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: greenColor,
                                  // Uniform radius
                                ),
                                child: Center(
                                  child: const Text(
                                    'PAY NOW',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 450,
                    decoration: BoxDecoration(
                      color: text_light_whit_color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        // Radius for top-left corner
                        topRight:
                        Radius.circular(20.0), // Radius for top-right corner
                      ), // Adjust the value to change the roundness
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _horizontalList(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  ListView _horizontalList(int n) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(n,
            (i) =>
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.accents[i % 16],
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the value to change the roundness
                            ),
                            // Set the color here
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                'assets/icons/ic_setting.svg',
                                semanticsLabel: 'Verify PAN SVG',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
