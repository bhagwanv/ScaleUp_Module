import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../data_provider/DataProvider.dart';
import '../../../shared_preferences/SharedPref.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants.dart';
import '../../../utils/loader.dart';
import '../model/CustomerTransactionListRequestModel.dart';
import '../vendorDetail/model/TransactionList.dart';
import 'model/CustomerOrderSummaryResModel.dart';
import 'model/CustomerTransactionListRespModel.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var isLoading = true;
  late CustomerOrderSummaryResModel? customerOrderSummaryResModel = null;

  // Sample data for the lists
  final List<String> verticalList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5'
  ];
  final List<String> horizontalList = [
    'Item A',
    'Item B',
    'Item C',
    'Item D',
    'Item E'
  ];

  var customerName = "";
  var customerImage = "";
  var totalOutStanding = "0";
  var availableLimit = "0";
  var totalPayableAmount = "0";
  var totalPendingInvoiceCount = "0";
  List<CustomerTransactionListRespModel> customerTransactionList = [];
  var loading = true;
  var skip = 0;
  var take = "5";
  var transactionType = "All";
  ScrollController _scrollController = ScrollController();
  List<TransactionList> transactionList = [];
  var totalAmount = "";

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
          Future.delayed(Duration(seconds: 1), () {
            setState(() {});
          });
          return Loader();
        } else {
          if (productProvider.getCustomerOrderSummaryData != null &&
              isLoading) {
            Navigator.of(context, rootNavigator: true).pop();
            isLoading = false;

            getCustomerTransactionList(context);
          }

          if (productProvider.getCustomerOrderSummaryData != null) {
            productProvider.getCustomerOrderSummaryData!.when(
              success: (CustomerOrderSummaryResModel) async {
                // await getCustomerTransactionList(context);
                // Handle successful response
                customerOrderSummaryResModel = CustomerOrderSummaryResModel;

                if (customerOrderSummaryResModel!.customerName != null) {
                  customerName = customerOrderSummaryResModel!.customerName!;

                  final prefsUtil = await SharedPref.getInstance();
                  prefsUtil.saveString(CUSTOMERNAME,
                      customerOrderSummaryResModel!.customerName!);
                }

                if (customerOrderSummaryResModel!.customerImage != null) {
                  customerImage = customerOrderSummaryResModel!.customerImage!;
                  final prefsUtil = await SharedPref.getInstance();
                  prefsUtil.saveString(CUSTOMER_IMAGE,
                      customerOrderSummaryResModel!.customerImage!);
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


                  totalPendingInvoiceCount = customerOrderSummaryResModel!.totalPendingInvoiceCount.toString();
                 Utils.removeTrailingZeros(totalPendingInvoiceCount);
                }
              },
              failure: (exception) {
                if (exception is ApiException) {
                  if(exception.statusCode==401){
                    productProvider.disposeAllProviderData();
                    ApiService().handle401(context);
                  }else{
                    Utils.showToast(exception.errorMessage,context);
                  }
                }
              },
            );
          }

          if (productProvider.getCustomerTransactionListData != null) {
            productProvider.getCustomerTransactionListData!.when(
              success: (data) {
                if (data.isNotEmpty) {
                  customerTransactionList.clear();
                  customerTransactionList.addAll(data);
                  print("sdfhksf$customerTransactionList");
                } else {
                  loading = false;
                }
              },
              failure: (exception) {
                if (exception is ApiException) {
                  if(exception.statusCode==401){
                    productProvider.disposeAllProviderData();
                    ApiService().handle401(context);
                  }else{
                    Utils.showToast(exception.errorMessage,context);
                  }
                }
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
                            decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(customerImage),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                     /* Text(
                                        'Total Balance',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 10, color: gryColor),
                                      ),
                                      Text(
                                        "₹ $totalPayableAmount",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: text_green_color),
                                      ),*/
                                      SizedBox(height: 15),
                                      Text(
                                        'Available to spend',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 10, color: gryColor),
                                      ),
                                      Text(
                                        "₹ $availableLimit",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        'Total Utilized Limit ',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 10, color: gryColor),
                                      ),
                                      Text(
                                        "₹ $totalOutStanding",
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
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        height: 55,
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
                                      semanticsLabel: 'clock  SVG',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Add some space between the icon and text
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '₹ $totalPayableAmount  Payable Today',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold,),
                                      ),
                                      Text(
                                        'Total Pending Invoice Count : $totalPendingInvoiceCount  ',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 10, color: gryColor),
                                      ),
                                    ],

                                  ),
                                ],
                              ),
                              /* InkWell(
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
                                  ),*/
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                    'Recent Transactions',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 250,
                                  // Set the height of the horizontal list container
                                  child: _RecentTransactionListView(context,
                                      productProvider, customerTransactionList),
                                ),
                              ]),
                        )),
                  ]),
            ),
          );
        }
      }),
    ));
  }

  Future<void> getCustomerOrderSummary(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
     final int? leadId = prefsUtil.getInt(LEADE_ID);
    //final int? leadId = 257;

    await Provider.of<DataProvider>(context, listen: false)
        .getCustomerOrderSummary(leadId);
  }

  Future<void> getCustomerTransactionList(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();

    var leadeId = prefsUtil.getInt(LEADE_ID)!;
     var companyId = prefsUtil.getInt(COMPANY_ID)!;
    //var companyId = "2";
    //var leadeId = 257;
    Utils.onLoading(context, "");
    var customerTransactionListRequestModel =
        CustomerTransactionListRequestModel(
            anchorCompanyID: companyId.toString(),
            leadId: leadeId.toString(),
            skip: skip.toString(),
            take: take,
            transactionType: transactionType);

    await Provider.of<DataProvider>(context, listen: false)
        .getCustomerTransactionList(customerTransactionListRequestModel);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      loading = false;
    });
  }

  Widget _RecentTransactionListView(
      BuildContext context,
      DataProvider productProvider,
      List<CustomerTransactionListRespModel> customerTransactionList) {
    if (customerTransactionList == null || customerTransactionList!.isEmpty) {
      // Return a widget indicating that the list is empty or null
      return Center(
        child: Text('No transactions available'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: customerTransactionList!.length,
      itemBuilder: (context, index) {
        if (index < customerTransactionList.length) {
          CustomerTransactionListRespModel transaction =
              customerTransactionList![index];

          // Null check for each property before accessing it
          String anchorName = transaction.anchorName ??
              ''; // Default value if anchorName is null
          String dueDate = transaction.dueDate != null
              ? Utils.dateMonthAndYearFormat(transaction.dueDate!)
              : "Not generated yet.";
          String orderId = transaction.orderId ?? '';
          String status = transaction.status ?? '';
          int? amount = int.tryParse(transaction.amount.toString());
          String? transactionId = transaction.transactionId.toString() ?? '';
          String? invoiceId = transaction.invoiceId.toString() ?? '';
          String paidAmount = transaction.paidAmount?.toString() ?? '';
          String invoiceNo = transaction.invoiceNo ?? '';

          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(12.0),
                  // Set border radius
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
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: text_orange_color,
                                      width: 5.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: text_orange_color,
                                    // Uniform radius
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 1.0),
                                    child: Text(
                                      'Due on : $dueDate',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    //showDialog(context,"sdf");
                                    transactionList.clear();
                                    await getTransactionBreakup(
                                        context, productProvider, invoiceId);
                                    _showDialog(context, productProvider,
                                        transactionList);
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/ic_information.svg',
                                    semanticsLabel: 'ic_information SVG',
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              anchorName,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order ID  $orderId",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                invoiceNo.isNotEmpty?
                                Text(
                                  "Invoice No : $invoiceNo",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ):Container()
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Divider(
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Order Amount',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Payable Amount',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Align children to the start and end of the row
                              children: [
                                Text(
                                  '₹ $amount',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '₹ $paidAmount',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Align children to the start and end of the row
                              children: [
                                Text(
                                  "Status : $status",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),

                            /*  InkWell(
                                  // Wrap the button in InkWell to make it clickable
                                  onTap: () {
                                    // Handle the pay now button tap
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kPrimaryColor,
                                        width: 5.0,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: kPrimaryColor,
                                      // Uniform radius
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'PAY NOW',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),*/
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> getTransactionBreakup(BuildContext context,
      DataProvider productProvider, String invoiceId) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getTransactionBreakup(int.parse(invoiceId.toString()));
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getTransactionBreakupData != null) {
      productProvider.getTransactionBreakupData!.when(
        success: (data) {
          final totalPayableAmount = data.totalPayableAmount;
          if (totalPayableAmount != null) {
            // totalAmount=int.parse(totalPayableAmount.toString());
            totalAmount = totalPayableAmount.toStringAsFixed(2);
          }

          if (data.transactionList!.isNotEmpty) {
            transactionList
                .addAll(data.transactionList as Iterable<TransactionList>);
            print("sdkfhkdsj${transactionList.first.toJson()}");
          }
        },
        failure: (exception) {
          if (exception is ApiException) {
            if(exception.statusCode==401){
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            }else{
              Utils.showToast(exception.errorMessage,context);
            }
          }
        },
      );
    }
  }

  Future<void> _showDialog(BuildContext context, DataProvider productProvider,
      List<TransactionList> transactionList) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  'assets/icons/close_dilog_icons.svg',
                  semanticsLabel: 'ic_information SVG',
                  color: Colors.black,
                  height: 20,
                  width: 20,
                ),
              ),
              Center(
                child: Text(
                  'Full Breakdown',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          content: SizedBox(
            height: 160,
            width: 300, // Adjust width as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _dialogListView(
                      context, productProvider, transactionList),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(
                    height: 1,
                    color: gryColor,
                  ),
                ), // Add spacing between list and total amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹ $totalAmount',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dialogListView(BuildContext context, DataProvider productProvider,
      List<TransactionList> transactionList) {
    if (transactionList == null || transactionList.isEmpty) {
      // Return a widget indicating that the list is empty or null
      return Center(
        child: Text('No transactions available'),
      );
    }

    return ListView.builder(
      itemCount: transactionList.length,
      itemBuilder: (context, index) {
        TransactionList transaction =
            transactionList[index]; // Access the transaction at index
        // Use transaction data to populate the list item

        dynamic? amount = transaction.amount ?? '';
        String? transactionType = transaction.transactionType.toString() ?? '';

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$transactionType',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹ $amount',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
              // Display other transaction details here based on your data model
            ],
          ),
        );
      },
    );
  }
}
