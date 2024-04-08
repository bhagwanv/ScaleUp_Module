import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/view/aadhaar_screen/aadhaar_otp_screen.dart';
import 'package:scale_up_module/view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import '../../data_provider/DataProvider.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/Utils.dart';
import '../../utils/aadhaar_number_formatter.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import 'components/CheckboxTerm.dart';

class AadhaarScreen extends StatefulWidget {
  late File? frontImage = null;
  late File? backImage = null;

  AadhaarScreen({super.key});

  @override
  State<AadhaarScreen> createState() => _AadhaarScreenState();
}

class _AadhaarScreenState extends State<AadhaarScreen> {
  final TextEditingController _aadhaarController = TextEditingController();

  void _onFontImageSelected(File imageFile) {
    setState(() {
      widget.frontImage = imageFile;
      Navigator.pop(context);
    });
  }

  // Callback function to receive the selected image
  void _onBackImageSelected(File imageFile) {
    // Handle the selected image here
    // For example, you can setState to update UI with the selected image
    setState(() {
      widget.backImage = imageFile;
      Navigator.pop(context);
    });
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Image.asset(
                      'assets/images/scale.png',
                      fit: BoxFit.cover,
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
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: textFiledBackgroundColour,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: (widget.frontImage != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  widget.frontImage as File,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 148,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: SvgPicture.asset(
                                          "assets/icons/gallery.svg",
                                          colorFilter: const ColorFilter.mode(
                                              kPrimaryColor, BlendMode.srcIn))),
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
                ),
                const SizedBox(height: 16),
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
                        child: (widget.backImage != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  widget.backImage as File,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 148,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: SvgPicture.asset(
                                          "assets/icons/gallery.svg",
                                          colorFilter: const ColorFilter.mode(
                                              kPrimaryColor, BlendMode.srcIn))),
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
                const SizedBox(height: 20),
                const CheckboxTerm(),
                const SizedBox(height: 46),
                CommonElevatedButton(
                  onPressed: () {
                    callAPI(context, productProvider, _aadhaarController.text);
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
            ),
          ),
        );
      })),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _aadhaarController.dispose();
    super.dispose();
  }

  void callAPI(BuildContext context, DataProvider productProvider,
      String documentNumber) async {
    Utils.onLoading(context, "Loading....");
    var request = AadhaarGenerateOTPRequestModel(
        DocumentNumber: documentNumber,
        FrontFileUrl: "",
        BackFileUrl: "",
        FrontDocumentId: "",
        BackDocumentId: "",
        otp: "",
        requestId: "");
    await Provider.of<DataProvider>(context, listen: false)
        .leadAadharGenerateOTP(request);
    if (!productProvider.genrateOptData!.status!) {
      Navigator.of(context, rootNavigator: true).pop();
      Utils.showToast("Something went wrong");
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AadhaarOtpScreen()));
    }
  }
}
