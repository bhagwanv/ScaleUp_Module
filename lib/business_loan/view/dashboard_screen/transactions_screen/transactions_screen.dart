import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/business_loan/utils/Utils.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../data_provider/BusinessDataProvider.dart';
import '../../../shared_preferences/SharedPref.dart';
import '../../../utils/constants.dart';
import '../../../utils/loader.dart';
import '../vendorDetail/model/TransactionList.dart';
import 'model/CustomerTransactionListTwoReqModel.dart';
import 'model/CustomerTransactionListTwoRespModel.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var isLoading = true;
  var customerName = "";
  var customerImage = "";
  ScrollController _scrollController = ScrollController();
  int skip = 0;
  bool loading = false;
  List<CustomerTransactionListTwoRespModel> customerTransactionList = [];
  bool loadData = false;
  var take = 10;
  List<TransactionList> transactionList = [];
  var totalAmount = "";

  @override
  void initState() {
    super.initState();
    //Api Call
    getCustomerTransactionListTwo(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load more data if not already loading
        if (loading) {
          skip += 10;
          getCustomerTransactionListTwo(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashboard_bg_color_light_blue,
      body: SafeArea(
        top: true,
        bottom: true,
        child:
            Consumer<BusinessDataProvider>(builder: (context, productProvider, child) {
          if (productProvider.getCustomerTransactionListTwoData == null &&
              isLoading) {
            Future.delayed(Duration(seconds: 1), () {
              setState(() {});
            });
            return Loader();
          } else {
            if (productProvider.getCustomerTransactionListTwoData != null &&
                isLoading) {
              Navigator.of(context, rootNavigator: true).pop();
              isLoading = false;
            }
            if (productProvider.getCustomerTransactionListTwoData != null) {
              productProvider.getCustomerTransactionListTwoData!.when(
                success: (data) {
                  // Handle successful response
                  if (data.isNotEmpty) {
                    if (loadData) {
                      customerTransactionList.addAll(data);
                      loadData = false;
                    }
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

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
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
                              style: GoogleFonts.urbanist(
                                fontSize: 10,
                                color: Color.fromRGBO(30, 30, 30, 1),
                                letterSpacing: 0.20000000298023224,
                                fontWeight: FontWeight.w400,
                                  height: 1.5
                              ),
                          ),
                          Text(customerName,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: Color.fromRGBO(30, 30, 30, 1),
                                fontWeight: FontWeight.w400,
                                  height: 1.5
                              ),
                             )
                        ],
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/icons/notification.svg',
                        semanticsLabel: 'notification SVG',
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: customerTransactionList != null
                        ? _myListView(
                            context, customerTransactionList, productProvider)
                        : Container())
              ]),
            );
          }
        }),
      ),
    );
  }

  Widget _myListView(
      BuildContext context,
      List<CustomerTransactionListTwoRespModel> customerTransactionList,
      BusinessDataProvider productProvider) {
    if (customerTransactionList == null || customerTransactionList!.isEmpty) {
      // Return a widget indicating that the list is empty or null
      return Center(
        child: Text('No transactions available'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: customerTransactionList!.length,
      itemBuilder: (context, index) {
        if (index < customerTransactionList.length) {
          CustomerTransactionListTwoRespModel transaction =
              customerTransactionList![index];

          // Null check for each property before accessing it
          String anchorName = transaction.anchorName ??
              ''; // Default value if anchorName is null
          String dueDate = transaction.dueDate != null
              ? Utils.convertDateTime(transaction.dueDate!)
              : "Not generated yet.";
          String orderId = transaction.orderId ?? '';
          String status = transaction.status ?? '';
          int? amount = int.tryParse(transaction.amount.toString());
          String? transactionId = transaction.transactionId.toString() ?? '';
          String? invoiceId = transaction.invoiceId.toString() ?? '';
          String paidAmount = transaction.paidAmount?.toString() ?? '';
          String invoiceNo = transaction.invoiceNo ?? '';

          return GestureDetector(
            onTap: () async {
              transactionList.clear();
              await getTransactionBreakup(context, productProvider, invoiceId);
              _showDialog(context, productProvider, transactionList);
            },
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
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
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                status == "Intransit"
                                    ? SvgPicture.asset(
                                        'assets/icons/add_yellow_circle.svg',
                                        semanticsLabel: 'add_circle SVG',
                                      )
                                    : status == "Overdue"
                                        ? SvgPicture.asset(
                                            'assets/icons/add_red_circle.svg',
                                            semanticsLabel: 'add_circle SVG',
                                          )
                                        : status == "Pending "
                                            ? SvgPicture.asset(
                                                'assets/icons/add_orange_circle.svg',
                                                semanticsLabel:
                                                    'add_circle SVG',
                                              )
                                            : status == "Due"
                                                ? SvgPicture.asset(
                                                    'assets/icons/add_green_circle.svg',
                                                    semanticsLabel:
                                                        'add_circle SVG',
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/icons/add_blue_circle.svg',
                                                    semanticsLabel:
                                                        'add_circle SVG',
                                                  ),
                                Text(
                                  anchorName,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),

                                ),
                                Spacer(),
                                Text(
                                  dueDate,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),

                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  " ₹ ${amount.toString()}",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order No : $orderId",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  " Invoice No : $invoiceNo",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                  ),
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
            ),
          );
          ;
        }
      },
    );
  }

  Future<void> getCustomerTransactionListTwo(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    customerName = prefsUtil.getString(CUSTOMERNAME)!;
    customerImage = prefsUtil.getString(CUSTOMER_IMAGE)!;
    var leadeId = prefsUtil.getInt(LEADE_ID)!;
    //var leadeId = 257;
    if (isLoading) {
      var customerTransactionListTwoReqModel =
          CustomerTransactionListTwoReqModel(
              leadId: leadeId, skip: skip, take: take);
      await Provider.of<BusinessDataProvider>(context, listen: false)
          .getCustomerTransactionListTwo(customerTransactionListTwoReqModel);
    } else {
      Utils.onLoading(context, "");
      var customerTransactionListTwoReqModel =
          CustomerTransactionListTwoReqModel(
              leadId: leadeId, skip: skip, take: take);
      await Provider.of<BusinessDataProvider>(context, listen: false)
          .getCustomerTransactionListTwo(customerTransactionListTwoReqModel);
      Navigator.of(context, rootNavigator: true).pop();
    }
    setState(() {
      loading = true;
      loadData = true;
    });
  }

  Future<void> getTransactionBreakup(BuildContext context,
      BusinessDataProvider productProvider, String invoiceId) async {
    Utils.onLoading(context, "");
    await Provider.of<BusinessDataProvider>(context, listen: false)
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

  Future<void> _showDialog(BuildContext context, BusinessDataProvider productProvider,
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
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
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
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '₹ $totalAmount',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _dialogListView(BuildContext context, BusinessDataProvider productProvider,
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
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '₹ $amount',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
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
