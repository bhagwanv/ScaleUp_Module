import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../data_provider/DataProvider.dart';
import '../../../shared_preferences/SharedPref.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants.dart';
import '../../../utils/loader.dart';
import '../model/CustomerTransactionListRequestModel.dart';
import '../my_account/model/CustomerOrderSummaryResModel.dart';
import '../my_account/model/CustomerTransactionListRespModel.dart';
import '../transactions_screen/model/CustomerTransactionListTwoRespModel.dart';
import 'model/TransactionBreakupResModel.dart';
import 'model/TransactionList.dart';

class VendorDetailScreen extends StatefulWidget {
  const VendorDetailScreen({super.key});

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  var isLoading = true;
  late CustomerOrderSummaryResModel? customerOrderSummaryResModel = null;
  List<CustomerTransactionListRespModel> customerTransactionList = [];
  List<TransactionList> transactionList = [];

  var customerName = "";
  var customerImage = "";
  var totalOutStanding = "0";
  var availableLimit = "0";
  var totalPayableAmount = "0";
  var totalPendingInvoiceCount = "0";

  var selectedTab = 0;
  ScrollController _scrollController = ScrollController();
  var loading = true;
  var skip = 0;
  var take = "10";
  var transactionType = "UnPaid";

  var totalAmount = "";

  @override
  void initState() {
    super.initState();

    //Api Call
    getCustomerOrderSummary(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load more data if not already loading
        if (loading) {
          skip += 10;
          getCustomerTransactionList(context);
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
            getCustomerTransactionList(context);
          }

          if (productProvider.getCustomerOrderSummaryData != null) {
            productProvider.getCustomerOrderSummaryData!.when(
              success: (CustomerOrderSummaryResModel) async {
                // Handle successful response
                customerOrderSummaryResModel = CustomerOrderSummaryResModel;
                if (customerOrderSummaryResModel!.customerName != null) {
                  customerName = customerOrderSummaryResModel!.customerName!;
                }

                if (customerOrderSummaryResModel!.customerImage != null) {
                  customerImage = customerOrderSummaryResModel!.customerImage!;
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
                      .toString();
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
                  customerTransactionList.addAll(data);
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
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color: kPrimaryColor, // Example color
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                                      fontSize: 10.0,
                                      color: whiteColor,
                                      letterSpacing: 0.20000000298023224,
                                      fontWeight: FontWeight.w400,
                                        height: 1.5
                                    ),
                                ),
                                Text(customerName,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15.0,
                                      color: whiteColor,
                                      letterSpacing: 0.20000000298023224,
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
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12.0,
                                                  color: text_orange_color,
                                                  fontWeight: FontWeight.w700,
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
                                           /* Text(
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
                                            ),*/
                                            SizedBox(height: 10),
                                            Text(
                                              'Available to spend',
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 10.0,
                                                color: gryColor,
                                                fontWeight: FontWeight.w400,
                                              ),

                                            ),
                                            Text(
                                              '₹ $availableLimit',
                                              textAlign: TextAlign.end,

                                              style: GoogleFonts.urbanist(
                                                fontSize: 25.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Total Outstanding ',
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 10.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              '₹ $totalOutStanding',
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 15.0,
                                                color: text_orange_color,
                                                fontWeight: FontWeight.w400,
                                              ),
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
                                          style: GoogleFonts.urbanist(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'Total Pending Invoice Count: $totalPendingInvoiceCount',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10.0,
                                            color: gryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                /*InkWell(
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
                    ],
                  ),
                ),
                Material(
                  child: Container(
                    height: 70,
                    color: Colors.white,
                    child: TabBar(
                      onTap: (index) {
                        if (selectedTab != index) {
                          setState(() {
                            selectedTab = index;
                            if (selectedTab == 1) {
                              customerTransactionList.clear();
                              productProvider
                                  .disposegetCustomerTransactionList();
                              transactionType = "Paid";
                              skip = 0;
                              loading = false;
                              getCustomerTransactionList(context);
                            } else {
                              customerTransactionList.clear();
                              productProvider
                                  .disposegetCustomerTransactionList();
                              transactionType = "UnPaid";
                              skip = 0;
                              loading = false;
                              getCustomerTransactionList(context);
                            }
                          });
                        }
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
                                style: GoogleFonts.urbanist(
                                  fontSize: 12.0,
                                    color: selectedTab == 0
                                        ? Colors.white
                                        : Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
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
                              child: Text("PAID PAYMENT",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12.0,
                                      color: selectedTab == 1
                                          ? Colors.white
                                          : Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _myListView(
                          context, customerTransactionList, productProvider),
                      _myListView(
                          context, customerTransactionList, productProvider)
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

  Widget _myListView(
      BuildContext context,
      List<CustomerTransactionListRespModel> customerTransactionList,
      DataProvider productProvider) {
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
          String paidAmount = transaction.paidAmount?.toStringAsFixed(2) ?? '';
          String invoiceNo = transaction.invoiceNo ?? '';

          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
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
                                      style: GoogleFonts.urbanist(
                                        fontSize: 10.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    //showDialog(context,"sdf");
                                    transactionList.clear();
                                    await getTransactionBreakup(
                                        context, productProvider,invoiceId);
                                    _showDialog(context, productProvider,
                                        transactionList);
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/ic_information.svg',
                                    semanticsLabel: 'ic_information SVG',
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 32,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Align children to the start and end of the row
                              children: [
                                Text(
                                  anchorName,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "$status",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15.0,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Align children to the start and end of the row
                              children: [
                                Text(
                                  "Order No : $orderId",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Invoice No: $invoiceNo",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),


                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Divider(
                                height: 1,
                                color: kPrimaryColor,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Order Amount',
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                  ),

                                ),
                                Text(
                                  'Payable Amount',
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                  ),
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
                                  style: GoogleFonts.urbanist(
                                    fontSize: 20.0,
                                    color: text_green_color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '₹ $paidAmount',
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 20.0,
                                    color: text_green_color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                              ],
                            ),

                            /*InkWell(
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
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> getCustomerOrderSummary(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    //int leadId=257;
    Provider.of<DataProvider>(context, listen: false)
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
      loading = true;
    });
  }

  Future<void> getTransactionBreakup(
      BuildContext context, DataProvider productProvider, String invoiceId) async {
    final prefsUtil = await SharedPref.getInstance();

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
                  style: GoogleFonts.urbanist(
                    fontSize: 15.0,
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
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '₹ $totalAmount',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.urbanist(
                        fontSize: 15.0,
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
                    style: GoogleFonts.urbanist(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '₹ $amount',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.urbanist(
                      fontSize: 15.0,
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
