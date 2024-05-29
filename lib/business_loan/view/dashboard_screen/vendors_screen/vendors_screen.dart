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

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  var isLoading = false;


  @override
  void initState() {
    super.initState();
    //Api Call
    // getCustomerTransactionList(context);
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
          if (productProvider.getLeadPANData == null && isLoading) {
             return Loader();

          } else {
            if (productProvider.getCustomerTransactionListData != null && isLoading) {
              Navigator.of(context, rootNavigator: true).pop();
              isLoading = false;
            }

           /* if (productProvider.getCustomerTransactionListData != null) {
              productProvider.getCustomerTransactionListData!.when(
                success: (PostLeadSelfieResponseModel) {
                  // Handle successful response
                  var postLeadSelfieResponseModel = PostLeadSelfieResponseModel;


                },
                failure: (exception) {
                  // Handle failure
                  print("dfjsf2");
                  //print('Failure! Error: ${exception.message}');
                },
              );
            }*/

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
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return Container(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total Balance',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 10, color: gryColor),
                            ),
                            Text(
                              '₹30,000',
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
                              style: TextStyle(fontSize: 10, color: gryColor),
                            ),
                            Text(
                              '₹3,30,000',
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
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            Text(
                              '₹15,000',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 15, color: text_orange_color),
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
        );
      },
      separatorBuilder: (BuildContext context, int index) => Padding(
        padding: EdgeInsets.only(bottom: 8.0),
      ),
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

  Future<void> getCustomerTransactionList(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);

    var  customerTransactionListRequestModel=CustomerTransactionListRequestModel(anchorCompanyID:"",leadId:"",skip:"",take:"",transactionType:"");
    Provider.of<DataProvider>(context, listen: false).getCustomerTransactionList(customerTransactionListRequestModel);
  }
}
