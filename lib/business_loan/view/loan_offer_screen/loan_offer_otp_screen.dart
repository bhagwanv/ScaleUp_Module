import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/business_loan/utils/loader.dart';
import 'package:scale_up_module/business_loan/view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import 'package:scale_up_module/business_loan/view/aadhaar_screen/models/ValidateAadhaarOTPRequestModel.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../data_provider/BusinessDataProvider.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import '../../utils/Utils.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/kyc_faild_widgets.dart';
import '../login_screen/login_screen.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/AadhaarOtpVerifyReqModel.dart';
import 'model/AcceptOfferByLeadReqModel.dart';
import 'model/GenerateKarzaAadhaarOtpForNBFCResModel.dart';
import 'model/KarzaAadhaarOtpVerifyForNBFCReqModel.dart';
import 'model/LeadMasterByLeadIdResModel.dart';
import 'model/ProductSlabConfigResponse.dart';

class LoanOfferOtpScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  // final AadhaarGenerateOTPRequestModel? document;
  String companyIdentificationCode;
  LeadMasterByLeadIdResModel leadMasterByLeadId;
  GenerateKarzaAadhaarOtpForNbfcResModel generateKarzaAadhaarOtpForNbfcResModel;
  int updatedLoanTnr;

  LoanOfferOtpScreen({
    super.key,
    required this.activityId,
    required this.subActivityId,
    // required this.document,
    required this.companyIdentificationCode,
    required this.leadMasterByLeadId,
    required this.generateKarzaAadhaarOtpForNbfcResModel,
    required this.updatedLoanTnr,
  });

  @override
  State<LoanOfferOtpScreen> createState() => _LoanOfferOtpScreenState();
}

class _LoanOfferOtpScreenState extends State<LoanOfferOtpScreen> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: GoogleFonts.urbanist(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    ),
    decoration: BoxDecoration(
      color: textFiledBackgroundColour,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: kPrimaryColor),
    ),
  );
  int _start = 60;
  final CountdownController _controller = CountdownController(autoStart: true);
  bool isReSendDisable = true;
  var requestId = "";
  var statusCode = "";
  var loanAmt = 0;
  var nbfcCompanyId = 0;

  Widget buildCountdown() {
    print("_start $_start");
    return Countdown(
      controller: _controller,
      seconds: _start,
      build: (_, double time) => Text(
        time.toStringAsFixed(0) + " S",
        style: GoogleFonts.urbanist(
          fontSize: 15,
          color: Colors.blue,
          fontWeight: FontWeight.w400,
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

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    if (widget.generateKarzaAadhaarOtpForNbfcResModel.data!.requestId != null) {
      requestId =
          widget.generateKarzaAadhaarOtpForNbfcResModel!.data!.requestId!;
    }
    if (widget.leadMasterByLeadId.arthMateOffer!.loanAmt != null) {
      loanAmt = widget.leadMasterByLeadId.arthMateOffer!.loanAmt!;
    }
    if (widget.leadMasterByLeadId.nbfcCompanyId != null) {
      nbfcCompanyId = widget.leadMasterByLeadId.nbfcCompanyId!;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<BusinessDataProvider>(
            builder: (context, productProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 50, right: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 69,
                      width: 51,
                      alignment: Alignment.topLeft,
                      child: Image.asset('assets/images/scale.png')),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Enter \nVerification Code',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.urbanist(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Enter the verification code sent on Aadhaar registered mobile number',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  Center(
                    child: Pinput(
                      length: 6,
                      controller: pinController,
                      showCursor: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9\]")),
                      ],
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: kPrimaryColor),
                        ),
                      ),
                      onCompleted: (pin) => debugPrint(pin),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  isReSendDisable
                      ? SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Resend Code in ',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              buildCountdown(),
                            ],
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'If you didn’t received a code!',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              children: <TextSpan>[
                                isReSendDisable
                                    ? TextSpan(
                                        text: '  Resend',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {})
                                    : TextSpan(
                                        text: '  Resend',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            isReSendDisable = true;
                                            if (widget
                                                    .companyIdentificationCode ==
                                                "ArthMate") {
                                              arthMateGenerateAadhaarOTPAPI(
                                                  context, productProvider);
                                            } else {
                                              getGenerateKarzaAadhaarOtpForNBFC(
                                                  context, productProvider);
                                            }
                                          })
                              ]),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonElevatedButton(
                    onPressed: () {
                      if (widget.companyIdentificationCode == "ArthMate") {
                        arthMateValidateAadhaarOtpVerify(
                            context, pinController.text, productProvider);
                      } else {
                        /*nbfcValidateAcceptOfferByLead(
                                context, pinController.text, productProvider);*/
                        validateKarzaAadhaarOtpVerifyForNBFC(
                            context, pinController.text, productProvider);
                      }
                    },
                    text: "Verify Code",
                    upperCase: true,
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> arthMateGenerateAadhaarOTPAPI(
      BuildContext context, BusinessDataProvider productProvider) async {
    var request = AadhaarGenerateOTPRequestModel(otp: "", requestId: "");
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .leadAadharGenerateOTP(request);

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
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<BusinessDataProvider>(context, listen: false)
        .generateKarzaAadhaarOtpForNBFC(leadId!);

    if (productProvider.getGenerateKarzaAadhaarOtpForNBFCData != null) {
      productProvider.getGenerateKarzaAadhaarOtpForNBFCData!.when(
        success: (data) async {
          var generateKarzaAadhaarOtpForNBFC = data;
          if (generateKarzaAadhaarOtpForNBFC != null) {
            if (generateKarzaAadhaarOtpForNBFC.status != null) {
              //  Utils.showToast(" ${generateKarzaAadhaarOtpForNBFC.data!.result!.message}", context);
              requestId = requestId;
              statusCode =
                  generateKarzaAadhaarOtpForNBFC.data!.statusCode.toString();
              print("dskjfhskafhd");
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

  void arthMateValidateAadhaarOtpVerify(
    BuildContext context,
    String otpText,
    BusinessDataProvider productProvider,
  ) async {
    if (otpText.isEmpty) {
      Utils.showToast("Please Enter OTP", context);
    } else if (otpText.length < 6) {
      Utils.showToast("PLease Enter Valid Otp", context);
    } else {
      final prefsUtil = await SharedPref.getInstance();

      var req = AadhaarOtpVerifyReqModel(
          leadMasterId: prefsUtil.getInt(LEADE_ID),
          requestId: requestId,
          otp: int.parse(otpText),
          loanAmt: loanAmt,
          insuranceApplied: true);

      //Utils.onLoading(context, "");
      await Provider.of<BusinessDataProvider>(context, listen: false)
          .aadhaarOtpVerify(req);
      //Navigator.of(context, rootNavigator: true).pop();

      if (productProvider.getAadhaarOtpVerifyData != null) {
        productProvider.getAadhaarOtpVerifyData!.when(
          success: (data) async {
            var getAadhaarOtpVerifyData = data;
            if (getAadhaarOtpVerifyData != null) {
              if (getAadhaarOtpVerifyData.status != null) {
                if (getAadhaarOtpVerifyData.status!) {
                  acceptOffer(context,productProvider);
                } else {
                  Utils.showToast(getAadhaarOtpVerifyData.message.toString(), context);
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
                Utils.showToast(exception.errorMessage, context);
              }
            }
          },
        );
      }
    }
  }

  void nbfcValidateAcceptOfferByLead(
    BuildContext context,
    BusinessDataProvider productProvider, String otpText,
  ) async {
    List<ProductSlabConfigResponse> productSlabConfigResponse = [];
    final prefsUtil = await SharedPref.getInstance();
    var req = AcceptOfferByLeadReqModel(
        leadId: prefsUtil.getInt(LEADE_ID),
        userId: prefsUtil.getString(USER_ID),
        tenure: widget.updatedLoanTnr,
        amount: loanAmt,
        otp: otpText,
        requestId: requestId,
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        nbfcCompanyId: nbfcCompanyId,
        productSlabConfigResponse: productSlabConfigResponse);

    Utils.onLoading(context, "");
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .acceptOfferByLead(req);
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getAcceptOfferByLeadData != null) {
      productProvider.getAcceptOfferByLeadData!.when(
        success: (data) async {
          var getAcceptOfferByLeadData = data;
          if (getAcceptOfferByLeadData.status != null) {
            if (getAcceptOfferByLeadData.status!) {
              acceptOffer(context,productProvider);

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

  Future<void> validateKarzaAadhaarOtpVerifyForNBFC(
    BuildContext context,
    String otpText,
    BusinessDataProvider productProvider,
  ) async {
    if (otpText.isEmpty) {
      Utils.showToast("Please Enter OTP", context);
    } else if (otpText.length < 6) {
      Utils.showToast("PLease Enter Valid Otp", context);
    } else {
      final prefsUtil = await SharedPref.getInstance();
      final int? leadId = prefsUtil.getInt(LEADE_ID);
      var reqModel = KarzaAadhaarOtpVerifyForNbfcReqModel(
          otp: otpText,
          requestId: requestId,
          consent: "Y",
          aadhaarNo: "",
          leadMasterId: leadId);
      Utils.onLoading(context, "");
      await Provider.of<BusinessDataProvider>(context, listen: false)
          .getkarzaAadhaarOtpVerifyForNBFC(reqModel);
      Navigator.of(context, rootNavigator: true).pop();
      if (productProvider.getKarzaAadhaarOtpVerifyForNBFCData != null) {
        productProvider.getKarzaAadhaarOtpVerifyForNBFCData!.when(
          success: (data) async {
            if (data) {
              nbfcValidateAcceptOfferByLead(context, productProvider,otpText);
            } else {
              Utils.showToast("Invalid otp ", context);
            }
          },
          failure: (exception) {
            if (exception is ApiException) {
              if (exception.statusCode == 401) {
                productProvider.disposeAllProviderData();
                ApiService().handle401(context);
              } else {
                if (exception.errorMessage.isNotEmpty) {
                  Utils.showToast(exception.errorMessage, context);
                } else {
                  Utils.showToast("Server error", context);
                }
              }
            }
          },
        );
      }
    }
  }

  Future<void> acceptOffer(
      BuildContext context, BusinessDataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Utils.onLoading(context, "");
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .acceptOffer(leadId!);

    if (productProvider.getacceptOffersData != null) {
      productProvider.getacceptOffersData!.when(
        success: (data) async {
          var getacceptOffersData = data;
          if (getacceptOffersData != null) {
            fetchData(context);
          }
        },
        failure: (exception) {
          if (exception is ApiException) {
            Utils.onLoading(context, "");
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

  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        userId: prefsUtil.getString(USER_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData =
          await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
              as LeadCurrentResponseModel?;

      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;
      Navigator.of(context, rootNavigator: true).pop();
      customerSequence(
          context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }



}
