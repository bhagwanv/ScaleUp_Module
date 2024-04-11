import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/pancard_screen/model/PostLeadPANRequestModel.dart';

import '../../api/ApiService.dart';
import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/DateTextFormatter.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/Utils.dart';
import '../../utils/common_check_box.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../login_screen/login_screen.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'PermissionsScreen.dart';

class PancardScreen extends StatefulWidget {
  String image = "";
  final int activityId;
  final int subActivityId;

  PancardScreen(
      {super.key, required this.activityId, required this.subActivityId});

  @override
  State<PancardScreen> createState() => _PancardScreenState();
}

class _PancardScreenState extends State<PancardScreen> {
  final TextEditingController _panNumberCl = TextEditingController();
  final TextEditingController _nameAsPanCl = TextEditingController();
  final TextEditingController _dOBAsPanCl = TextEditingController();
  final TextEditingController _fatherNameAsPanCl = TextEditingController();
  var isLoading = true;
  var isEnabledPanNumber = true;
  var isVerifyPanNumber = false;
  var isDataClear = false;
  var _acceptPermissions = false;
  String panCard = "";
  String nameAsPan = "";
  String dobAsPan = "";
  String fatherNameAsPan = "";
  String panImageUrl = "";
  int documentId = 0;

  @override
  void initState() {
    super.initState();
    //Api Call
    callApi(context);
  }

  // Callback function to receive the selected image
  void _onImageSelected(File imageFile) {
    // Handle the selected image here
    // For example, you can setState to update UI with the selected image
    setState(() async {
      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context, listen: false)
          .postSingleFile(imageFile, true, "", "");
      Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  void _handlePermissionsAccepted(bool accept) {
    setState(() {
      _acceptPermissions = accept;

      print("asdfads$_acceptPermissions");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: Consumer<DataProvider>(
              builder: (context, productProvider, child) {
            if (productProvider.getLeadPANData == null && isLoading) {
              return Loader();
            } else {
              if (productProvider.getLeadPANData != null && isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }
              var LeadPANData = productProvider.getLeadPANData!;

              if (LeadPANData.panCard != null && !isDataClear) {
                isVerifyPanNumber = true;
                isEnabledPanNumber = false;
                _panNumberCl.text = LeadPANData.panCard!;
                _nameAsPanCl.text = LeadPANData.nameOnCard!;
                //  var formateDob=Utils.dateFormate(context,LeadPANData.dob!);
                _dOBAsPanCl.text = LeadPANData.dob!;
                _fatherNameAsPanCl.text = LeadPANData.fatherName!;
                widget.image = LeadPANData.panImagePath!;
                documentId = LeadPANData.documentId!;
              }

              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.topLeft,
                            child: Image.asset('assets/images/scale.png')),
                        const Text(
                          'Enter Your PAN',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 40, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Verify the PAN number',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'PAN Number',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: textFiledBackgroundColour,
                            border: Border.all(color: kPrimaryColor),
                            // Set background color
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _panNumberCl,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.blue,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  maxLines: 1,
                                  enabled: isEnabledPanNumber,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    // Limit to 10 characters
                                  ],
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0.0),
                                    hintText: "Enter PAN Number",
                                    fillColor: textFiledBackgroundColour,
                                    filled: true,
                                    border: InputBorder
                                        .none, // Remove underline border
                                  ),
                                  onChanged: (text) async {
                                    print(
                                        'TextField value: $text (${text.length})');
                                    if (text.length == 10) {
                                      try {
                                        // Make API Call to validate PAN card
                                        Utils.onLoading(context, "Loading...");
                                        await Provider.of<DataProvider>(context,
                                                listen: false)
                                            .getLeadValidPanCard(
                                                _panNumberCl.text);
                                        if (productProvider
                                                .getLeadValidPanCardData
                                                ?.statusCode !=
                                            401) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          if (productProvider
                                                  .getLeadValidPanCardData!
                                                  .nameOnPancard !=
                                              null) {
                                            _nameAsPanCl.text = productProvider
                                                .getLeadValidPanCardData!
                                                .nameOnPancard!;
                                            isVerifyPanNumber = true;
                                            Utils.showToast(productProvider
                                                .getLeadValidPanCardData!
                                                .message!);
                                            Utils.onLoading(context, "");
                                            await Provider.of<DataProvider>(
                                                    context,
                                                    listen: false)
                                                .getFathersNameByValidPanCard(
                                                    _panNumberCl.text);
                                            if (productProvider
                                                    .getFathersNameByValidPanCardData !=
                                                null) {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            }
                                            if (productProvider
                                                    .getFathersNameByValidPanCardData!
                                                    .dob !=
                                                Null) {
                                              /* var formateDob=Utils.dateFormate(context,productProvider
                                                  .getFathersNameByValidPanCardData!
                                                  .dob);*/
                                              _dOBAsPanCl.text = productProvider
                                                  .getFathersNameByValidPanCardData!
                                                  .dob;
                                            }
                                          } else {
                                            Utils.showToast(productProvider
                                                .getLeadValidPanCardData!
                                                .message!!);
                                          }
                                        } else {
                                          Navigator.pushAndRemoveUntil<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) =>
                                                  LoginScreen(
                                                      activityId: 1,
                                                      subActivityId: 0),
                                            ),
                                            (route) =>
                                                false, //if you want to disable back feature set to false
                                          );
                                        }
                                      } catch (error) {
                                        // Handle any errors that occur during the API call
                                        print('Error: $error');
                                      }
                                    }
                                  },
                                ),
                              ),
                              isVerifyPanNumber
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/verify_pan.svg',
                                          semanticsLabel: 'Verify PAN SVG',
                                        ),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isEnabledPanNumber = true;
                                              isVerifyPanNumber = false;
                                              isDataClear = true;
                                              _panNumberCl.text = "";
                                              _nameAsPanCl.text = "";
                                              _dOBAsPanCl.text = "";
                                              _fatherNameAsPanCl.text = "";
                                              widget.image = "";
                                              _acceptPermissions = false;

                                              LeadPANData.panCard = "";
                                              LeadPANData.nameOnCard = "";
                                              LeadPANData.dob = "";
                                              LeadPANData.fatherName = "";
                                              LeadPANData.panImagePath = "";
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icons/edit_icon.svg',
                                            semanticsLabel: 'Edit Icon SVG',
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        const Text(
                          'Name ( As per PAN )',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _nameAsPanCl,
                          keyboardType: TextInputType.text,
                          cursorColor: kPrimaryColor,
                          enabled: false,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            hintText: "Enter Name",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'DOB ( As per PAN )',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          controller: _dOBAsPanCl,
                          keyboardType: TextInputType.text,
                          cursorColor: kPrimaryColor,
                          enabled: false,
                          inputFormatters: [DateTextFormatter()],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            hintText: "DD | MM | YYYY",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Father’s Name ( As per PAN )',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          controller: _fatherNameAsPanCl,
                          keyboardType: TextInputType.text,
                          cursorColor: kPrimaryColor,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            hintText: "Enter Father Name",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0xff0196CE))),
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                bottomSheetMenu(context);
                              },
                              child: Container(
                                height: 148,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xffEFFAFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: (productProvider.getPostSingleFileData !=
                                        null)
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          productProvider
                                              .getPostSingleFileData!.filePath!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 148,
                                        ),
                                      )
                                    : (widget.image.isNotEmpty)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              widget.image!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 148,
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/images/gallery.svg'),
                                              const Text(
                                                'Upload PAN Image',
                                                style: TextStyle(
                                                    color: Color(0xff0196CE),
                                                    fontSize: 12),
                                              ),
                                              const Text('Supports : JPEG, PNG',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Color(0xffCACACA))),
                                            ],
                                          ),
                              ),
                            )),
                        SizedBox(height: 20),
                        CommonCheckBox(
                          onChanged: (bool isChecked) async {
                            // Handle the state change here
                            print('Checkbox state changed: $isChecked');
                            if (isChecked) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PermissionsScreen()),
                              );
                              // Handle the result from Screen B using the callback function
                              _handlePermissionsAccepted(result ?? false);
                            }
                          },
                          isChecked: _acceptPermissions,
                          text:
                              "By proceeding, I provide consent on the following",
                          upperCase: true,
                        ),
                        SizedBox(height: 20),
                        Text(
                            "I hereby accept Scaleup T&C & Privacy Policy . Further, I hereby agree to share my details, including PAN, Date of birth, Name, Pin code, Mobile number, Email id and device information with you and for further sharing with your partners including lending partners"),
                        SizedBox(height: 30),
                        CommonElevatedButton(
                          onPressed: () async {
                            final prefsUtil = await SharedPref.getInstance();
                            final String? userId = prefsUtil.getString(USER_ID);
                            final int? companyId = prefsUtil.getInt(COMPANY_ID);

                            if (productProvider.getPostSingleFileData != null) {
                              if (productProvider
                                      .getPostSingleFileData!.filePath !=
                                  null) {
                                widget.image = productProvider
                                    .getPostSingleFileData!.filePath!;
                                documentId = productProvider
                                    .getPostSingleFileData!.docId!;
                              }
                            }

                            if (_panNumberCl.text.isEmpty) {
                              Utils.showToast("Please Enter Pan Number");
                            } else if (_nameAsPanCl.text.isEmpty) {
                              Utils.showToast(
                                  "Please Enter Name (As Per Pan))");
                            } else if (_dOBAsPanCl.text.isEmpty) {
                              Utils.showToast(
                                  "Please Enter Name (As Per Pan))");
                            } else if (_fatherNameAsPanCl.text.isEmpty) {
                              Utils.showToast(
                                  "Please Enter Father Name (As Per Pan))");
                            } else if (widget.image == "") {
                              Utils.showToast("Please Upload Pan Image ");
                            } else if (!_acceptPermissions) {
                              Utils.showToast(
                                  "Please Check Terms And Conditions");
                            } else {
                              var postLeadPanRequestModel =
                                  PostLeadPanRequestModel(
                                leadId: prefsUtil.getInt(LEADE_ID),
                                userId: userId,
                                activityId: widget.activityId,
                                subActivityId: widget.subActivityId,
                                uniqueId: _panNumberCl.text,
                                imagePath: widget.image,
                                documentId: 31,
                                companyId: companyId,
                                fathersName: _fatherNameAsPanCl.text,
                                dob: _dOBAsPanCl.text,
                                name: _nameAsPanCl.text,
                              );

                              Utils.onLoading(context, "Loading...");
                              await Provider.of<DataProvider>(context,
                                      listen: false)
                                  .postLeadPAN(postLeadPanRequestModel);

                              if (productProvider
                                      .getPostLeadPaneData?.statusCode !=
                                  401) {
                                if (productProvider.getPostLeadPaneData !=
                                    null) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Utils.showToast(productProvider
                                      .getPostLeadPaneData!.message!);
                                  if (productProvider
                                      .getPostLeadPaneData!.isSuccess!) {
                                    fetchData(context);
                                  }
                                }
                              } else {
                                Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        LoginScreen(
                                            activityId: 1, subActivityId: 0),
                                  ),
                                  (route) =>
                                      false, //if you want to disable back feature set to false
                                );
                              }
                            }
                          },
                          text: "next",
                          upperCase: true,
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ));

    Widget loadingWidget = Utils.onLoading(context, "Loading....");
  }

  @override
  void dispose() {
    _panNumberCl.dispose();
    _nameAsPanCl.dispose();
    _dOBAsPanCl.dispose();
    _fatherNameAsPanCl.dispose();
    super.dispose();
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
  }

  Future<void> callApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);

    Provider.of<DataProvider>(context, listen: false).getLeadPAN(userId!);
  }

  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        userId: prefsUtil.getString(USER_ID),
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
          0) as GetLeadResponseModel?;

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData);
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
