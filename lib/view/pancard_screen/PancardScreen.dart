import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/pancard_screen/model/PostLeadPANRequestModel.dart';

import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/DateTextFormatter.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/Utils.dart';
import '../../utils/common_check_box.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/loader.dart';
import '../login_screen/login_screen.dart';
import 'PermissionsScreen.dart';

class PancardScreen extends StatefulWidget {
  String? image;

  PancardScreen({super.key, this.image});

  @override
  State<PancardScreen> createState() => _PancardScreenState();
}

class _PancardScreenState extends State<PancardScreen> {
  bool isTermsChecks = false;
  final TextEditingController _panNumberCl = TextEditingController();
  final TextEditingController _nameAsPanCl = TextEditingController();
  final TextEditingController _dOBAsPanCl = TextEditingController();
  final TextEditingController _fatherNameAsPanCl = TextEditingController();
  var isLoading = true;
  var isEnabledPanNumber = true;
  var isVerifyPanNumber = false;
  var isDataClear = false;

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
      //   widget.image = imageFile;
      //api call
      Utils.onLoading(context, "");

      await Provider.of<DataProvider>(context, listen: false)
          .postSingleFile(imageFile, true, "", "dfhsjfh");
      Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: Consumer<DataProvider>(builder: (context, productProvider, child) {
            if (productProvider.getLeadPANData == null && isLoading) {
              return Loader();
            } else {
              if (productProvider.getLeadPANData != null && isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }
              var LeadPANData = productProvider.getLeadPANData!;
              /* LeadPANData.panCard="JKMPS653E";
              LeadPANData.nameOnCard="Atul Singh";
              LeadPANData.dob="28/07/1999";
              LeadPANData.fatherName="Dinesh singh";*/
              if (LeadPANData.panCard != null && !isDataClear) {
                isVerifyPanNumber = true;
                isEnabledPanNumber = false;
                _panNumberCl.text = LeadPANData.panCard!;
                _nameAsPanCl.text = LeadPANData.nameOnCard!;
                _dOBAsPanCl.text = LeadPANData.dob!;
                _fatherNameAsPanCl.text = LeadPANData.fatherName!;
                widget.image = LeadPANData.panImagePath;
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
                        Text(
                          'Enter Your PAN',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 40, color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Verify the PAN number',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'PAN Number',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(
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
                                  decoration: InputDecoration(
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
                                                .message!!);
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
                                                      activityId: 0,
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

                                              LeadPANData.panCard = "";
                                              LeadPANData.nameOnCard = "";
                                              LeadPANData.dob = "";
                                              LeadPANData.fatherName = "";

                                              print("fdhg");
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
                        Text(
                          'Name ( As per PAN )',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          controller: _nameAsPanCl,
                          keyboardType: TextInputType.text,
                          cursorColor: kPrimaryColor,
                          enabled: false,
                          decoration: InputDecoration(
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
                                          productProvider.getPostSingleFileData!
                                              .filePath! as String,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 148,
                                        ),
                                      )
                                    : (widget.image != null)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              widget.image as String,
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
                          onChanged: (bool isChecked) {
                            // Handle the state change here
                            print('Checkbox state changed: $isChecked');
                            isTermsChecks = isChecked;
                          },
                          text: "Term & Condition ",
                          upperCase: true,
                        ),
                        SizedBox(height: 30),
                        CommonElevatedButton(
                          onPressed: () async {
                            print("sdfsdf$isTermsChecks");
                            if (LeadPANData.panCard == null) {
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
                              } else if (productProvider
                                      .getPostSingleFileData?.filePath ==
                                  null) {
                                Utils.showToast("Please Upload Pan Image ");
                              } else if (!isTermsChecks) {
                                Utils.showToast(
                                    "Please Check Terms And Conditions");
                              } else {
                                final prefsUtil =
                                    await SharedPref.getInstance();
                                final String? userId =
                                    prefsUtil.getString(USER_ID);
                                final int? companyId =
                                    prefsUtil.getInt(COMPANY_ID);
                                var postLeadPanRequestModel =
                                    PostLeadPanRequestModel(
                                  leadId: 1,
                                  userId: userId,
                                  activityId: 2,
                                  subActivityId: 2,
                                  uniqueId: _panNumberCl.text,
                                  imagePath: productProvider
                                      .getPostSingleFileData?.filePath,
                                  documentId: 31,
                                  companyId: companyId,
                                  fathersName: _fatherNameAsPanCl.text,
                                  dob: _dOBAsPanCl.text,
                                  name: _nameAsPanCl.text,
                                );

                                //api call
                                Utils.onLoading(context, "Loading...");
                                await Provider.of<DataProvider>(context,
                                        listen: false)
                                    .postLeadPAN(postLeadPanRequestModel);

                                if (productProvider.getPostLeadPaneData !=
                                    null) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Utils.showToast(productProvider
                                      .getPostLeadPaneData!.message!);
                                  if (productProvider
                                      .getPostLeadPaneData!.isSuccess!) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const PermissionsScreen();
                                        },
                                      ),
                                    );
                                  }
                                } else {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Utils.showToast(productProvider
                                      .getPostLeadPaneData!.message!);
                                }
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
}

Future<void> callApi(BuildContext context) async {
  final prefsUtil = await SharedPref.getInstance();
  final String? userId = prefsUtil.getString(USER_ID);

  Provider.of<DataProvider>(context, listen: false).getLeadPAN(userId!);
}
