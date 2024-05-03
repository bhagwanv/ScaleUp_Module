
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/Utils.dart';

import '../../../data_provider/DataProvider.dart';
import '../../../shared_preferences/SharedPref.dart';
import '../../../utils/constants.dart';
import '../../../utils/loader.dart';
import '../model/CustomerTransactionListRequestModel.dart';
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

  @override
  void initState() {
    super.initState();
    //Api Call
    getCustomerTransactionListTwo(context);
  }

  @override
  Widget build(BuildContext context) {
    List<CustomerTransactionListTwoRespModel>? customerTransactionList;
    return Scaffold(
      backgroundColor: dashboard_bg_color_light_blue,
      body: SafeArea(
        top: true,
        bottom: true,
        child:
            Consumer<DataProvider>(builder: (context, productProvider, child) {

          if (productProvider.getCustomerTransactionListTwoData == null && isLoading) {
            Future.delayed(Duration(seconds: 1), () {
              setState(() {

              });
              print("sdfjaskfd1");
            });
            return Loader();

          } else {
            if (productProvider.getCustomerTransactionListTwoData != null && isLoading) {
             Navigator.of(context, rootNavigator: true).pop();
              isLoading = false;
              print("sdfjaskfd1");
            }
            print("sdfjaskfd1$isLoading");
            if (productProvider.getCustomerTransactionListTwoData != null)  {
              productProvider.getCustomerTransactionListTwoData!.when(
                success: (data){
                  // Handle successful response
                  customerTransactionList = data;
                  

                },
                failure: (exception) {
                  // Handle failure
                  print("dfjsf2");
                  //print('Failure! Error: ${exception.message}');
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
                                  color: Color.fromRGBO(30, 30, 30, 1),
                                  fontSize: 10,
                                  letterSpacing: 0.20000000298023224,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5)),
                          Text(customerName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(30, 30, 30, 1),
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
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
                Expanded(child: customerTransactionList != null ? _myListView(context,customerTransactionList!): Container())
              ]),
            );
          }
        }),
      ),
    );
  }

  Widget _myListView(BuildContext context, List<CustomerTransactionListTwoRespModel> customerTransactionList) {
    if (customerTransactionList == null || customerTransactionList!.isEmpty) {
      // Return a widget indicating that the list is empty or null
      return Center(
        child: Text('No transactions available'),
      );
    }

    ListView listView = ListView.separated(
      itemCount: customerTransactionList!.length,
      itemBuilder: (BuildContext context, int index) {
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
              /*boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],*/

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
        );
      },
      separatorBuilder: (BuildContext context, int index) => Container(),
    );
    Container listViewContainer = Container(
      height: double.infinity,
      child: listView,
    );
    return SizedBox(
        child: Column(
      children: <Widget>[
        Flexible(
          child: listViewContainer,
          flex: 1,
        ),
      ],
    ));
  }


  Future<void> getCustomerTransactionListTwo(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
     customerName = prefsUtil.getString(CUSTOMERNAME)!;

   var  customerTransactionListTwoReqModel=CustomerTransactionListTwoReqModel(leadId:257,skip:0,take:5);
   Provider.of<DataProvider>(context, listen: false).getCustomerTransactionListTwo(customerTransactionListTwoReqModel);
  }
}