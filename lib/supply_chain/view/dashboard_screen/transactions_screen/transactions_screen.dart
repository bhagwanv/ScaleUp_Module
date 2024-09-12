
import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/supply_chain/utils/Utils.dart';
import 'package:scale_up_module/supply_chain/utils/directory_path.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../data_provider/DataProvider.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import '../../../utils/constants.dart';
import '../../../utils/loader.dart';
import '../model/CustomerTransactionListRequestModel.dart';
import '../vendorDetail/model/TransactionList.dart';
import 'model/CustomerTransactionListTwoReqModel.dart';
import 'model/CustomerTransactionListTwoRespModel.dart';
import 'package:path/path.dart' as path;

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

  final List<String> pdfDateRangeList = [
    'Current Month',
    'Last Month',
    'Last 3 Month',
    'Last 6 Month',
    'Select Date Range'
  ];
  String? pdfDateRangeValue;
  var downloadPdfUrl="";

  String? localPdfDateRangeValue=null;

  //download file
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  startDownload() async {
    fileName = path.basename(downloadPdfUrl);
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });

    try {
      await Dio().download(downloadPdfUrl, filePath,
          onReceiveProgress: (count, total) {
            setState(() {
              progress = (count / total);
            });
          }, cancelToken: cancelToken);
      setState(() {
        dowloading = false;
        fileExists = true;
        openfile();
      });
    } catch (e) {
      print(e);
      setState(() {
        dowloading = false;
      });
    }
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      dowloading = false;
    });
  }

  openfile() {
    OpenFile.open(filePath);
  }
  // End Download file



  DateTime date = DateTime.now().subtract(const Duration(days: 1));

  String minDateTime = '2010-05-12';
  String maxDateTime = '2030-11-25';
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  final String _format = 'yyyy-MM-dd';

  DateTime? _dateTime;

  var isStartDateFrom=false;


  String? fromDate="";
  String? toDate="";
  String? showFromDate="";
  String? showToDate="";



  void _showDatePicker(BuildContext context, StateSetter dialogSetState) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        cancel: const Icon(
          Icons.close,
          color: Colors.black38,
        ),
        title: 'Select Date',
        titleTextStyle: GoogleFonts.urbanist(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        showTitle: true,
        selectionOverlayColor: Colors.blue,
      ),
      minDateTime: DateTime.parse(minDateTime),
      maxDateTime: DateTime.parse(maxDateTime),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onConfirm: (dateTime, List<int> index) {
        dialogSetState(() {
          _dateTime = dateTime;

          if (localPdfDateRangeValue == "Select Date Range") {
            if (isStartDateFrom) {
              fromDate = Utils.dateFormate(context, _dateTime.toString(), "MM-dd-yyyy");
              showFromDate = Utils.dateFormate(context, _dateTime.toString(), "dd/MM/yyyy");
            } else {
              toDate = Utils.dateFormate(context, _dateTime.toString(), "MM-dd-yyyy");
              showToDate=Utils.dateFormate(context, _dateTime.toString(), "dd/MM/yyyy");
              if (toDate!.isNotEmpty && fromDate!.isNotEmpty) {

                DateTime fromDateTime = DateFormat("MM-dd-yyyy").parse(fromDate!);
                DateTime toDateTime = DateFormat("MM-dd-yyyy").parse(toDate!);

                if (toDateTime.isAfter(fromDateTime)) {
                  // Show an error message or reset toDate
                  //Utils.showToast("End date can't be before the start date. Please select a valid date.",context);
                  toDate = "";
                  Utils.showBottomToast("End date can't be before the start date. Please select a valid date.");
                }
              }
            }
          } else {
            fromDate = "";
            toDate = "";
          }


        });
      },
    );
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
            Consumer<DataProvider>(builder: (context, productProvider, child) {
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
                                color: Color.fromRGBO(30, 30, 30, 1),
                                letterSpacing: 0.20000000298023224,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),),
                          Text(customerName,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.urbanist(
                                fontSize: 15.0,
                                color: Color.fromRGBO(30, 30, 30, 1),
                                letterSpacing: 0.20000000298023224,
                                fontWeight: FontWeight.w400,
                                  height: 1.5
                              ),)
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              print("click");
                            },
                            child: SvgPicture.asset(
                              'assets/icons/notification.svg',
                              semanticsLabel: 'notification SVG',
                                color: kPrimaryColor,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: (){
                                print("click");
                                _showDialogPdf(context, productProvider);
                              },
                              child: SvgPicture.asset(
                                'assets/icons/Ic_pdf_icon.svg',
                                semanticsLabel: 'notification SVG',
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                        ],
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
                                    fontSize: 12.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),

                                ),
                                Spacer(),
                                Text(
                                  dueDate,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12.0,
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
                                    fontSize: 15.0,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  " ₹ ${amount.toString()}",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15.0,
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
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                                                 ),
                                Text(
                                  " Invoice No : $invoiceNo",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12.0,
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

  Future<void> _showDialogPdf(BuildContext context, DataProvider productProvider) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      localPdfDateRangeValue=null;
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
                      'Account Statement',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.urbanist(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Duration',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.urbanist(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    ),
                    hint: Text(
                      'Select Date Range',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: blueColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    items: _addDividersAfterItems(pdfDateRangeList),
                    value: localPdfDateRangeValue,
                    onChanged: (String? value) {
                      setState(() {
                        localPdfDateRangeValue = value;
                         if(localPdfDateRangeValue=="Current Month"){
                           handleDateDuration("Current");
                         }else if(localPdfDateRangeValue=="Last Month"){
                           handleDateDuration("Last");
                         }else if(localPdfDateRangeValue=="Last 3 Month"){
                           handleDateDuration("LastThree");
                         }else if(localPdfDateRangeValue=="Last 6 Month"){
                           handleDateDuration("LastSix");
                         }else{
                           fromDate="";
                           toDate="";
                         }

                      });
                    },
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.keyboard_arrow_down),
                      ),
                      openMenuIcon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.keyboard_arrow_up),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  localPdfDateRangeValue == "Select Date Range"
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date Range',
                        style: GoogleFonts.urbanist(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'From',
                        style: GoogleFonts.urbanist(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          isStartDateFrom=true;
                          _showDatePicker(context, setState);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: textFiledBackgroundColour,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kPrimaryColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fromDate!.isNotEmpty
                                      ? '${showFromDate}'
                                      : 'Start Date',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Icon(Icons.date_range),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'To',
                        style: GoogleFonts.urbanist(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          isStartDateFrom=false;
                          _showDatePicker(context, setState);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: textFiledBackgroundColour,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kPrimaryColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  toDate!.isNotEmpty
                                      ? '${showToDate}'
                                      : 'End Date',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Icon(Icons.date_range),

                              ],

                            ),

                          ),

                        ),

                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  )
                      : Container(),


                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: InkWell(
                      onTap: (){
                        // Action to be performed on tap
                        if(localPdfDateRangeValue==null){
                          Utils.showToast("Please Select Date Range",context);
                        }else if(fromDate!.isEmpty && localPdfDateRangeValue == "Select Date Range"){
                          Utils.showToast("Please Select From Date",context);

                        }else if(toDate!.isEmpty && localPdfDateRangeValue == "Select Date Range"){
                          Utils.showToast("Please Select To Date",context);
                        }else{

                          getLedgerRetailerStatement(
                              context, productProvider,fromDate,toDate);



                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: kPrimaryColor, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_document.svg',
                              semanticsLabel: 'document',
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Download Statement',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),

            ),
          ),
          //If it's last item, we will not add Divider after it.
          /*if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),*/
        ],
      );
    }
    return menuItems;
  }

  Future<void> getLedgerRetailerStatement(
      BuildContext context,
      DataProvider productProvider, String? fromDate, String? toDate,
      ) async {
    Utils.hideKeyBored(context);
    Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);


    print("fromDate---$fromDate");
    print("toDate---$toDate");

    await Provider.of<DataProvider>(context, listen: false)
        .getLedgerRetailerStatement(leadId!,fromDate.toString(),toDate.toString());
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getLedgerRetailerStatementData != null) {
      productProvider.getLedgerRetailerStatementData!.when(
        success: (data) {
          // Handle successful response
          var getLedgerRetailerStatementData = data;
          if (getLedgerRetailerStatementData.status!) {
            if (getLedgerRetailerStatementData.response != null) {
              if(getLedgerRetailerStatementData.response!.invoicePdfPath!=null){
                downloadPdfUrl = getLedgerRetailerStatementData.response!.invoicePdfPath!;
                startDownload();
                Navigator.of(context).pop();
              }
            }
          }else{
            if(getLedgerRetailerStatementData.message!=null){
              Utils.showToast("${getLedgerRetailerStatementData.message}",context);
            }

          }
        },
        failure: (exception) {
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            } else {
              Utils.showToast("Sever error", context);
            }
          }
        },
      );
    }
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
      await Provider.of<DataProvider>(context, listen: false)
          .getCustomerTransactionListTwo(customerTransactionListTwoReqModel);
    } else {
      Utils.onLoading(context, "");
      var customerTransactionListTwoReqModel =
          CustomerTransactionListTwoReqModel(
              leadId: leadeId, skip: skip, take: take);
      await Provider.of<DataProvider>(context, listen: false)
          .getCustomerTransactionListTwo(customerTransactionListTwoReqModel);
      Navigator.of(context, rootNavigator: true).pop();
    }
    setState(() {
      loading = true;
      loadData = true;
    });
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
  void handleDateDuration(String dateDuration) {
    DateTime now = DateTime.now();
    print("fromDate Current- $dateDuration");

    if (dateDuration == 'Current') {

      fromDate = DateFormat('MM-dd-yyyy').format(DateTime(now.year, now.month, 1)); // Current month, first day
      toDate = DateFormat('MM-dd-yyyy').format(now); // Current day

      print("fromDate Current-$fromDate");
      print("fromDate Current-$toDate");
    }
    else if (dateDuration == 'Last') {
      fromDate = DateFormat('MM-dd-yyyy').format(DateTime(now.year, now.month - 1, 1)); // Last month, first day
      toDate = DateFormat('MM-dd-yyyy').format(DateTime(now.year, now.month, 0)); // Last month, last day

      print("fromDate Last $fromDate");
      print("fromDate Last $toDate");
    }
    else if (dateDuration == 'LastThree') {
      fromDate = DateFormat('MM-dd-yyyy').format(DateTime(now.year, now.month - 3, 1)); // Three months ago, first day
      toDate = DateFormat('MM-dd-yyyy').format(DateTime(now.year, now.month, 0)); // Last month, last day
      print("fromDate LastThree $fromDate");
      print("fromDate LastThree $toDate");
    }
    else if (dateDuration == 'LastSix') {
      fromDate = DateFormat('MM-dd-yyyy').format(DateTime(now.year, now.month - 6, 1)); // Six months ago, first day
      toDate = DateFormat('MM-dd-yyyy').format(DateTime(now.year, now.month, 0));
      print("fromDate LastSix $fromDate");
      print("fromDate LastSix $toDate");// Last month, last day
    }
  }


}
