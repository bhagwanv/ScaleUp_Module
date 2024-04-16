import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/aadhaar_screen/aadhaar_otp_screen.dart';
import 'package:scale_up_module/view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import 'package:scale_up_module/view/aadhaar_screen/models/LeadAadhaarResponse.dart';
import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/Utils.dart';
import '../../utils/aadhaar_number_formatter.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../login_screen/login_screen.dart';
import 'components/CheckboxTerm.dart';

class AadhaarScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  const AadhaarScreen(
      {super.key, required this.activityId, required this.subActivityId});

  @override
  State<AadhaarScreen> createState() => _AadhaarScreenState();
}

class _AadhaarScreenState extends State<AadhaarScreen> {
  final TextEditingController _aadhaarController = TextEditingController();

  String frontDocumentId = "";
  String backDocumentId = "";
  String frontFileUrl = "";
  String backFileUrl = "";
  var isFrontImageDelete = false;
  var isBackImageDelete = false;

  void _onFontImageSelected(File imageFile) async {
    Utils.onLoading(context, "");
    isFrontImageDelete = false;
    // Perform asynchronous work first
    await Provider.of<DataProvider>(context, listen: false)
        .PostFrontAadhaarSingleFileData(imageFile, true, "", "");
    Navigator.of(context, rootNavigator: true).pop();
    // Update the widget state synchronously inside setState

  }

  // Callback function to receive the selected image
  void _onBackImageSelected(File imageFile) async {
    isBackImageDelete=false;
    Utils.onLoading(context, "");

    // Perform asynchronous work first
    await Provider.of<DataProvider>(context, listen: false)
        .postAadhaarBackSingleFile(imageFile, true, "", "");

    Navigator.of(context, rootNavigator: true).pop();
    // Update the widget state synchronously inside setState

  }

  void bottomSheetMenu(BuildContext context, String frontImage) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          // return const ImagePickerWidgets();
          return ImagePickerWidgets(
              onImageSelected: (frontImage == "AADHAAR_FRONT_IMAGE")
                  ? _onFontImageSelected
                  : _onBackImageSelected);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(body:
          Consumer<DataProvider>(builder: (context, productProvider, child) {
        if (productProvider.getLeadAadhaar != null) {
          if (productProvider.getLeadAadhaar!.documentNumber != null) {
            _aadhaarController.text =
                productProvider.getLeadAadhaar!.documentNumber!;
          }

          if (productProvider.getLeadAadhaar!.frontDocumentId != null) {
            frontDocumentId =
                productProvider.getLeadAadhaar!.frontDocumentId!.toString();
          }

          if (productProvider.getLeadAadhaar!.backDocumentId != null) {
            backDocumentId =
                productProvider.getLeadAadhaar!.backDocumentId!.toString();
          }

          if(productProvider.getLeadAadhaar!.frontImageUrl != null && !isFrontImageDelete) {
            frontFileUrl = productProvider.getLeadAadhaar!.frontImageUrl!.toString();
          }

          if(productProvider.getLeadAadhaar!.backImageUrl != null && !isBackImageDelete) {
            backFileUrl =
                productProvider.getLeadAadhaar!.backImageUrl!.toString();
          }


          if (productProvider.getPostFrontAadhaarSingleFileData != null && !isFrontImageDelete) {
            if (productProvider.getPostFrontAadhaarSingleFileData!.filePath !=
                null) {
              frontFileUrl =
              productProvider.getPostFrontAadhaarSingleFileData!.filePath!;
              frontDocumentId = productProvider
                  .getPostFrontAadhaarSingleFileData!.docId!
                  .toString();
            }
          }
          if (productProvider.getPostBackAadhaarSingleFileData !=
              null && !isBackImageDelete) {
            if (productProvider
                .getPostBackAadhaarSingleFileData!.filePath !=
                null) {
              backFileUrl = productProvider
                  .getPostBackAadhaarSingleFileData!.filePath!;
              backDocumentId = productProvider
                  .getPostBackAadhaarSingleFileData!.docId!
                  .toString();
            }
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                      height: 70,
                      width: 52,
                      child: Image.asset(
                        'assets/images/scale.png',
                        fit: BoxFit.fill,
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.only(left: 0, top: 50),
                  child: Text(
                    "Verify Aadhaar",
                    style: TextStyle(
                      fontSize: 40.0,
                      color: blackSmall,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 44),
                  child: Text(
                    "Please validate your Aadhaar number",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: blackSmall,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    AadhaarNumberFormatter(),
                  ],
                  controller: _aadhaarController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: blackSmall,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    fillColor: textFiledBackgroundColour,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: kPrimaryColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: kPrimaryColor, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: kPrimaryColor, width: 1),
                    ),
                    hintText: 'XXXX XXXX XXXX',
                    labelText: 'Aadhaar Card Number',
                    labelStyle: TextStyle(color: blackSmall),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 26),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kPrimaryColor, kPrimaryColor],
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 148,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: textFiledBackgroundColour,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: (frontFileUrl.isNotEmpty)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          frontFileUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 148,
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: SvgPicture.asset(
                                                  "assets/icons/gallery.svg",
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          kPrimaryColor,
                                                          BlendMode.srcIn))),
                                          const Text(
                                            'Upload Aadhar Front Image',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const Text(
                                            'Supports : JPEG, PNG',
                                            style: TextStyle(
                                              color: blackSmall,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                          ),
                          onTap: () {
                            bottomSheetMenu(context, "AADHAAR_FRONT_IMAGE");
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFrontImageDelete = true;
                            frontFileUrl = "";
                          });
                        },
                        child: !frontFileUrl.isEmpty?Container(
                          padding: EdgeInsets.all(4),
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                              'assets/icons/delete_icon.svg'),
                        ):Container(),)
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [kPrimaryColor, kPrimaryColor],
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      height: 148,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: textFiledBackgroundColour,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: (backFileUrl.isNotEmpty)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          backFileUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 148,
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: SvgPicture.asset(
                                                  "assets/icons/gallery.svg",
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          kPrimaryColor,
                                                          BlendMode.srcIn))),
                                          const Text(
                                            'Upload Aadhar Front Image',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const Text(
                                            'Supports : JPEG, PNG',
                                            style: TextStyle(
                                              color: blackSmall,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                          ),
                          onTap: () {
                            bottomSheetMenu(context, "AADHAAR_BACK_IMAGE");
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isBackImageDelete = true;
                          backFileUrl = "";
                        });
                      },
                      child: !backFileUrl.isEmpty?Container(
                        padding: EdgeInsets.all(4),
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(
                            'assets/icons/delete_icon.svg'),
                      ):Container(),)
                  ],
                ),
                const SizedBox(height: 20),
                const CheckboxTerm(),
                const SizedBox(height: 46),
                CommonElevatedButton(
                  onPressed: () {
                    //validate data
                    if (productProvider.getPostFrontAadhaarSingleFileData != null) {
                      if (productProvider.getPostFrontAadhaarSingleFileData!.filePath !=
                          null) {
                        frontFileUrl =
                            productProvider.getPostFrontAadhaarSingleFileData!.filePath!;
                        frontDocumentId = productProvider
                            .getPostFrontAadhaarSingleFileData!.docId!
                            .toString();
                      }
                    }
                    if (productProvider.getPostBackAadhaarSingleFileData !=
                        null) {
                      if (productProvider
                              .getPostBackAadhaarSingleFileData!.filePath !=
                          null) {
                        backFileUrl = productProvider
                            .getPostBackAadhaarSingleFileData!.filePath!;
                        backDocumentId = productProvider
                            .getPostBackAadhaarSingleFileData!.docId!
                            .toString();
                      }
                    }

                    //call api
                    if (_aadhaarController.text == "") {
                      Utils.showToast("Please Enter Aadhaar Number");
                    } else if (frontFileUrl == "" || frontDocumentId == "") {
                      Utils.showToast("Please select Aadhaar Front Image");
                    } else if (backFileUrl == "" || backDocumentId == "") {
                      Utils.showToast("Please select Aadhaar Back Image");
                    } else {
                      String stringWithSpaces = _aadhaarController.text;
                      print("normal" + stringWithSpaces);
                      String stringWithoutSpaces =
                          stringWithSpaces.replaceAll(RegExp(r'\s+'), '');
                      print("stringWithSpaces" + stringWithoutSpaces);
                      generateAadhaarOTPAPI(
                          context,
                          productProvider,
                          stringWithoutSpaces,
                          frontFileUrl,
                          frontDocumentId,
                          backFileUrl,
                          backDocumentId);
                    }
                  },
                  text: 'Proceed to E-Aadhaar',
                  upperCase: true,
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    "Proceed with manual Aadhaar ",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: kPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16)
              ],
            )),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      })),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAadhaarData(context);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _aadhaarController.dispose();
    super.dispose();
  }

  void generateAadhaarOTPAPI(
      BuildContext context,
      DataProvider productProvider,
      String documentNumber,
      String fFileUrl,
      String fDocumentId,
      String bFileUrl,
      String bDocumentId) async {
    Utils.onLoading(context, "Loading....");
    var request = AadhaarGenerateOTPRequestModel(
        DocumentNumber: documentNumber,
        FrontFileUrl: fFileUrl,
        BackFileUrl: bFileUrl,
        FrontDocumentId: fDocumentId,
        BackDocumentId: bDocumentId,
        otp: "",
        requestId: "");

    await Provider.of<DataProvider>(context, listen: false)
        .leadAadharGenerateOTP(request);

    String reqID = "";
    if (productProvider.getLeadAadharGenerateOTP?.errorCode == 500) {
      Navigator.of(context, rootNavigator: true).pop();
      Utils.showToast("Server Error");
    } else if (productProvider.getLeadAadharGenerateOTP?.errorCode != 401) {
      if (productProvider.getLeadAadharGenerateOTP != null) {
        Navigator.of(context, rootNavigator: true).pop();
        if (productProvider.getLeadAadharGenerateOTP!.data!.message != null) {
          Utils.showToast(
              " ${productProvider.getLeadAadharGenerateOTP!.data!.message!}");
        }
        reqID = productProvider.getLeadAadharGenerateOTP!.requestId!;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AadhaarOtpScreen(
                    activityId: widget.activityId,
                    subActivityId: widget.subActivityId,
                    document: request,
                    requestId: reqID)));
      } else {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              LoginScreen(activityId: 1, subActivityId: 0),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    }
  }

  Future<void> getAadhaarData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);

    Provider.of<DataProvider>(context, listen: false).getLeadAadhar(userId!);
  }
}
