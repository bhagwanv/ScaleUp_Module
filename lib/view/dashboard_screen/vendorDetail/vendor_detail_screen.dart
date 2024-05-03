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
import '../my_account/model/CustomerOrderSummaryResModel.dart';
import '../transactions_screen/model/CustomerTransactionListTwoRespModel.dart';

class VendorDetailScreen extends StatefulWidget {
  const VendorDetailScreen({super.key});

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  var isLoading = true;
  late CustomerOrderSummaryResModel? customerOrderSummaryResModel = null;
  List<CustomerTransactionListTwoRespModel> customerTransactionList = [];

  var customerName = "";
  var totalOutStanding = "0";
  var availableLimit = "0";
  var totalPayableAmount = "0";
  var totalPendingInvoiceCount = "0";

  var selectedTab = 0;

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
          if (productProvider.getCustomerOrderSummaryData != null &&
              isLoading) {
            Navigator.of(context, rootNavigator: true).pop();
            isLoading = false;
          }

          if (productProvider.getCustomerOrderSummaryData != null) {
            productProvider.getCustomerOrderSummaryData!.when(
              success: (CustomerOrderSummaryResModel) async {
                // Handle successful response
                customerOrderSummaryResModel = CustomerOrderSummaryResModel;
                if (customerOrderSummaryResModel!.customerName != null) {
                  customerName = customerOrderSummaryResModel!.customerName!;
                }

                if (customerOrderSummaryResModel!.totalOutStanding != null) {
                  totalOutStanding = customerOrderSummaryResModel!
                      .totalOutStanding!
                      .toStringAsFixed(2);
                }

                if (customerOrderSummaryResModel!.availableLimit != null) {
                  availableLimit = customerOrderSummaryResModel!.availableLimit!
                      .toStringAsFixed(2);
                }

                if (customerOrderSummaryResModel!.totalPayableAmount != null) {
                  totalPayableAmount = customerOrderSummaryResModel!
                      .totalPayableAmount!
                      .toStringAsFixed(2);
                }
                if (customerOrderSummaryResModel!.totalPendingInvoiceCount !=
                    null) {
                  totalPendingInvoiceCount = customerOrderSummaryResModel!
                      .totalPendingInvoiceCount!
                      .toStringAsFixed(2);
                }
              },
              failure: (exception) {
                print("dfjsf2");
              },
            );
          }
          if (productProvider.getCustomerTransactionListData != null) {
            productProvider.getCustomerTransactionListData!.when(
              success: (data) {
                customerTransactionList.addAll(data);
              },
              failure: (exception) {
                // Handle failure
                print("dfjsf2");
                //print('Failure! Error: ${exception.message}');
              },
            );
          }
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color: Colors.blue, // Example color
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the value to change the roundness
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        height: 166.0,
                                        width: double.infinity,
                                        color: card_color,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'assets/images/direct_logo.png',
                                              ),
                                              Text(
                                                'Shopkirana'.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Total Balance',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: gryColor),
                                            ),
                                            Text(
                                              '₹ $totalPayableAmount',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: text_green_color,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Available to spend',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: gryColor),
                                            ),
                                            Text(
                                              '₹ $availableLimit',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Total Outstanding ',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '₹ $totalOutStanding',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: text_orange_color),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Add more widgets as needed
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
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
                                      '₹ $totalPayableAmount  Payable Today',
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
                    ],
                  ),
                ),
                Material(
                  child: Container(
                    height: 70,
                    color: Colors.white,
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          selectedTab = index;
                          if(selectedTab == 1) {
                            getCustomerTransactionList(context);
                          }
                        });
                      },
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      tabs: [
                        Tab(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? kPrimaryColor
                                    : text_light_blue_color,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: selectedTab == 0
                                        ? kPrimaryColor
                                        : kPrimaryColor,
                                    width: 0)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "PENDING",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: selectedTab == 0
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? kPrimaryColor
                                    : text_light_blue_color,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: selectedTab == 1
                                        ? kPrimaryColor
                                        : text_light_blue_color,
                                    width: 0)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Status",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: selectedTab == 1
                                          ? Colors.white
                                          : Colors.black)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _myListView(context,customerTransactionList),
                      _myListView(context,customerTransactionList)
                    ],
                  ),
                )
              ],
            ),
          );
        }
      }),
    ));
  }

  Widget _myListView(BuildContext context, List<CustomerTransactionListTwoRespModel> customerTransactionList) {
    if (customerTransactionList == null || customerTransactionList!.isEmpty) {
      // Return a widget indicating that the list is empty or null
      /*  return Center(
        child: Text('No transactions available'),
      );*/

    }


    return ListView.builder(
     // controller: _scrollController,
      itemCount: customerTransactionList!.length,
      itemBuilder: (context, index) {
        if (index < customerTransactionList.length) {
          CustomerTransactionListTwoRespModel transaction = customerTransactionList![index];



          // Null check for each property before accessing it
          String anchorName = transaction.anchorName ?? ''; // Default value if anchorName is null
          String dueDate = transaction.dueDate!=null?Utils.convertDateTime(transaction.dueDate!):"" ;
          String orderId = transaction.orderId ?? '';
          String status = transaction.status ?? '';
          int? amount = int.tryParse(transaction.amount.toString());
          String? transactionId = transaction.transactionId.toString() ?? '';
          String? invoiceId = transaction.invoiceId.toString() ?? '';
          String paidAmount = transaction.paidAmount?.toString() ?? '';
          String invoiceNo = transaction.invoiceNo ?? '';

          return Card(
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12.0), // Set border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],

              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/add_circle.svg',
                                semanticsLabel: 'add_circle SVG',
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                anchorName,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(
                                dueDate,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order ID  $orderId",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                " ₹ ${amount.toString()}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );;
        } else {
          print("112");
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child:  Utils.onLoading(context, ""), // Loading indicator
            ),
          );
        }
      },
    );
  }

  Future<void> getCustomerOrderSummary(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    //  final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<DataProvider>(context, listen: false)
        .getCustomerOrderSummary(257);
    if(selectedTab == 0) {
      getCustomerTransactionList(context);
    }
  }

  Future<void> getCustomerTransactionList(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    Utils.onLoading(context, "");
    var customerTransactionListRequestModel =
        CustomerTransactionListRequestModel(
            anchorCompanyID: "2",
            leadId: "257",
            skip: "0",
            take: "5",
            transactionType: "All");
    await Provider.of<DataProvider>(context, listen: false)
        .getCustomerTransactionList(customerTransactionListRequestModel);
    Navigator.of(context, rootNavigator: true).pop();
  }
}
