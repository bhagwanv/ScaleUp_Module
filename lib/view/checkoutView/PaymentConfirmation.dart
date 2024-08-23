import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/view/bank_details_screen/model/CreditDayAmountCals.dart';
import 'package:scale_up_module/view/bank_details_screen/model/CreditDayWiseAmounts.dart';
import 'package:scale_up_module/view/checkoutView/CongratulationScreen.dart';
import 'package:scale_up_module/view/dashboard_screen/bottom_navigation.dart';

import '../../../utils/constants.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../data_provider/DataProvider.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/loader.dart';
import '../bank_details_screen/model/TransactionDetailModel.dart';
import 'CheckOutOtpScreen.dart';
import 'model/OrderPaymentModel.dart';
import 'model/PayemtOrderPostRequestModel.dart';

class PaymentConfirmation extends StatefulWidget {
  final String transactionReqNo;
  final String customerName;
  final String imageUrl;
  final String customerCareMoblie;
  final String customerCareEmail;

  const PaymentConfirmation(
      {super.key,
      required this.transactionReqNo,
      required this.customerName,
      required this.imageUrl,
      required this.customerCareMoblie,
      required this.customerCareEmail});

  @override
  State<PaymentConfirmation> createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  var isLoading = true;
  TransactionDetailModel? transactionDetailModel = null;
  int creditDays = 0;
  OrderPaymentModel? orderPaymentModel = null;

  @override
  void initState() {
    super.initState();

    callTransaction(widget.transactionReqNo);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        debugPrint("didPop1: $didPop");
        if (didPop) {
          return;
        }
        final bool shouldPop = await Utils().onback(context);
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Consumer<DataProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.getTranscationData == null && isLoading) {
                return Center(child: Loader());
              } else {
                if (productProvider.getTranscationData != null && isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }
              }

              if (productProvider.getTranscationData != null) {
                productProvider.getTranscationData!.when(
                  success: (TransactionDetailModel) async {
                    transactionDetailModel = TransactionDetailModel;
                    if (transactionDetailModel!.status!) {
                    } else {
                      Utils.showToast(
                          transactionDetailModel!.message!, context);
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

              return SingleChildScrollView(
                child: Container(
                  color: kPrimaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(widget.imageUrl),
                                    //image: NetworkImage("https://csg10037ffe956af864.blob.core.windows.net/scaleupfiles/d1e100eb-626f-4e19-b611-e87694de6467.jpg"),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
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
                                Text(widget.customerName,
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
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          width: double.infinity,
                          height: 140.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the value to change the roundness
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, left: 10.0, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(left: 30.0),
                                        child: Image.asset(
                                            'assets/images/scale_up_logo.png')),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Total Utilised',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 11, color: gryColor),
                                        ),
                                        Text(
                                          "₹" +
                                              transactionDetailModel!
                                                  .response!.utilizateLimit!
                                                  .toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: text_green_color),
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                          'Available Credit',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 12, color: gryColor),
                                        ),
                                        Text(
                                          "₹" +
                                              transactionDetailModel!.response!
                                                  .availableCreditLimit!
                                                  .toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 15),
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
                      Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: text_light_whit_color,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 10.0),
                                    child: Center(
                                      child: Text(
                                        'Invoice Payment Confirmation',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 145,
                                    // Set the height of the horizontal list container
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 135,
                                        decoration: BoxDecoration(
                                          color: gry,
                                          borderRadius: BorderRadius.circular(
                                              10), // Adjust the value to change the roundness
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Invoice Summary',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      Text(
                                                        "₹" +
                                                            transactionDetailModel!
                                                                .response!
                                                                .anchorName!,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        "Order ID | " +
                                                            transactionDetailModel!
                                                                .response!
                                                                .orderNo!,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: gryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const SizedBox(
                                                          height: 40),
                                                      Text(
                                                        'Invoice Amount',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        "₹" +
                                                            transactionDetailModel!
                                                                .response!
                                                                .invoiceAmount
                                                                .toString(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                  ),
                                  SizedBox(height: 10),

                                  (transactionDetailModel!
                                              .response!.transactionStatus ==
                                          "Overdue")
                                      ? Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Credit Limit Blocked',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Center(
                                                  child: Text(
                                                    'Dear Customer, your credit limit is currently blocked due to non-payment of an invoice on the due date. Please settle the outstanding amount to restore your credit limit',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                SizedBox(height: 50),
                                              ],
                                            ),
                                          ),
                                        )
                                      : (transactionDetailModel!.response!
                                                  .availableCreditLimit! <
                                              transactionDetailModel!
                                                  .response!.invoiceAmount!)
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        'Insufficient Credit Limit',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Center(
                                                      child: Text(
                                                        'Your Scaleup Account has insufficient credit amount to pay for this invoice.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Center(
                                                      child: Text(
                                                        ' You may clear your outstanding dues to free your credit limit.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                    SizedBox(height: 50),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Choose Repayment Duration',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: 180,
                                                          // Set the height of the horizontal list container
                                                          child: CallDayWiseIntrestCalculateWidget(
                                                              context,
                                                              transactionDetailModel!
                                                                  .response!
                                                                  .creditDayWiseAmounts!),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              'Credit Cycle will begin after your order is delivered You will be notified via SMS and Email about repayment date.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  letterSpacing:
                                                                      0.10,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                      ]),
                                                ))
                                              ],
                                            ),
                                  transactionDetailModel!.response!.transactionStatus == "Overdue" ? Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: CommonElevatedButton(
                                            onPressed: () async {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BottomNav()),
                                              );

                                              // payemtOrderPost(context,productProvider,transactionDetailModel!);
                                            },
                                            text: "Clear Dues",
                                            upperCase: true,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: CommonElevatedButton(
                                            onPressed: () async {
                                              // payemtOrderPost(context,productProvider,transactionDetailModel!);

                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckOutOtpScreen(
                                                            transactionDetailModel:
                                                                transactionDetailModel!,
                                                            creditDays:
                                                                creditDays)),
                                              );
                                            },
                                            text: "Proceed",
                                            upperCase: true,
                                          ),
                                        ),

                                  //CallDayWiseIntrestCalculateWidget()
                                ]),
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget CallDayWiseIntrestCalculateWidget(
      BuildContext context, List<CreditDayWiseAmounts> creditDayWiseAmounts) {
    creditDays = creditDayWiseAmounts[0].days!;
    return ListView.builder(
      itemCount: creditDayWiseAmounts.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            creditDays = creditDayWiseAmounts[index].days!;
          },
          child: Card(
              borderOnForeground: true,
              elevation: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(
                      10), // Adjust the value to change the roundness
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/check_white.svg',
                                      allowDrawingOutsideViewBox: true,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      creditDayWiseAmounts[index]
                                              .days
                                              .toString() +
                                          ' Days',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    new GestureDetector(
                                      onTap: () {
                                        showPriceBreakDialog(
                                            context,
                                            creditDayWiseAmounts[index]!
                                                .creditDayAmountCals!);
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "See full breakdown ",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: Icon(Icons.info_outlined,
                                                  size: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Invoice Amount',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "₹" +
                                          creditDayWiseAmounts[index]
                                              .finalAmount!
                                              .toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Add more widgets as needed
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }

  void showPriceBreakDialog(
      BuildContext context, CreditDayAmountCals creditDayAmountCals) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Dialog Title'),
          content: Container(
            height: 180,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        'Full Breakdown',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/images/close.svg',
                            allowDrawingOutsideViewBox: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice Amount',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'interest Rate' +
                              "( @" +
                              creditDayAmountCals.annualInterestRate
                                  .toString() +
                              "% )",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Gst Amount',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          creditDayAmountCals.invoiceAmount.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          creditDayAmountCals.interestAmount.toStringAsFixed(3),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          creditDayAmountCals.gstAmount.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                SvgPicture.asset(
                  'assets/images/line.svg',
                  allowDrawingOutsideViewBox: true,
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Total Payble',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          creditDayAmountCals.totalAmount.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> callTransaction(String transactionReqNo) async {
    await Provider.of<DataProvider>(context, listen: false)
        .GetByTransactionReqNo(transactionReqNo);
  }

  void payemtOrderPost(BuildContext context, DataProvider productProvider,
      TransactionDetailModel transactionDetailModel) async {
    Utils.onLoading(context, "");
    var payemtOrderPostRequestModel = PayemtOrderPostRequestModel(
        transactionReqNo: transactionDetailModel.response!.transactionReqNo,
        amount: transactionDetailModel.response!.transactionAmount!,
        mobileNo: transactionDetailModel.response!.mobileNo!,
        loanAccountId: transactionDetailModel.response!.loanAccountId!,
        creditDay: creditDays);
    await Provider.of<DataProvider>(context, listen: false)
        .PostOrderPlacement(payemtOrderPostRequestModel);
    Navigator.of(context, rootNavigator: true).pop();

    productProvider.postPaymentOrderData!.when(
      success: (OrderPaymentModel) async {
        orderPaymentModel = OrderPaymentModel;
        if (orderPaymentModel != null) {
          if (orderPaymentModel!.status!) {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => CongratulationScreen(
                      transactionReqNo:
                          payemtOrderPostRequestModel.transactionReqNo!,
                      amount: payemtOrderPostRequestModel.amount,
                      mobileNo: payemtOrderPostRequestModel.mobileNo!,
                      loanAccountId: payemtOrderPostRequestModel.loanAccountId!,
                      creditDay: payemtOrderPostRequestModel.creditDay!)),
            );
          } else {
            Utils.showToast(orderPaymentModel!.message!, context);
          }
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
}
