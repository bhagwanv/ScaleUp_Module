
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
  var isLoading = false;
  late CustomerTransactionListTwoRespModel? customerTransactionListTwoRespModel = null;
  @override
  void initState() {
    super.initState();
    //Api Call
    getCustomerTransactionListTwo(context);
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

          if (productProvider.getCustomerTransactionListTwoData == null && isLoading) {
             return Loader();

          } else {
            if (productProvider.getCustomerTransactionListTwoData != null && isLoading) {
              Navigator.of(context, rootNavigator: true).pop();
              isLoading = false;
            }

            if (productProvider.getCustomerTransactionListTwoData != null) {
              productProvider.getCustomerTransactionListTwoData!.when(
                success: (CustomerTransactionListTwoRespModel) {
                  // Handle successful response
                  customerTransactionListTwoRespModel = CustomerTransactionListTwoRespModel;

                 // anchorName=customerTransactionListTwoRespModel!.anchorName


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
                      const Column(
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
                          Text('Hello Vaibhav',
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
                Expanded(child: _myListView(context))
              ]),
            );
          }
        }),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    ListView listView = ListView.separated(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
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
                              "Shopkirana PVT. LTD.",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              "12/04  | 05:35 PM",
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
                              "Order ID 45215",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "₹5,000.0",
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
    final String? userId = prefsUtil.getString(USER_ID);

   var  customerTransactionListTwoReqModel=CustomerTransactionListTwoReqModel(leadId:257,skip:0,take:5);
    Provider.of<DataProvider>(context, listen: false).getCustomerTransactionListTwo(customerTransactionListTwoReqModel);
  }
}
