import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;

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
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    height: 200,
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
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  const Text(
                                    '₹30,000',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Available to spend',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  const Text(
                                    '₹3,30,000',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Total Outstanding ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  const Text(
                                    '₹₹30,000',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      // Radius for top-left corner
                      topRight:
                          Radius.circular(20.0), // Radius for top-right corner
                    ), // Adjust the value to change the roundness
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _horizontalList(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: SvgPicture.asset(
          'assets/icons/ic_home.svg',
          semanticsLabel: 'Verify PAN SVG',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color:kPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 60,
        shape: const CircularNotchedRectangle(),
        notchMargin: 7,
        elevation: 20,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Menu item
            GestureDetector(
              onTap: () {
                // Add your onPressed functionality here for Menu item
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_vendors.svg',
                    semanticsLabel: 'Verify PAN SVG',
                  ),
                  const SizedBox(height: 3), // Add space between icon and text
                  Text(
                    'Vendors',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            // Search item
            GestureDetector(
              onTap: () {
                // Add your onPressed functionality here for Search item
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_transactions.svg',
                    semanticsLabel: 'Verify PAN SVG',
                  ),
                  const SizedBox(height: 3), // Add space between icon and text
                  Text(
                    'Transactions',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 24.0),
            // Print item
            GestureDetector(
              onTap: () {
                // Add your onPressed functionality here for Print item
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_services.svg',
                    semanticsLabel: 'Verify PAN SVG',
                  ),
                  const SizedBox(height: 3), // Add space between icon and text
                  Text(
                    'Services',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            // People item
            GestureDetector(
              onTap: () {
                // Add your onPressed functionality here for People item
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_setting.svg',
                    semanticsLabel: 'Verify PAN SVG',
                  ),
                  const SizedBox(height: 3), // Add space between icon and text
                  Text(
                    'Setting',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _horizontalList(int n) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(n,
        (i) => Container(
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
