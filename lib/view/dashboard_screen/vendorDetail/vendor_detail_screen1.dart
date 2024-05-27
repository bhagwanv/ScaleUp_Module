import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/constants.dart';
import 'package:scale_up_module/utils/loader.dart';
import 'package:scale_up_module/view/dashboard_screen/model/CustomerTransactionListRequestModel.dart';
import 'package:scale_up_module/view/dashboard_screen/my_account/model/CustomerOrderSummaryResModel.dart';
import 'package:scale_up_module/view/dashboard_screen/my_account/model/CustomerTransactionListRespModel.dart';
import 'package:scale_up_module/view/dashboard_screen/vendorDetail/model/TransactionList.dart';
import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../data_provider/DataProvider.dart';

class Vendor_detail_screen1 extends StatefulWidget {
  const Vendor_detail_screen1({
    Key? key,
  }) : super(key: key);

  @override
  _Vendor_detail_screen1State createState() => _Vendor_detail_screen1State();
}

class _Vendor_detail_screen1State extends State<Vendor_detail_screen1>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
  var loading = false;
  var skip = 0;
  var take = "10";
  var transactionType = "UnPaid";
  ScrollController _scr = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    //Api Call
    getCustomerOrderSummary(context);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate half of the screen height
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight / 2;

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
                  if (exception.statusCode == 401) {
                    productProvider.disposeAllProviderData();
                    ApiService().handle401(context);
                  } else {
                    Utils.showToast(exception.errorMessage, context);
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
                  loading = true;
                } else {
                  loading = false;
                }
              },
              failure: (exception) {
                // Handle failure
                if (exception is ApiException) {
                  if (exception.statusCode == 401) {
                    productProvider.disposeAllProviderData();
                    ApiService().handle401(context);
                  } else {
                    Utils.showToast(exception.errorMessage, context);
                  }
                }
                //print('Failure! Error: ${exception.message}');
              },
            );
          }
          return NestedScrollView(
            body: Builder(
              builder: (context) {
                _scr = PrimaryScrollController.of(context);
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    TabA(
                      _scr,
                      context,
                      customerTransactionList,
                      productProvider,
                      transactionList,
                      transactionType,
                      loading,
                      skip,
                      take,
                    ),
                    TabA(
                        _scr,
                        context,
                        customerTransactionList,
                        productProvider,
                        transactionList,
                        transactionType,
                        loading,
                        skip,
                        take)
                  ],
                );
              },
            ),
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: appBarHeight,
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Container(
                      color: kPrimaryColor, // Example color
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                customerImage.isEmpty
                                    ? Container(
                                        width: 44,
                                        height: 44,
                                        child: SvgPicture.asset(
                                          'assets/images/take_selfie.svg',
                                          semanticsLabel: 'dummy_image SVG',
                                        ),
                                      )
                                    : Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(customerImage),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Welcome back',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                      ),
                                    ),
                                    Text(
                                      customerName,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 15,
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                      ),
                                    ),
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
                                borderRadius: BorderRadius.circular(10),
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Container(
                                            height: 166.0,
                                            width: double.infinity,
                                            color: card_color,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: text_orange_color,
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
                                            padding: const EdgeInsets.only(
                                                right: 16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SizedBox(height: 10),
                                                Text(
                                                  'Available to spend',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: gryColor,
                                                  ),
                                                ),
                                                Text(
                                                  '₹ $availableLimit',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Total Outstanding ',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  '₹ $totalOutStanding',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: text_orange_color,
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: SvgPicture.asset(
                                            'assets/icons/clock.svg',
                                            semanticsLabel: 'clock SVG',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '₹ $totalPayableAmount  Payable Today',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Total Pending Invoice Count: $totalPendingInvoiceCount',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: gryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(60.0),
                    child: Container(
                      color: Colors.white,
                      // Set your desired background color here
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        // Add desired top padding here
                        child: TabBar(
                          physics: NeverScrollableScrollPhysics(),
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
                          unselectedLabelColor: Colors.white,
                          labelColor: Colors.white,
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
                                        : text_light_blue_color,
                                    width: 0,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "PENDING",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: selectedTab == 0
                                          ? Colors.white
                                          : Colors.black,
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
                                    width: 0,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "PAID PAYMENT",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: selectedTab == 1
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          controller: _tabController,
                          indicatorColor: Colors.white,
                          indicatorSize: TabBarIndicatorSize.tab,
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
          );
        }
      }),
    ));
  }

  Future<void> getCustomerOrderSummary(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    // int leadId = 52;
    Provider.of<DataProvider>(context, listen: false)
        .getCustomerOrderSummary(leadId);
  }

  Future<void> getCustomerTransactionList(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();

    var leadeId = prefsUtil.getInt(LEADE_ID)!;
    var companyId = prefsUtil.getInt(COMPANY_ID)!;
    //var companyId = "2";
    //var leadeId = 52;
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
    print("h111");
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scr.dispose();

    super.dispose();
  }
}

class TabA extends StatefulWidget {
  late ScrollController scrollController;
  late BuildContext context;
  late List<CustomerTransactionListRespModel> customerTransactionList;
  late DataProvider productProvider;
  late List<TransactionList> transactionList;
  late String transactionType;
  late bool loading;
  late final int skip;
  late String take;

  TabA(
      this.scrollController,
      this.context,
      this.customerTransactionList,
      this.productProvider,
      this.transactionList,
      this.transactionType,
      this.loading,
      this.skip,
      this.take);

  @override
  State<StatefulWidget> createState() => _TabAState();
}

class _TabAState extends State<TabA> with SingleTickerProviderStateMixin {
  int page = 1;
  late AnimationController controller;
  late Animation<Offset> offset;
  var totalAmount = "";
  var skip1 = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 2.0))
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: _myListView(widget.context, widget.customerTransactionList,
              widget.productProvider, widget.scrollController)),
    );
  }

  void _scrollListener() async {
    /* if (widget.scrollController.position.pixels ==
        widget.scrollController.position.maxScrollExtent) {
      // display loading on bottom of listView
    }*/
    if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      controller.forward();
    }
    if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      controller.reverse();
    }

    if (widget.scrollController.position.pixels ==
        widget.scrollController.position.maxScrollExtent) {
      // Load more data if not already loading
      print("isload ${widget.loading}");
      if (widget.loading) {
        skip1 += 10;
        getCustomerTransactionList(widget.context, widget.transactionType);
      }
    }
  }

  Widget _myListView(
      BuildContext context,
      List<CustomerTransactionListRespModel> customerTransactionList,
      DataProvider productProvider,
      ScrollController _scrollController) {
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
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    //showDialog(context,"sdf");
                                    widget.transactionList.clear();
                                    await getTransactionBreakup(
                                        context, productProvider, invoiceId);
                                    _showDialog(context, productProvider,
                                        widget.transactionList);
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
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "$status",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Align children to the start and end of the row
                              children: [
                                Text(
                                  "Order No : $orderId",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  "Invoice No: $invoiceNo",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
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
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Payable Amount',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
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
                                      fontSize: 20,
                                      color: text_green_color,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '₹ $paidAmount',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: text_green_color,
                                      fontWeight: FontWeight.bold),
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

  Future<void> getTransactionBreakup(BuildContext context,
      DataProvider productProvider, String invoiceId) async {
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
            widget.transactionList
                .addAll(data.transactionList as Iterable<TransactionList>);
            print("sdkfhkdsj${widget.transactionList.first.toJson()}");
          }
        },
        failure: (exception) {
          // Handle failure
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            } else {
              Utils.showToast(exception.errorMessage, context);
            }
          }
          //print('Failure! Error: ${exception.message}');
        },
      );
    }
  }

  Future<void> getCustomerTransactionList(
      BuildContext context, String transactionType) async {
    final prefsUtil = await SharedPref.getInstance();

    var leadeId = prefsUtil.getInt(LEADE_ID)!;
    var companyId = prefsUtil.getInt(COMPANY_ID)!;
    //var companyId = "2";
    //var leadeId = 52;
    Utils.onLoading(context, "");
    var customerTransactionListRequestModel =
        CustomerTransactionListRequestModel(
            anchorCompanyID: companyId.toString(),
            leadId: leadeId.toString(),
            skip: skip1.toString(),
            take: widget.take,
            transactionType: transactionType);
    await Provider.of<DataProvider>(context, listen: false)
        .getCustomerTransactionList(customerTransactionListRequestModel);
    Navigator.of(context, rootNavigator: true).pop();
  }
}
