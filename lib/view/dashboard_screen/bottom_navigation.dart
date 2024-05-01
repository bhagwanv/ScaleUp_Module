import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scale_up_module/view/dashboard_screen/transactions_screen/transactions_screen.dart';
import 'package:scale_up_module/view/dashboard_screen/vendors_screen/vendors_screen.dart';

import '../../utils/Utils.dart';
import '../../utils/constants.dart';
import 'my_account/my_account.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final List<Widget> _pages = [
    const VendorsScreen(),
    const TransactionScreen(),
    const MyAccount(),
  ];
  var selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[selectedIndex],
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              selectedIndex = 2;
            });
          },
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
          surfaceTintColor: Colors.white,
          shadowColor: textFiledBackgroundColour,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 70,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          elevation: 30,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Menu item
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_vendors.svg',
                      semanticsLabel: 'Verify PAN SVG',
                      color: selectedIndex == 0 ? kPrimaryColor : Colors.black, // Change color based on selected index
                    ),
                    const SizedBox(height: 3), // Add space between icon and text
                    Text(
                      'Vendors',
                      style: TextStyle(
                        color: selectedIndex == 0 ? kPrimaryColor : Colors.black, // Change color based on selected index
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              // Search item
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_transactions.svg',
                      semanticsLabel: 'Verify PAN SVG',
                      color: selectedIndex == 1 ? kPrimaryColor : Colors.black, // Change color based on selected index
                    ),
                    const SizedBox(height: 3), // Add space between icon and text
                    Text(
                      'Transactions',
                      style: TextStyle(
                        color: selectedIndex == 1 ? kPrimaryColor : Colors.black, // Change color based on selected index
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
                  Utils.showBottomToast("Service Not Available");
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_services.svg',
                      semanticsLabel: 'Verify PAN SVG',
                      color: selectedIndex == 2 ? kPrimaryColor : Colors.black, // Change color based on selected index
                    ),
                    const SizedBox(height: 3), // Add space between icon and text
                    Text(
                      'Services',
                      style: TextStyle(
                        color: selectedIndex == 2 ? kPrimaryColor : Colors.black, // Change color based on selected index
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              // People item
              GestureDetector(
                onTap: () {
                  Utils.showBottomToast("Service Not Available");
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_setting.svg',
                      semanticsLabel: 'Verify PAN SVG',
                      color: selectedIndex == 3 ? kPrimaryColor : Colors.black, // Change color based on selected index
                    ),
                    const SizedBox(height: 3), // Add space between icon and text
                    Text(
                      'Setting',
                      style: TextStyle(
                        color: selectedIndex == 3 ? kPrimaryColor : Colors.black, // Change color based on selected index
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )


    );
  }
}
