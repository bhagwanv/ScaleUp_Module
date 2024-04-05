import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/ImagePicker.dart';
import 'package:scale_up_module/utils/common_elevted_button.dart';
import 'package:scale_up_module/view/pancard_screen/PermissionsScreen.dart';

import '../../data_provider/DataProvider.dart';
import '../../utils/Utils.dart';
import '../../utils/constants.dart';

class PancardScreen extends StatefulWidget {
  late File? image;

  PancardScreen({super.key, this.image});

  @override
  State<PancardScreen> createState() => _PancardScreenState();
}

class _PancardScreenState extends State<PancardScreen> {
  bool isChecked = false;

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
                        keyboardType: TextInputType.text,
                        cursorColor: kPrimaryColor,
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
                          suffixIcon: Container(
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/images/verify_pan.svg',
                              semanticsLabel: 'My SVG Image',
                            ),
                          ),
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
                        keyboardType: TextInputType.text,
                        cursorColor: kPrimaryColor,
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
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
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
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
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
                                      borderRadius: BorderRadius.circular(8.0),
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
                          CustomCheckbox(
                            onChanged: (bool isChecked) {
                              // Handle the state change here
                              print('Checkbox state changed: $isChecked');
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                          "I hereby accept Scaleup T&C & Privacy Notice. Further, I hereby agree to share my details, including PAN, Date of birth, Name, Pin code, Mobile number, Email id and device information with you and for further sharing with your partners including lending partners"),
                      SizedBox(height: 30),
                      CommonElevatedButton(
                        onPressed: () async {
                          Utils.onLoading(context, "Loading....");
                          await Provider.of<DataProvider>(context,
                                  listen: false)
                              .getLeadPAN(
                                  "ddf8360f-ef82-4310-bf6c-a64072728ec3");

                          if (productProvider.genrateOptData != null) {
                            Navigator.of(context, rootNavigator: true).pop();
                            Utils.showToast("Something went wrong");
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
                        },
                        text: "next",
                        upperCase: true,
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
  }
}

class CustomCheckbox extends StatefulWidget {
  final ValueChanged<bool>? onChanged;

  CustomCheckbox({Key? key, this.onChanged}) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          widget.onChanged?.call(isChecked);
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: isChecked
                  ? Container(
                      color: Color(0xff0196CE),
                      child: Icon(
                        Icons.check,
                        size: 18.0,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ),
            SizedBox(width: 8.0),
            Text('Custom Checkbox Text'),
          ],
        ),
      ),
    );
  }
}
