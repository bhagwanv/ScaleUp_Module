import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../data_provider/DataProvider.dart';
import '../../../shared_preferences/SharedPref.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants.dart';
import '../../../utils/loader.dart';
import '../model/CustomerTransactionListRequestModel.dart';
import 'model/CustomerOrderSummaryResModel.dart';


class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var isLoading = true;
  late CustomerOrderSummaryResModel? customerOrderSummaryResModel = null;
  // Sample data for the lists
  final List<String> verticalList = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  final List<String> horizontalList = ['Item A', 'Item B', 'Item C', 'Item D', 'Item E'];

  var customerName="";
  var totalOutStanding="0";
  var availableLimit="0";
  var totalPayableAmount="0";
  var totalPendingInvoiceCount="0";

  @override
  void initState() {
    super.initState();
    //Api Call
    getCustomerOrderSummary(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Consumer<DataProvider>(builder: (context, productProvider, child) {
            if (productProvider.getCustomerOrderSummaryData == null && isLoading) {
              return Loader();
            } else {
              if (productProvider.getCustomerOrderSummaryData != null && isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }

              if (productProvider.getCustomerOrderSummaryData != null) {
                productProvider.getCustomerOrderSummaryData!.when(
                  success: (CustomerOrderSummaryResModel) async {
                  // await getCustomerTransactionList(context);
                    // Handle successful response
                    customerOrderSummaryResModel = CustomerOrderSummaryResModel;
                    if(customerOrderSummaryResModel!.customerName!=null){
                      customerName=customerOrderSummaryResModel!.customerName!;
                    }

                    if(customerOrderSummaryResModel!.totalOutStanding!=null){
                      totalOutStanding=customerOrderSummaryResModel!.totalOutStanding!.toStringAsFixed(2);
                    }

                    if(customerOrderSummaryResModel!.availableLimit!=null){
                      availableLimit=customerOrderSummaryResModel!.availableLimit!.toStringAsFixed(2);
                    }

                    if(customerOrderSummaryResModel!.totalPayableAmount!=null){
                      totalPayableAmount=customerOrderSummaryResModel!.totalPayableAmount!.toStringAsFixed(2);
                    }
                    if(customerOrderSummaryResModel!.totalPendingInvoiceCount!=null){
                      totalPendingInvoiceCount=customerOrderSummaryResModel!.totalPendingInvoiceCount!.toStringAsFixed(2);
                    }
                  },
                  failure: (exception) {
                    // Handle failure
                    print("dfjsf2");
                    //print('Failure! Error: ${exception.message}');
                  },
                );
              }


              if (productProvider.getCustomerOrderSummaryData != null) {
                productProvider.getCustomerOrderSummaryData!.when(
                  success: (CustomerOrderSummaryResModel) {
                    // Handle successful response
                    customerOrderSummaryResModel = CustomerOrderSummaryResModel;

                  },
                  failure: (exception) {
                    // Handle failure
                    print("dfjsf2");
                    //print('Failure! Error: ${exception.message}');
                  },
                );
              }

              return SingleChildScrollView(
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
                               Column(
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
                                  Text(customerName,
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
                                          Text(
                                            'Total Balance',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 10, color: gryColor),
                                          ),
                                          Text(
                                            totalPayableAmount,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: text_green_color),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            'Available to spend',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 10, color: gryColor),
                                          ),
                                          Text(
                                            availableLimit,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 20, color: Colors.black),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            'Total Outstanding ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 10, color: gryColor),
                                          ),
                                          Text(
                                            totalOutStanding,
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
                          padding:  EdgeInsets.all(10.0),
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
                                       Text(
                                        '$totalPayableAmount  Payable Today',
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
                                      child: const Center(
                                        child: Text(
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
                            decoration: const BoxDecoration(
                              color: text_light_whit_color,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                                      child: Text(
                                        'Vendors',
                                        style: TextStyle(fontSize: 15, color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 150, // Set the height of the horizontal list container
                                      child: _horizontalList(5),
                                    ),
                                  ]
                              ),
                            )
                        ),
                      ]
                  ),
                ),
              );
            }
          }),
        )
    );
  }

  ListView _horizontalList(int n) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(n,
            (i) => GestureDetector(
              onTap: () {
                // Handle click action here
                print('Item $i clicked');
              },
              child: Container(
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
            ),),
      ),
    );
  }


  Future<void> getCustomerOrderSummary(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
  //  final int? leadId = prefsUtil.getInt(LEADE_ID);

    Provider.of<DataProvider>(context, listen: false).getCustomerOrderSummary(257);
  }

  Future<void> getCustomerTransactionList(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    Utils.onLoading(context, "");
    var  customerTransactionListRequestModel=CustomerTransactionListRequestModel(anchorCompanyID:"2",leadId:"257",skip:"0",take:"5",transactionType:"All");
    await Provider.of<DataProvider>(context, listen: false).getCustomerTransactionList(customerTransactionListRequestModel);
    Navigator.of(context, rootNavigator: true).pop();

  }
}
