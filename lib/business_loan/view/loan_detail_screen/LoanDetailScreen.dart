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
import '../loan_offer_screen/loan_offer_otp_screen.dart';
import '../loan_offer_screen/model/GetOfferEmiDetailsDownloadPdfReqModel.dart';
import '../loan_offer_screen/model/GetOfferEmiDetailsResModel.dart';
import '../loan_offer_screen/model/LeadMasterByLeadIdResModel.dart';
import 'package:path/path.dart' as path;

import 'model/GetDisbursedLoanDetailResModel.dart';

class LoanDetailscreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final int sequenceNo;
  final String? pageType;

  const LoanDetailscreen(
      {super.key,
        required this.activityId,
        required this.subActivityId,
        required this.sequenceNo,
        this.pageType});

  @override
  State<LoanDetailscreen> createState() => _LoanDetailscreenState();
}

class _LoanDetailscreenState extends State<LoanDetailscreen> {
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
  List<GetDisbursedLoanDetailRows?> getDisbursedLoanDetailRowsList = [];
  late GetDisbursedLoanDetailResModel getDisbursedLoanDetailData;
  var requestId = "";
  var statusCode = "";
  double emi = 0;

  var updateData = false;
  var downloadBlemiDownloadUrl = "";

  var sanctionAmount = 0;
  double loanIntAmt = 0;
  double monthlyEMI = 0;
  double processingFeesAmt = 0;
  double netDisburAmt = 0;


  //download file
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  startDownload() async {
    fileName = path.basename(downloadBlemiDownloadUrl);
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });

    try {
      await Dio().download(downloadBlemiDownloadUrl, filePath,
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
    getDisbursedLoanDetail(context);
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
                if (productProvider.getDisbursedLoanDetailData == null &&
                    isLoading) {
                  return Center(child: Loader());
                } else {
                  if (productProvider.getDisbursedLoanDetailData != null &&
                      isLoading) {
                    Navigator.of(context, rootNavigator: true).pop();
                    isLoading = false;
                  }

                  if (!updateData) {
                    if (productProvider.getDisbursedLoanDetailData != null) {
                      productProvider.getDisbursedLoanDetailData!.when(
                        success: (data) async {
                          getDisbursedLoanDetailData = data;
                          if (getDisbursedLoanDetailData != null) {

                            if(getDisbursedLoanDetailData.sanctionAmount!=null){
                              sanctionAmount=getDisbursedLoanDetailData.sanctionAmount!;
                            }
                            if(getDisbursedLoanDetailData.loanIntAmt!=null){
                              loanIntAmt=getDisbursedLoanDetailData.loanIntAmt!;
                            }
                            if(getDisbursedLoanDetailData.monthlyEMI!=null){
                              monthlyEMI=getDisbursedLoanDetailData.monthlyEMI!;
                            }
                            if(getDisbursedLoanDetailData.processingFeesAmt!=null){
                              processingFeesAmt=getDisbursedLoanDetailData.processingFeesAmt!.toDouble();
                            }
                            if(getDisbursedLoanDetailData.netDisburAmt!=null){
                              netDisburAmt=getDisbursedLoanDetailData.netDisburAmt!.toDouble();
                            }


                            if (getDisbursedLoanDetailData.rows!.length >0) {
                              getDisbursedLoanDetailRowsList.addAll(getDisbursedLoanDetailData.rows as Iterable<GetDisbursedLoanDetailRows?>);
                                  print("list${getDisbursedLoanDetailRowsList.length}");

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


                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),
                                Center(
                                  child: Container(
                                      height: 250,
                                      width: 250,
                                      alignment: Alignment.topCenter,
                                      child: SvgPicture.asset("assets/images/congratulation.svg")),
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),

                                Center(
                                  child: Text(
                                    "Your loan senction amount",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 18,
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
                                    "₹ ${sanctionAmount.toStringAsFixed(2)}",
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
                                                  child: Text('Total Interest',
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
                                                      '₹ ${double.parse((monthlyEMI).toStringAsFixed(2))}',
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
                                                  child: Text('Processing fees',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w600,
                                                      )),
                                                ),
                                                Row(
                                                  children: [
                                                    Text('₹ ${double.parse((processingFeesAmt).toStringAsFixed(2))}',
                                                        textAlign: TextAlign.left,
                                                        style: GoogleFonts.urbanist(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w700,
                                                        )),

                                                  ],
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
                                                  child: Text('Net disbursed Amount',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w600,
                                                      )),
                                                ),
                                                Row(
                                                  children: [
                                                    Text('₹ ${double.parse((netDisburAmt).toStringAsFixed(2))}',
                                                        textAlign: TextAlign.left,
                                                        style: GoogleFonts.urbanist(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w700,
                                                        )),

                                                  ],
                                                ),
                                              ],
                                            ),

                                          ],
                                        )),
                                  ),
                                ),

                                SizedBox(
                                  height: 16.0,
                                ),
                                Text('EMI Schedule Table',
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
                                                'Total Amount',
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
                                                'EMI Amount',
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
                                                'Principal',
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
                                                'Interest',
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
                                                'OutStanding Balance',
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
                                        rows: getDisbursedLoanDetailRowsList.map((item) {
                                          String monthYear = item!.dueDate != null
                                              ? Utils.dateFormate(
                                              context, item.dueDate!, "dd/MM/yyyy")
                                              : "Not generated";

                                          String? totalAmount = (item.principalBal + item.intAmount).toStringAsFixed(2);
                                          String? emiAmount = item.emiAmount?.toStringAsFixed(2) ?? '';
                                          String? principal = item.prin?.toStringAsFixed(2) ?? '';
                                          String? interest = item.intAmount?.toStringAsFixed(2) ?? '';
                                          String? outStandingBalance = item.principalBal?.toStringAsFixed(2) ?? '';


                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(monthYear)),
                                              DataCell(Text(totalAmount!)),
                                              DataCell(Text(emiAmount!)),
                                              DataCell(Text(principal!)),
                                              DataCell(Text(interest!)),
                                              DataCell(Text(outStandingBalance!)),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 80.0,
                                ),
                              ],
                            ),
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

                                CommonElevatedButton(
                                  onPressed: () {

                                    getBLEMIDownloadPdf(
                                        context, productProvider);
                                  },
                                  text: "Download Emi Details",
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


  Future<void> getDisbursedLoanDetail(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<BusinessDataProvider>(context, listen: false)
        .getDisbursedLoanDetail(leadId!);
  }

  Future<void> getRateOfInterest(
      BuildContext context, BusinessDataProvider productProvider) async {
    Utils.hideKeyBored(context);
    //  Utils.onLoading(context, "");
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .getRateOfInterest(loanTnr.toInt());
    //Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> getBLEMIDownloadPdf(
      BuildContext context,
      BusinessDataProvider productProvider,
      ) async {
    Utils.hideKeyBored(context);
    Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);

    await Provider.of<BusinessDataProvider>(context, listen: false)
        .BLEMIDownloadPdf(leadId!);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getBlemiDownloadPdfData != null) {
      productProvider.getBlemiDownloadPdfData!.when(
        success: (data) {
          // Handle successful response
          var getBlemiDownloadPdfData = data;
          if (getBlemiDownloadPdfData.status != null) {
            if (getBlemiDownloadPdfData.response != null) {
              downloadBlemiDownloadUrl = getBlemiDownloadPdfData.response!;
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
