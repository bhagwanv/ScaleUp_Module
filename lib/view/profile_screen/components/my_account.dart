import 'package:flutter/material.dart';
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
            color:kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    color: Colors.white, // Set the background color of the Card to white
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: SvgPicture.asset(
                                    'assets/images/dummy_image.svg',
                                    semanticsLabel: 'dummy_image SVG',

                                  ),
                                ),
                                const SizedBox(width: 30),
                                Column(
                                  children: [
                                    const Text(
                                      'Total Balance',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                    const Text(
                                      '₹30,000',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Available to spend',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                    const Text(
                                      '₹3,30,000',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                    const SizedBox(height: 10),

                                    const Text(
                                      'Total Outstanding ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                    const Text(
                                      '₹₹30,000',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                    const SizedBox(height: 10),
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
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    color: Colors.white, // Set the background color of the Card to white
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              child: SvgPicture.asset(
                                'assets/images/clock.svg',
                                semanticsLabel: 'Verify PAN SVG',
                              ),
                            ),
                            const Text(
                              '₹30,000 Payable Today',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            Container(
                              child: const Text(
                                'PAY NOW',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ],

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}