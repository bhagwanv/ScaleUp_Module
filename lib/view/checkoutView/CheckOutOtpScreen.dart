import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/checkoutView/model/CheckOutOtpModel.dart';
import 'package:scale_up_module/view/checkoutView/model/ValidOtpForCheckoutModel.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/Utils.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/loader.dart';
import 'PaymentConfirmation.dart';

class CheckOutOtpScreen extends StatefulWidget {
  const CheckOutOtpScreen({super.key});

  @override
  State<CheckOutOtpScreen> createState() => _CheckOutOtpScreenState();
}

class _CheckOutOtpScreenState extends State<CheckOutOtpScreen> {
  int _start = 30;
  bool isReSendDisable = true;
  var isLoading = true;
  final CountdownController _controller = CountdownController(autoStart: true);
  final TextEditingController pinController = TextEditingController();

  CheckOutOtpModel? checkOutOtpModel = null;
  ValidOtpForCheckoutModel? validOtpForCheckoutModel = null;
  String TransactionReqNo = "2024620";

  @override
  void initState() {
    super.initState();
    _start = 30;
    callGenrateOtp(TransactionReqNo);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: textFiledBackgroundColour,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPrimaryColor),
      ),
    );
    return Scaffold(
        body: SafeArea(
            top: true,
            bottom: true,
            child: Consumer<DataProvider>(builder: (context, productProvider, child) {
              if (productProvider.genrateOptPaymentData == null && isLoading) {
                return Center(child: Loader());
              } else {
                if (productProvider.genrateOptPaymentData != null &&
                    isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }

                if (productProvider.genrateOptPaymentData != null) {
                  productProvider.genrateOptPaymentData!.when(
                    success: (CheckOutOtpModel) async {
                      checkOutOtpModel = CheckOutOtpModel;
                      if (checkOutOtpModel!.status!) {


                      } else {
                        Utils.showToast(checkOutOtpModel!.message!, context);
                      }
                    },
                    failure: (exception) {
                      // Handle failure
                      print("Failure");
                      //print('Failure! Error: ${exception.message}');
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
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              checkOutOtpModel!.response!.imageUrl!=null?
                              Container(
                                width: 34,
                                height: 34,
                                decoration:  BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          checkOutOtpModel!.response!.imageUrl!),
                                      fit: BoxFit.fill),
                                ),
                              ):Container(),
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
                                  Text(checkOutOtpModel!.response!.customerName!,
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
                              GestureDetector(
                                onTap: () {
                                  customerCarePopup(context,checkOutOtpModel!);
                                }, // Image tapped
                                child:  Image.asset(
                                  'assets/images/customer.png',
                                  color: whiteColor,
                                ),
                              )
                            ],
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
                                          left: 30,
                                          top: 50,
                                          right: 30,
                                          bottom: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 69,
                                              width: 51,
                                              alignment: Alignment.topLeft,
                                              child: Image.asset(
                                                  'assets/images/scale.png')),
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          const Text(
                                            'Enter\nConfirmation Code',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 35,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Enter the One Time Confirmation code sent on your registered Scaleup mobile number',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 55,
                                          ),
                                          Center(
                                            child: Pinput(
                                              controller: pinController,
                                              length: 6,
                                              showCursor: true,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp("[0-9\]")),
                                              ],
                                              pinputAutovalidateMode:
                                                  PinputAutovalidateMode
                                                      .onSubmit,
                                              defaultPinTheme: defaultPinTheme,
                                              focusedPinTheme:
                                                  defaultPinTheme.copyWith(
                                                decoration: defaultPinTheme
                                                    .decoration!
                                                    .copyWith(
                                                  border: Border.all(
                                                      color: kPrimaryColor),
                                                ),
                                              ),
                                              onCompleted: (pin) =>
                                                  debugPrint(pin),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: isReSendDisable
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Resend Code in ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      buildCountdown(),
                                                    ],
                                                  )
                                                : Container(),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(10),
                                              child: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text:
                                                          'If you didn’t received a code!',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                      children: <TextSpan>[
                                                        isReSendDisable
                                                            ? TextSpan(
                                                                text:
                                                                    '  Resend',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                                recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () async {})
                                                            : TextSpan(
                                                                text:
                                                                    '  Resend',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                                recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap = () async {
                                                                         pinController.clear();
                                                                        isReSendDisable = true;

                                                                        reSendOtpCall(context,checkOutOtpModel!.response!.mobileNo!,productProvider);
                                                                      })
                                                      ]),
                                                ),
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CommonElevatedButton(
                                            onPressed: () async {

                                              if(pinController.text.isEmpty){
                                                Utils.showBottomSheet(
                                                    context,
                                                    "Please enter the OTP we just sent you on your mobile number",
                                                    VALIDACTION_IMAGE_PATH);
                                              }else if(pinController.text.length < 6){
                                                Utils.showBottomSheet(
                                                    context,
                                                    "Please enter the OTP we just sent you on your mobile number",
                                                    VALIDACTION_IMAGE_PATH);
                                              }else{
                                                callValidOtpApi(context,pinController.text,productProvider);
                                              }
                                            },
                                            text: "Verify Code",
                                            upperCase: true,
                                          )
                                        ],
                                      ),
                                    )
                                    //CallDayWiseIntrestCalculateWidget()
                                  ]),
                            )),
                      ],
                    ),
                  ),
                );
              }
            })));
  }

  Widget buildCountdown() {
    return Countdown(
      controller: _controller,
      seconds: _start,
      build: (_, double time) => Text(
        time.toStringAsFixed(0) + " S",
        style: TextStyle(
          fontSize: 15,
          color: Colors.blue,
          fontWeight: FontWeight.normal,
        ),
      ),
      interval: Duration(seconds: 1),
      onFinished: () {
        setState(() {
          isReSendDisable = false;
        });
      },
    );
  }

  Future<void> callGenrateOtp(String transactionReqNo) async {
    await Provider.of<DataProvider>(context, listen: false)
        .GetByTransactionReqNoForOTP(transactionReqNo);
  }

  void reSendOtpCall(BuildContext context, String mobileNo, DataProvider productProvider)async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false).reSendOtpPaymentConfromation(mobileNo,TransactionReqNo);
    Navigator.of(context, rootNavigator: true).pop();

    productProvider.reSendOptPaymentData!.when(
      success: (bool) {
        // Handle successful response
        var genrateOptResponceModel = bool;
             print(genrateOptResponceModel);
        if (genrateOptResponceModel) {
          Utils.showToast("Otp send Successfully", context);
        }
      },
      failure: (exception) {
        // Handle failure
        print('Failure! Error: ${exception}');
      },
    );


  }

  void callValidOtpApi(BuildContext context, String otptext, DataProvider productProvider)async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false).ValidateOrderOTPGetToken(checkOutOtpModel!.response!.mobileNo!,otptext,TransactionReqNo);
    Navigator.of(context, rootNavigator: true).pop();
    final prefsUtil = await SharedPref.getInstance();
    final int? leadID = prefsUtil.getInt(LEADE_ID);

    productProvider.validOptPaymentData!.when(
      success: (ValidOtpForCheckoutModel) async {
        validOtpForCheckoutModel = ValidOtpForCheckoutModel;

        if(validOtpForCheckoutModel!=null){
          if(validOtpForCheckoutModel!.status!){
            await prefsUtil.saveString(TOKEN_CHECKOUT, validOtpForCheckoutModel!.response!.token!);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PaymentConfirmation(transactionReqNo: validOtpForCheckoutModel!.response!.transactionReqNo!,customerName: checkOutOtpModel!.response!.customerName!,imageUrl: checkOutOtpModel!.response!.imageUrl!,customerCareMoblie: checkOutOtpModel!.response!.customerCareMoblie!,customerCareEmail: checkOutOtpModel!.response!.customerCareEmail!,)),
            );
          }else{
            Utils.showToast(validOtpForCheckoutModel!.message!, context);
            pinController.clear();
          }
        }
      },
      failure: (exception) {
        // Handle failure
        print('Failure! Error: ${exception}');
      },
    );


  }

  void customerCarePopup(BuildContext context, CheckOutOtpModel checkOutOtpModel)async {

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Dialog Title'),
          content: Container(
            height: 100,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        'Customer Care',
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
                          'Mobile Number',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Email Id',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          checkOutOtpModel!.response!.mobileNo!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          checkOutOtpModel!.response!.customerCareEmail!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),

                      ],
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
}
