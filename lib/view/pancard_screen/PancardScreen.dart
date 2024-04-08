import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data_provider/DataProvider.dart';
import '../../utils/DateTextFormatter.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/Utils.dart';
import '../../utils/common_check_box.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/loader.dart';
import 'PermissionsScreen.dart';

class PancardScreen extends StatefulWidget {
  late File? image;

  PancardScreen({super.key, this.image});

  @override
  State<PancardScreen> createState() => _PancardScreenState();
}

class _PancardScreenState extends State<PancardScreen> {
  bool isChecked = false;
  final TextEditingController _panNumberCl = TextEditingController();
  final TextEditingController _nameAsPanCl = TextEditingController();
  final TextEditingController _dOBAsPanCl = TextEditingController();
  final TextEditingController _fatherNameAsPanCl = TextEditingController();
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    // Loader();
    Provider.of<DataProvider>(context, listen: false)
        .getLeadPAN("ddf8360f-ef82-4310-bf6c-a64072728ec3");
    // Provider.of<DataProvider>(context, listen: false)
    //     .getLeadValidPanCard("JKMPS4653E");
  }


  // Callback function to receive the selected image
  void _onImageSelected(File imageFile) {
    // Handle the selected image here
    // For example, you can setState to update UI with the selected image
    setState(() {
      widget.image = imageFile;
      Navigator.pop(context);
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
              /* LeadPANData.panCard="JKMPS653E";
              LeadPANData.nameOnCard="Atul Singh";
              LeadPANData.dob="28/07/1999";
              LeadPANData.fatherName="Dinesh singh";*/
              if (LeadPANData.panCard != null) {
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
                        TextField(
                          controller: _panNumberCl,
                          keyboardType: TextInputType.text,
                          cursorColor: kPrimaryColor,
                          textCapitalization: TextCapitalization.characters,
                          maxLines: 1,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            hintText: "PAN number",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            suffixIcon: productProvider.getLeadValidPanCardData?.message=="Valid Pancard."
                                ? Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/images/verify_pan.svg',
                                semanticsLabel: 'My SVG Image',
                              ),
                            )
                                : null
                          ),
                          onChanged: (text) async {
                            print('First text field: $text (${text.characters.length})');
                            if (text.characters.length == 10) {
                              try {
                                Utils.onLoading(context,"");
                                await Provider.of<DataProvider>(context, listen: false).getLeadValidPanCard("JKMPS4653E");

                                if(productProvider.getLeadValidPanCardData!=null){
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  if(productProvider.getLeadValidPanCardData!.nameOnPancard!=null){
                                    Utils.showToast(productProvider.getLeadValidPanCardData!.message!!);
                                  }else{
                                    Utils.showToast(productProvider.getLeadValidPanCardData!.message!!);
                                  }
                                }

                              } catch (error) {
                                // Handle any errors that occur during the API call
                                print('Error: $error');
                              }
                            }
                          },


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
                                child: (widget.image != null)
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          widget.image as File,
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
                                                  color: Color(0xffCACACA))),
                                        ],
                                      ),
                              ),
                            )),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            CommonCheckBox(
                              onChanged: (bool isChecked) {
                                // Handle the state change here
                                print('Checkbox state changed: $isChecked');
                              },
                              text: "Term & Condition",
                              upperCase: true,
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                            "I hereby accept Scaleup T&C & Privacy Notice. Further, I hereby agree to share my details, including PAN, Date of birth, Name, Pin code, Mobile number, Email id and device information with you and for further sharing with your partners including lending partners"),
                        SizedBox(height: 30),
                        CommonElevatedButton(
                          onPressed: () async {
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
                              } else {

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
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
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const PermissionsScreen();
                                  },
                                ),
                              );
                            }
                            // await Provider.of<DataProvider>(context, listen: false)
                            //     .getLeads(8319552433,2,2,0);
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
