import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/business_loan/api/ApiService.dart';
import 'package:scale_up_module/business_loan/api/FailureException.dart';
import 'package:scale_up_module/business_loan/utils/common_elevted_button.dart';
import 'package:scale_up_module/business_loan/utils/customer_sequence_logic.dart';
import 'package:scale_up_module/business_loan/utils/loader.dart';
import 'package:scale_up_module/business_loan/view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import 'package:scale_up_module/business_loan/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/business_loan/view/splash_screen/model/LeadCurrentRequestModel.dart';
import 'package:scale_up_module/business_loan/view/splash_screen/model/LeadCurrentResponseModel.dart';
import '../../../business_loan/data_provider/BusinessDataProvider.dart';
import '../../../business_loan/utils/Utils.dart';
import '../../../business_loan/utils/constants.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';

import '../../utils/directory_path.dart';
import 'loan_offer_otp_screen.dart';
import 'model/GetOfferEmiDetailsDownloadPdfReqModel.dart';
import 'model/GetOfferEmiDetailsResModel.dart';
import 'model/LeadMasterByLeadIdResModel.dart';
import 'package:path/path.dart' as path;

class LoanOfferScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final int sequenceNo;
  final String? pageType;

  const LoanOfferScreen(
      {super.key,
      required this.activityId,
      required this.subActivityId,
      required this.sequenceNo,
      this.pageType});

  @override
  State<LoanOfferScreen> createState() => _LoanOfferScreenState();
}

class _LoanOfferScreenState extends State<LoanOfferScreen> {
  var isLoading = true;
  late List<String> listData;
  var nameOnCard = "";
  List<bool> isSelected = [false, true];
  double updatedLoanTnr = 0;
  var companyIdentificationCode = "";
  double loanAmt = 0;
  var interestRt = 0;
  double loanTnr = 0;
  var loanTnrType = "";
  double orignalLoanAmt = 0.0;
  var name = "";
  var nbfcCompanyId = 0;
  var inititalEmiApiCall = true;
  List<GetOfferEmiDetailList?> getOfferEmiDetailList = [];
  late LeadMasterByLeadIdResModel getLeadMasterByLeadIdData;
  var requestId = "";
  var statusCode = "";
  double emi = 0;
  double loanIntAmt = 0;
  var updateData = false;
  var downloadRepaymentUrl = "";

  //download file
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  startDownload() async {
    fileName = path.basename(downloadRepaymentUrl);
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });

    try {
      await Dio().download(downloadRepaymentUrl, filePath,
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

  @override
  void initState() {
    super.initState();
    // Initialize the list with dummy data
    getLeadMasterByLeadId(context);
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
        if (widget.pageType == "pushReplacement") {
          final bool shouldPop = await Utils().onback(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Consumer<BusinessDataProvider>(
              builder: (context, productProvider, child) {
            if (productProvider.getLeadMasterByLeadIdData == null &&
                isLoading) {
              return Center(child: Loader());
            } else {
              if (productProvider.getLeadMasterByLeadIdData != null &&
                  isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }

              if (!updateData) {
                if (productProvider.getLeadMasterByLeadIdData != null) {
                  productProvider.getLeadMasterByLeadIdData!.when(
                    success: (data) async {
                      getLeadMasterByLeadIdData = data;
                      if (getLeadMasterByLeadIdData.status != null) {
                        if (getLeadMasterByLeadIdData
                                .companyIdentificationCode !=
                            null) {
                          companyIdentificationCode = getLeadMasterByLeadIdData
                              .companyIdentificationCode!;
                        }

                        if (getLeadMasterByLeadIdData.nbfcCompanyId != null) {
                          nbfcCompanyId =
                              getLeadMasterByLeadIdData.nbfcCompanyId!;
                        }
                        if (getLeadMasterByLeadIdData.nbfcCompanyId != null) {
                          nbfcCompanyId =
                              getLeadMasterByLeadIdData.nbfcCompanyId!;
                        }

                        if (getLeadMasterByLeadIdData.arthMateOffer != null) {
                          loanAmt = getLeadMasterByLeadIdData
                              .arthMateOffer!.loanAmt!
                              .toDouble();
                          interestRt = getLeadMasterByLeadIdData
                              .arthMateOffer!.interestRt!;
                          loanTnr = getLeadMasterByLeadIdData
                              .arthMateOffer!.loanTnr!
                              .toDouble();
                          updatedLoanTnr = getLeadMasterByLeadIdData
                              .arthMateOffer!.loanTnr!
                              .toDouble();
                          loanTnrType = getLeadMasterByLeadIdData
                              .arthMateOffer!.loanTnrType!;
                          orignalLoanAmt = double.parse(
                              (getLeadMasterByLeadIdData
                                      .arthMateOffer!.orignalLoanAmt!)
                                  .toStringAsFixed(2));

                          name = getLeadMasterByLeadIdData.arthMateOffer!.name!;

                          calcEMI(interestRt, loanTnr.toInt(), loanAmt.toInt());
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
                  updateData = true;
                }
              }

              if (productProvider.getGetOfferEmiDetailsData != null) {
                productProvider.getGetOfferEmiDetailsData!.when(
                  success: (data) {
                    // Handle successful response
                    var getGetOfferEmiDetailsData = data;
                    if (getGetOfferEmiDetailsData.result != null) {
                      getOfferEmiDetailList.clear();
                      getOfferEmiDetailList.addAll(getGetOfferEmiDetailsData
                          .result as Iterable<GetOfferEmiDetailList?>);

                      print("list${getOfferEmiDetailList.length}");
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

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: Text(
                              "loan Offer",
                              style: GoogleFonts.urbanist(
                                fontSize: 30,
                                color: blackSmall,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Center(
                            child: Text(
                              "Congratulations $name",
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Center(
                            child: Text(
                              "You are qualified for credit limit of",
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Center(
                            child: Text(
                              "₹ $loanAmt",
                              style: GoogleFonts.urbanist(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            color: Colors.white,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the value to change the roundness
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text('Total Loan Amount',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                          Flexible(
                                            child: Text('₹ $orignalLoanAmt',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Center(
                                        child: Container(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            LinearProgressIndicator(
                                              backgroundColor: light_gray,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<Color>(
                                                      kPrimaryColor),
                                              value: 1.0,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/ic_scale_view.svg',
                                              semanticsLabel: 'document',
                                              width:
                                                  MediaQuery.of(context).size.width,
                                            ),
                                          ],
                                        )),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text('Interest Rate',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                          Flexible(
                                            child: Text('$interestRt %',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Center(
                                        child: Container(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            LinearProgressIndicator(
                                              backgroundColor: light_gray,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<Color>(
                                                      kPrimaryColor),
                                              value: (interestRt * 1) / 50,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/ic_scale_view.svg',
                                              semanticsLabel: 'document',
                                              width:
                                                  MediaQuery.of(context).size.width,
                                            ),
                                          ],
                                        )),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text('Loan Tenure (${updatedLoanTnr.toInt()>0?updatedLoanTnr.toInt():1} Month)',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                          Row(
                                            children: [
                                              Text('${loanTnr.toInt()}',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('${loanTnrType}',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  )),

                                              /*  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isToggled = !_isToggled;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 70,
                                                      // Increased width to accommodate text
                                                      height: 25,
                                                      // Adjust height for better appearance
                                                      decoration: BoxDecoration(
                                                        color: togel_color,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                        border: Border.all(
                                                          color: kPrimaryColor,
                                                          // Outline border color
                                                          width:
                                                          1.0, // Outline border width
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          AnimatedPositioned(
                                                            duration: Duration(
                                                                milliseconds: 200),
                                                            curve: Curves.easeIn,
                                                            left:
                                                            _isToggled ? 35 : 0,
                                                            // Adjusted position for the text
                                                            right:
                                                            _isToggled ? 0 : 35,
                                                            child: Container(
                                                              width: 35,
                                                              // Adjusted width for the thumb
                                                              height: 23,
                                                              // Adjusted height for the thumb
                                                              decoration:
                                                              BoxDecoration(
                                                                color: _isToggled
                                                                    ? kPrimaryColor
                                                                    : kPrimaryColor,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    4),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  _isToggled
                                                                      ? 'Mo'
                                                                      : 'Yr',
                                                                  style: GoogleFonts.urbanist(
                                                                    fontSize: 14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: _isToggled
                                                                ? Alignment
                                                                .centerLeft
                                                                : Alignment
                                                                .centerRight,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  10.0),
                                                              child: Text(
                                                                _isToggled
                                                                    ? 'Yr'
                                                                    : 'Mo',
                                                                style: GoogleFonts.urbanist(
                                                                  fontSize: 14,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )*/
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: double.infinity,
                                        // Ensures the slider takes full width of its parent
                                        child: Column(
                                          children: [
                                            Theme(
                                              data: Theme.of(context).copyWith(
                                                sliderTheme: SliderThemeData(
                                                  thumbShape:
                                                      SquareSliderComponentShape(),
                                                  trackShape:
                                                      MyRoundedRectSliderTrackShape(),
                                                ),
                                              ),
                                              child: Slider(
                                                onChanged: (value) => setState(() {
                                                  updatedLoanTnr = (value /
                                                      loanTnr *
                                                      loanTnr); // Round to nearest integer
                                                  print("newValue: $updatedLoanTnr");
                                                }),
                                                value: updatedLoanTnr,
                                                divisions: loanTnr != 0
                                                    ? loanTnr.toInt()
                                                    : 1,
                                                // Set divisions to represent each month
                                                min: 0,
                                                max: loanTnr.toDouble(),
                                                // Set max to 36 months
                                                activeColor: kPrimaryColor,
                                                inactiveColor: light_gray,
                                                onChangeEnd: (value) {
                                                  updatedLoanTnr = value;
                                                  print(
                                                      "newValue on ened: $updatedLoanTnr");

                                                  if (updatedLoanTnr.toInt() > 0) {
                                                    calcEMI(
                                                        interestRt,
                                                        updatedLoanTnr.toInt(),
                                                        loanAmt.toInt());
                                                  } else {
                                                    calcEMI(interestRt, 1,
                                                        loanAmt.toInt());
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: SvgPicture.asset(
                                                'assets/images/ic_scale_view.svg',
                                                semanticsLabel: 'document',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ),
                                            // Display the current value as a text
                                            /* Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Text(
                                                'Selected value: $updatedLoanTnr',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),*/
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            color: Colors.white,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the value to change the roundness
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text('Monthly EMI:',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                          Flexible(
                                            child: Text(
                                                '₹ ${double.parse((emi).toStringAsFixed(2))}',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text('loan Interest Amt:',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                          Flexible(
                                            child: Text(
                                                '₹ ${double.parse((loanIntAmt).toStringAsFixed(2))}',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text('Sanctioned Amt:',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                          Row(
                                            children: [
                                              Text('₹ $orignalLoanAmt',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  )),

                                              /*  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isToggled = !_isToggled;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 70,
                                                      // Increased width to accommodate text
                                                      height: 25,
                                                      // Adjust height for better appearance
                                                      decoration: BoxDecoration(
                                                        color: togel_color,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                        border: Border.all(
                                                          color: kPrimaryColor,
                                                          // Outline border color
                                                          width:
                                                          1.0, // Outline border width
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          AnimatedPositioned(
                                                            duration: Duration(
                                                                milliseconds: 200),
                                                            curve: Curves.easeIn,
                                                            left:
                                                            _isToggled ? 35 : 0,
                                                            // Adjusted position for the text
                                                            right:
                                                            _isToggled ? 0 : 35,
                                                            child: Container(
                                                              width: 35,
                                                              // Adjusted width for the thumb
                                                              height: 23,
                                                              // Adjusted height for the thumb
                                                              decoration:
                                                              BoxDecoration(
                                                                color: _isToggled
                                                                    ? kPrimaryColor
                                                                    : kPrimaryColor,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    4),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  _isToggled
                                                                      ? 'Mo'
                                                                      : 'Yr',
                                                                  style: GoogleFonts.urbanist(
                                                                    fontSize: 14,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: _isToggled
                                                                ? Alignment
                                                                .centerLeft
                                                                : Alignment
                                                                .centerRight,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  10.0),
                                                              child: Text(
                                                                _isToggled
                                                                    ? 'Yr'
                                                                    : 'Mo',
                                                                style: GoogleFonts.urbanist(
                                                                  fontSize: 14,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )*/
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          ),

                          /*  Center(
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
                                  child: Text('View EMI',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12,
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              ),*/

                          SizedBox(
                            height: 16.0,
                          ),
                          Text('Loan Repayment Schedule  ',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  border: TableBorder.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Flexible(
                                        child: Text(
                                          'Month/Year',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Flexible(
                                        child: Text(
                                          'Outstanding Amount',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Flexible(
                                        child: Text(
                                          'Principal Amount',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Flexible(
                                        child: Text(
                                          'Interest Amount',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Flexible(
                                        child: Text(
                                          'Loan Paid',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: getOfferEmiDetailList.map((item) {
                                    String monthYear = item!.dueDate != null
                                        ? Utils.dateFormate(
                                            context, item.dueDate!, "dd/MM/yyyy")
                                        : "Not generated";

                                    String outStandingAmount =
                                        item.outStandingAmount.toString() ?? '';
                                    String? interestAmount =
                                        item.interestAmount.toString();
                                    String emiAmount =
                                        item.emiAmount.toString() ?? '';
                                    String principalAmount =
                                        item.principalAmount.toString() ?? '';
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(monthYear)),
                                        DataCell(Text(outStandingAmount)),
                                        DataCell(Text(principalAmount)),
                                        DataCell(Text(interestAmount)),
                                        DataCell(Text(emiAmount)),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 132.0,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16.0,
                            ),
                            InkWell(
                              onTap: () {
                                // Action to be performed on tap
                                getOfferEmiDetailsDownloadPdf(
                                    context, productProvider);
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
                                      'Download repayment schedule',
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
                            SizedBox(
                              height: 16.0,
                            ),
                            CommonElevatedButton(
                              onPressed: () {

                                if (companyIdentificationCode == "ArthMate") {
                                   arthMateGenerateAadhaarOTPAPI(
                                      context, productProvider);
                                } else {
                                   getGenerateKarzaAadhaarOtpForNBFC(
                                      context, productProvider);
                                }
                              },
                              text: "Proceed to sign agreement",
                              upperCase: true,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
    ;
  }

  Widget _myListView(BuildContext context,
      List<GetOfferEmiDetailList?> getOfferEmiDetailListData) {
    if (getOfferEmiDetailListData.isEmpty) {
      // Return a widget indicating that the list is empty or null
      return Center(
        child: Text('No data available'),
      );
    }

    return ListView.builder(
      itemCount: getOfferEmiDetailListData.length,
      itemBuilder: (context, index) {
        if (index < getOfferEmiDetailListData.length) {
          GetOfferEmiDetailList offerEmiDetailList =
              getOfferEmiDetailList[index]!;

          // Null check for each property before accessing it
          // Default value if anchorName is null
          String monthYear = offerEmiDetailList.dueDate != null
              ? Utils.dateFormate(
                  context, offerEmiDetailList.dueDate!, "dd/MM/yyyy")
              : "Not generated";

          String outStandingAmount =
              offerEmiDetailList.outStandingAmount.toString() ?? '';
          String? interestAmount = offerEmiDetailList.interestAmount.toString();
          String emiAmount = offerEmiDetailList.emiAmount.toString() ?? '';
          String principalAmount =
              offerEmiDetailList.principalAmount.toString() ?? '';

          return Table(
            border: TableBorder.all(
              color: tabel_border_color,
              width: 1,
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(),
                // Use BoxDecoration for table row decoration
                children: [
                  TableCell(
                    child: Container(
                      height: 40, // Ensure height is consistent across cells
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                          child: Text('$monthYear',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 8,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ))),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: tabel_cell_color,
                      ),
                      child: Center(
                          child: Text('₹ $outStandingAmount',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 8,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ))),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                          child: Text('₹ $principalAmount',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 8,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ))),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: tabel_cell_color,
                      ),
                      child: Center(
                          child: Text('₹ $interestAmount',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 8,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ))),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                          child: Text('₹ $emiAmount',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 8,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ))),
                    ),
                  ),
                  /*   TableCell(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: tabel_cell_color,
                      ),
                      child: Center(
                          child: Text('0.61%',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 8,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ))),
                    ),
                  ),*/
                ],
              ),
            ],
          );
          ;
        }
      },
    );
  }

  Future<void> getLeadMasterByLeadId(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<BusinessDataProvider>(context, listen: false)
        .getLeadMasterByLeadId(leadId!);
  }

  Future<void> getRateOfInterest(
      BuildContext context, BusinessDataProvider productProvider) async {
    Utils.hideKeyBored(context);
    //  Utils.onLoading(context, "");
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .getRateOfInterest(loanTnr.toInt());
    //Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> getOfferEmiDetailsDownloadPdf(
    BuildContext context,
    BusinessDataProvider productProvider,
  ) async {
    Utils.hideKeyBored(context);
     Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    var model =
        GetOfferEmiDetailsDownloadPdfReqModel(leadId: leadId, reqTenure: updatedLoanTnr.toInt());
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .getOfferEmiDetailsDownloadPdf(model);
     Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getGetOfferEmiDetailsDownloadData != null) {
      productProvider.getGetOfferEmiDetailsDownloadData!.when(
        success: (data) {
          // Handle successful response
          var getGetOfferEmiDetailsDownload = data;
          if (getGetOfferEmiDetailsDownload.status != null) {
            if (getGetOfferEmiDetailsDownload.response != null) {
              downloadRepaymentUrl = getGetOfferEmiDetailsDownload.response!;
              startDownload();
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

  Future<void> getOfferEmiDetails(
    BuildContext context,
    int totalNumberOfMonths,
  ) async {
    Utils.hideKeyBored(context);
    //Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);

    await Provider.of<BusinessDataProvider>(context, listen: false)
        .getOfferEmiDetails(leadId!, totalNumberOfMonths);
    // Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> arthMateGenerateAadhaarOTPAPI(
      BuildContext context, BusinessDataProvider productProvider) async {
    Utils.onLoading(context, "");
    var request = AadhaarGenerateOTPRequestModel(otp: "", requestId: "");
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .leadAadharGenerateOTP(request);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getaadhaarOtpGenerateData != null) {
      productProvider.getaadhaarOtpGenerateData!.when(
        success: (data) async {
          var getaadhaarOtpGenerateData = data;
          if (getaadhaarOtpGenerateData != null) {
            if (getaadhaarOtpGenerateData.msg != null) {
              Utils.showToast(" ${getaadhaarOtpGenerateData.msg}", context);
            }

            //widget.requestId = leadAadhaarResponse.requestId!;
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

  Future<void> getGenerateKarzaAadhaarOtpForNBFC(
      BuildContext context, BusinessDataProvider productProvider) async {
    Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
   await Provider.of<BusinessDataProvider>(context, listen: false)
        .generateKarzaAadhaarOtpForNBFC(leadId!);
    Navigator.of(context, rootNavigator: true).pop();

    if(productProvider.getGenerateKarzaAadhaarOtpForNBFCData!=null){
      productProvider.getGenerateKarzaAadhaarOtpForNBFCData!.when(
        success: (data) async {
          var generateKarzaAadhaarOtpForNBFC = data;
          if (generateKarzaAadhaarOtpForNBFC != null) {
            if (generateKarzaAadhaarOtpForNBFC.status != null) {
              if(generateKarzaAadhaarOtpForNBFC.status!){
                requestId = generateKarzaAadhaarOtpForNBFC.data!.requestId.toString();
                statusCode = generateKarzaAadhaarOtpForNBFC.data!.statusCode.toString();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => LoanOfferOtpScreen(
                        activityId: widget.activityId,
                        subActivityId: widget.activityId,
                        companyIdentificationCode: companyIdentificationCode,
                        leadMasterByLeadId: getLeadMasterByLeadIdData,
                        generateKarzaAadhaarOtpForNbfcResModel:generateKarzaAadhaarOtpForNBFC,
                        updatedLoanTnr:updatedLoanTnr.toInt(),)),
                );
              }
            }
          }
        },
        failure: (exception) {
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            } else {
              if(exception.errorMessage.isNotEmpty){
                Utils.showToast(exception.errorMessage, context);
              }else{
                Utils.showToast("Server error", context);
              }

            }
          }
        },
      );
    }

  }

  void calcEMI(
      int yearlyInterestRate, int totalNumberOfMonths, int loanAmount) {
    // Calculate monthly EMI
    if (yearlyInterestRate > 0) {
      var rate = yearlyInterestRate / 100 / 12;
      var denominator = pow((1 + rate), totalNumberOfMonths) - 1;
      emi = (rate + (rate / denominator)) * loanAmount;
    } else {
      emi = totalNumberOfMonths > 0 ? loanAmount / totalNumberOfMonths : 0;
    }

    // Calculate loan interest amount
    loanIntAmt = (emi * totalNumberOfMonths) - loanAmount;

    // Print or use the results as needed
    print('Monthly EMI: $emi');
    print('Total Interest Amount: $loanIntAmt');
    getOfferEmiDetails(context, totalNumberOfMonths);
  }
}

class RectSliderThumbShape extends SliderComponentShape {
  const RectSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 4.0,
  });

  final double enabledThumbRadius;
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;
  final double elevation;
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor!,
      end: sliderTheme.thumbColor!,
    );

    final Color color = colorTween.evaluate(enableAnimation)!;
    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);

    // Calculate the size of the rectangular thumb
    final double thumbWidth = 0.7 * radius;
    final double thumbHeight = 2 * radius; // Adjust height as needed

    // Draw rectangular thumb
    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: thumbWidth,
      height: thumbHeight,
    );

    bool paintShadows = true;
    assert(() {
      if (debugDisableShadows) {
        paintShadows = false;
      }
      return true;
    }());

    if (paintShadows) {
      canvas.drawShadow(
        Path()..addRect(thumbRect),
        Colors.black,
        evaluatedElevation,
        true,
      );
    }

    canvas.drawRect(
      thumbRect,
      Paint()..color = color,
    );
  }
}

class SquareSliderComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(20, 30);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    canvas.drawShadow(
        Path()
          ..addRRect(RRect.fromRectAndRadius(
            Rect.fromCenter(center: center, width: 10, height: 30),
            const Radius.circular(4),
          )),
        Colors.black,
        5,
        false);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 10, height: 30),
        const Radius.circular(4),
      ),
      Paint()..color = kPrimaryColor,
    );
  }
}

class MyRoundedRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const MyRoundedRectSliderTrackShape();

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset thumbCenter,
      Offset? secondaryOffset,
      bool isEnabled = false,
      bool isDiscrete = false,
      required TextDirection textDirection,
      double additionalTrackHeight = 1}) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius activeTrackRadius =
        Radius.circular((trackRect.height + additionalTrackHeight) / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top - (additionalTrackHeight / 2),
        thumbCenter.dx,
        trackRect.bottom + (additionalTrackHeight / 2),
        topLeft: activeTrackRadius,
        bottomLeft: activeTrackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        trackRect.top - (additionalTrackHeight / 2),
        trackRect.right,
        trackRect.bottom + (additionalTrackHeight / 2),
        topRight: activeTrackRadius,
        bottomRight: activeTrackRadius,
      ),
      rightTrackPaint,
    );
  }
}

class TileList extends StatefulWidget {
  TileList({super.key, required this.fileUrl});

  final String fileUrl;

  @override
  State<TileList> createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  startDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });

    try {
      await Dio().download(widget.fileUrl, filePath,
          onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken);
      setState(() {
        dowloading = false;
        fileExists = true;
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

  checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  openfile() {
    OpenFile.open(filePath);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileName = path.basename(widget.fileUrl);
    });
    checkFileExit();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryColor,
        // text color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        fileExists && dowloading == false
            ? openfile()
            : widget.fileUrl.isNotEmpty
                ? startDownload()
                : Utils.showBottomToast("Document not found!!");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            fileExists
                ? const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.white,
                  )
                : dowloading
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 3,
                            backgroundColor: Colors.grey,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue),
                          ),
                          Text(
                            "${(progress * 100).toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      )
                    : const Icon(Icons.download),
            SizedBox(
              width: 12.0,
            ),
            fileExists
                ? Text(
                    'Open repayment schedule',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    'Download repayment schedule',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
