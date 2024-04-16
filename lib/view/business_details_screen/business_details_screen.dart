import 'dart:io';

import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/common_text_field.dart';

import '../../api/ApiService.dart';
import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../personal_info/model/CityResponce.dart';
import '../personal_info/model/ReturnObject.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/PostLeadBuisnessDetailRequestModel.dart';

class BusinessDetailsScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  const BusinessDetailsScreen(
      {super.key, required this.activityId, required this.subActivityId});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetailsScreen> {
  var isLoading = true;
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _businessDocumentNumberController =
      TextEditingController();
  String? selectedStateValue;
  String? selectedCityValue;

  var gstNumber = "";
  var image = "";
  int? businessProofDocId;

  var isClearData = false;
  var isImageDelete = false;

  var updateData = false;

  List<CityResponce?> citylist = [];
  var cityCallInitial = true;

  List<DropdownMenuItem<ReturnObject>> getAllState(List<ReturnObject?> items) {
    final List<DropdownMenuItem<ReturnObject>> menuItems = [];
    for (final ReturnObject? item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<ReturnObject>(
            value: item,
            child: Text(
              item!.name!, // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          if (item != items.last)
            const DropdownMenuItem<ReturnObject>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights2(List<ReturnObject?> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  List<double> _getCustomItemsHeights3(List<CityResponce?> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  void _onImageSelected(File imageFile) async {
    isImageDelete = false;
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postBusineesDoumentSingleFile(imageFile, true, "", "");

    setState(() {
      Navigator.pop(context);
    });
  }

  final List<String> businessTypeList = [
    'Proprietorship',
    'Partnership',
    'Pvt Ltd',
    'HUF',
    'LLP'
  ];
  String? selectedBusinessTypeValue;

  final List<String> monthlySalesTurnoverList = [
    'Upto 3 Lacs',
    '3 Lacs - 10 Lacs',
    '10 Lacs - 25 Lacs',
    'Above 25 Lacs'
  ];
  String? selectedMonthlySalesTurnoverValue;

  final List<String> chooseBusinessProofList = [
    'GST Certificate',
    'Udyog Aadhaar Certificate',
    'Shop Establishment Certificate',
    'Trade License',
    'Others'
  ];
  String? selectedChooseBusinessProofValue;

  var gstUpdate = false;

  var setStateListFirstTime = true;
  var setCityListFirstTime = true;

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights(List<String> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  DateTime date = DateTime.now().subtract(const Duration(days: 1));

  String minDateTime = '2010-05-12';
  String maxDateTime = '2030-11-25';
  String initDateTime = '2021-08-31';

  final bool _showTitle = true;
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  final String _format = 'yyyy-MMMM-dd';

  DateTime? _dateTime;
  String? slectedDate = "";

  /// Display date picker.
  void _showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        cancel: const Icon(
          Icons.close,
          color: Colors.black38,
        ),
        title: 'Business Incorporation Date',
        titleTextStyle: const TextStyle(fontSize: 14),
        showTitle: _showTitle,
        selectionOverlayColor: Colors.blue,
        // showTitle: false,
        // titleHeight: 80,
        // confirm: const Text('确定', style: TextStyle(color: Colors.blue)),
      ),
      minDateTime: DateTime.parse(minDateTime),
      maxDateTime: DateTime.parse(maxDateTime),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () => debugPrint("----- onClose -----"),
      onCancel: () => debugPrint('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          slectedDate = Utils.dateFormate(context, _dateTime.toString());
          if (kDebugMode) {
            print("$_dateTime");
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //Api Call
    getPersonalDetailAndStateApi(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
            top: true,
            bottom: true,
            child: Consumer<DataProvider>(
                builder: (context, productProvider, child) {
              if (productProvider.getLeadBusinessDetailData == null &&
                  isLoading) {
                return const Loader();
              } else {
                if (productProvider.getLeadBusinessDetailData != null &&
                    isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }
                if (productProvider.getLeadBusinessDetailData != null) {
                  if (productProvider.getLeadBusinessDetailData?.businessName !=
                          null &&
                      productProvider.getLeadBusinessDetailData?.doi != null &&
                      !isClearData &&
                      !isImageDelete) {
                    if (productProvider.getLeadBusinessDetailData!.busGSTNO !=
                        null) {
                      _gstController.text =
                          productProvider.getLeadBusinessDetailData!.busGSTNO!;
                      gstNumber =
                          productProvider.getLeadBusinessDetailData!.busGSTNO!;
                    }

                    _businessNameController.text = productProvider
                        .getLeadBusinessDetailData!.businessName!;
                    _addressLineController.text = productProvider
                        .getLeadBusinessDetailData!.addressLineOne!;
                    slectedDate = Utils.dateFormate(context,
                        productProvider.getLeadBusinessDetailData!.doi!);
                    _addressLine2Controller.text = productProvider
                        .getLeadBusinessDetailData!.addressLineTwo!;
                    _pinCodeController.text = productProvider
                        .getLeadBusinessDetailData!.zipCode!
                        .toString();
                    _businessDocumentNumberController.text = productProvider
                        .getLeadBusinessDetailData!.buisnessDocumentNo!;
                    image = productProvider
                        .getLeadBusinessDetailData!.buisnessProofUrl!;
                    selectedBusinessTypeValue = productProvider
                        .getLeadBusinessDetailData!.busEntityType!;
                    selectedStateValue = productProvider
                        .getLeadBusinessDetailData!.stateId!
                        .toString();
                    selectedCityValue = productProvider
                        .getLeadBusinessDetailData!.cityId!
                        .toString();
                    selectedMonthlySalesTurnoverValue = productProvider
                        .getLeadBusinessDetailData!.incomeSlab!
                        .toString();
                    businessProofDocId = productProvider
                        .getLeadBusinessDetailData!.buisnessProofDocId!;
                  } else {
                    updateData = true;
                  }
                }

                if (productProvider.getCustomerDetailUsingGSTData != null) {
                  if (productProvider.getCustomerDetailUsingGSTData!.busGSTNO !=
                          null &&
                      !gstUpdate) {
                    if (productProvider
                        .getCustomerDetailUsingGSTData!.busGSTNO!.isNotEmpty) {
                      slectedDate = Utils.dateFormate(context,
                          productProvider.getCustomerDetailUsingGSTData!.doi!);
                      updateData = false;
                    }
                  }
                }

                if (productProvider.getAllCityData != null) {
                  citylist = productProvider.getAllCityData!;
                }

                if (productProvider.getpostBusineesDoumentSingleFileData !=
                        null &&
                    !isImageDelete) {
                  if (productProvider
                          .getpostBusineesDoumentSingleFileData!.filePath !=
                      null) {
                    image = productProvider
                        .getpostBusineesDoumentSingleFileData!.filePath!;
                    businessProofDocId = productProvider
                        .getpostBusineesDoumentSingleFileData!.docId!;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SvgPicture.asset(
                              "assets/icons/back_arrow_icon.svg",
                              colorFilter: const ColorFilter.mode(
                                  kPrimaryColor, BlendMode.srcIn)),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 0),
                          child: Text(
                            "Step 1",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const Text(
                          "Business Details",
                          style: TextStyle(
                            fontSize: 40.0,
                            color: blackSmall,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 28.0,
                        ),
                        Stack(
                          children: [
                            CommonTextField(
                                controller: _gstController,
                                hintText: "07AACDW15215NF",
                                keyboardType: TextInputType.text,
                                enabled: updateData,
                                labelText: "GST Number(Optional)",
                                textCapitalization:
                                    TextCapitalization.characters,
                                inputFormatter: [
                                  LengthLimitingTextInputFormatter(15)
                                ],
                                onChanged: (text) async {
                                  if (text.length == 15) {
                                    try {
                                      Utils.hideKeyBored(context);
                                      await getCustomerDetailUsingGST(
                                          context, _gstController.text);
                                      if (productProvider
                                              .getCustomerDetailUsingGSTData !=
                                          null) {
                                        if (productProvider
                                                .getCustomerDetailUsingGSTData!
                                                .busGSTNO !=
                                            null) {
                                          Utils.showToast(productProvider
                                              .getCustomerDetailUsingGSTData!
                                              .message!);
                                          updateData = false;
                                          gstUpdate = false;
                                          cityCallInitial = true;
                                          _gstController.text = productProvider
                                              .getCustomerDetailUsingGSTData!
                                              .busGSTNO!;
                                          gstNumber = productProvider
                                              .getCustomerDetailUsingGSTData!
                                              .busGSTNO!;
                                          _businessNameController.text =
                                              productProvider
                                                  .getCustomerDetailUsingGSTData!
                                                  .businessName!;
                                          _addressLineController.text =
                                              productProvider
                                                  .getCustomerDetailUsingGSTData!
                                                  .addressLineOne!;
                                          _addressLine2Controller.text =
                                              productProvider
                                                  .getCustomerDetailUsingGSTData!
                                                  .addressLineTwo!;
                                          _pinCodeController.text =
                                              productProvider
                                                  .getCustomerDetailUsingGSTData!
                                                  .zipCode!
                                                  .toString();

                                          _businessDocumentNumberController
                                                  .text =
                                              productProvider
                                                  .getCustomerDetailUsingGSTData!
                                                  .buisnessDocumentNo!;
                                        } else {
                                          Utils.showToast(productProvider
                                              .getCustomerDetailUsingGSTData!
                                              .message!);
                                        }
                                      }
                                    } catch (error) {
                                      debugPrint('Error: $error');
                                    }
                                  }
                                }),
                            Positioned(
                              top: 0,
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // print('Edit icon tapped');
                                  setState(() {
                                    updateData = true;
                                    isImageDelete = true;
                                    gstUpdate = true;
                                    setCityListFirstTime = false;
                                    _gstController.text = "";
                                    _businessNameController.text = "";
                                    _addressLineController.text = "";
                                    _addressLine2Controller.text = "";
                                    _pinCodeController.text = "";
                                    _businessDocumentNumberController.text = "";
                                    slectedDate = "";
                                    selectedBusinessTypeValue = null;
                                    selectedStateValue = null;
                                    selectedCityValue = null;
                                    selectedMonthlySalesTurnoverValue = null;

                                    isClearData = true;
                                    gstNumber = "";
                                    image = "";
                                    businessProofDocId = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: SvgPicture.asset(
                                    'assets/icons/edit_icon.svg',
                                    semanticsLabel: 'Edit Icon SVG',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _businessNameController,
                          enabled: updateData,
                          hintText: "Shree Balaji Traders ",
                          labelText: "Business Name(As Per Doc)",
                        ),
                        const SizedBox(
                          height: 22.0,
                        ),
                        const Text(
                          "Business Address ",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: gryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _addressLineController,
                          enabled: updateData,
                          hintText: "Address Line 1",
                          labelText: "Address Line 1",
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _addressLine2Controller,
                          enabled: updateData,
                          hintText: "Address Line 2",
                          labelText: "Address Line 2",
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _pinCodeController,
                          enabled: updateData,
                          hintText: "Pin Code",
                          labelText: "Pin Code",
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        buildStateField(productProvider),
                        const SizedBox(
                          height: 16.0,
                        ),
                        buildCityField(productProvider),
                        const SizedBox(
                          height: 16.0,
                        ),
                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            ),
                          ),
                          hint: const Text(
                            'Business Type',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items: _addDividersAfterItems(businessTypeList),
                          value: selectedBusinessTypeValue,
                          onChanged: (String? value) {
                            selectedBusinessTypeValue = value;
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            customHeights:
                                _getCustomItemsHeights(businessTypeList),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            ),
                          ),
                          hint: const Text(
                            'Monthly Sales Turnover',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items:
                              _addDividersAfterItems(monthlySalesTurnoverList),
                          value: selectedMonthlySalesTurnoverValue,
                          onChanged: (String? value) {
                            selectedMonthlySalesTurnoverValue = value;
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            customHeights: _getCustomItemsHeights(
                                monthlySalesTurnoverList),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        InkWell(
                          onTap: updateData
                              ? () {
                                  _showDatePicker(context);
                                }
                              : null,
                          // Set onTap to null when field is disabled
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: textFiledBackgroundColour,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: kPrimaryColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    slectedDate!.isNotEmpty
                                        ? '$slectedDate'
                                        : 'Business Incorporation Date',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const Icon(Icons.date_range),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 22.0,
                        ),
                        const Text(
                          "Business Address ",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: gryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            ),
                          ),
                          hint: const Text(
                            'Choose Business Proof',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items:
                              _addDividersAfterItems(chooseBusinessProofList),
                          value: selectedChooseBusinessProofValue,
                          onChanged: (String? value) {
                            setState(() {
                              selectedChooseBusinessProofValue = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            customHeights:
                                _getCustomItemsHeights(chooseBusinessProofList),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        CommonTextField(
                          controller: _businessDocumentNumberController,
                          hintText: "Business Document Number",
                          labelText: "Business Document Number",
                        ),
                        const SizedBox(
                          height: 36.0,
                        ),
                        Stack(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0xff0196CE))),
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: () {
                                    bottomSheetMenu(context);
                                  },
                                  child: Container(
                                    height: 148,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffEFFAFF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      child: (image.isNotEmpty)
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                image,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 148,
                                              ),
                                            )
                                          : (image.isNotEmpty)
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    image,
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
                                                      'Upload Business Proof',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff0196CE),
                                                          fontSize: 12),
                                                    ),
                                                    const Text(
                                                        'Supports : JPEG, PNG',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xffCACACA))),
                                                  ],
                                                ),
                                    ),
                                  ),
                                )),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isImageDelete = true;
                                  image = "";
                                });
                              },
                              child: image.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(4),
                                      alignment: Alignment.topRight,
                                      child: SvgPicture.asset(
                                          'assets/icons/delete_icon.svg'),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 54.0),
                        CommonElevatedButton(
                          onPressed: () async {
                            if (_businessNameController.text.isEmpty) {
                              Utils.showToast(
                                  "Please Enter Business Name (As Per Doc)");
                            } else if (_addressLineController.text.isEmpty) {
                              Utils.showToast("Please Enter Address Line 1");
                            } else if (_addressLine2Controller.text.isEmpty) {
                              Utils.showToast("Please Enter Address Line 2");
                            } else if (_pinCodeController.text.isEmpty) {
                              Utils.showToast("Please Enter Pin Code");
                            } else if (selectedBusinessTypeValue == null) {
                              Utils.showToast("Please Select Business Type");
                            } else if (selectedMonthlySalesTurnoverValue ==
                                null) {
                              Utils.showToast("Please Select Income Slab");
                            } else if (_businessDocumentNumberController
                                .text.isEmpty) {
                              Utils.showToast(
                                  "Please Enter Business Document Number");
                            } else if (businessProofDocId == null) {
                              Utils.showToast("Please Select Proof");
                            } else if (slectedDate!.isEmpty) {
                              Utils.showToast(
                                  "Please Select Incorporation Date");
                            } else {
                              await postLeadBuisnessDetail(context);

                              if (productProvider
                                      .getPostLeadBuisnessDetailData !=
                                  null) {
                                if (productProvider
                                    .getPostLeadBuisnessDetailData!
                                    .isSuccess!) {
                                  fetchData(context);
                                }
                              }
                            }
                          },
                          text: 'Next',
                          upperCase: true,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
        );
  }

  Widget buildStateField(DataProvider productProvider) {
    ReturnObject? initialData;

    if (!gstUpdate && productProvider.getCustomerDetailUsingGSTData != null) {
      if (productProvider.getCustomerDetailUsingGSTData!.stateId != null &&
          productProvider.getCustomerDetailUsingGSTData!.stateId != 0 &&
          productProvider.getCustomerDetailUsingGSTData!.cityId != null &&
          productProvider.getCustomerDetailUsingGSTData!.cityId != 0) {
        setStateListFirstTime = true;
        if (productProvider.getAllStateData != null) {
          var allStates = productProvider.getAllStateData!.returnObject!;
          if (setStateListFirstTime) {
            initialData = allStates.firstWhere(
                (element) =>
                    element?.id ==
                    productProvider.getCustomerDetailUsingGSTData!.stateId,
                orElse: () => null);
            selectedStateValue = productProvider
                .getCustomerDetailUsingGSTData!.stateId!
                .toString();
          }

          if (cityCallInitial) {
            citylist.clear();
            Provider.of<DataProvider>(context, listen: false).getAllCity(
                productProvider.getCustomerDetailUsingGSTData!.stateId!);
            cityCallInitial = false;
          }
        }
      }
    } else {
      if (productProvider.getLeadBusinessDetailData!.stateId != null &&
          productProvider.getLeadBusinessDetailData!.stateId! != 0) {
        if (productProvider.getAllStateData != null) {
          var allStates = productProvider.getAllStateData!.returnObject!;
          if (setStateListFirstTime) {
            initialData = allStates.firstWhere(
                (element) =>
                    element?.id ==
                    productProvider.getLeadBusinessDetailData!.stateId,
                orElse: () => null);
            selectedStateValue =
                productProvider.getLeadBusinessDetailData!.stateId!.toString();
          }
        }
        if (cityCallInitial) {
          citylist.clear();
          Provider.of<DataProvider>(context, listen: false)
              .getAllCity(productProvider.getLeadBusinessDetailData!.stateId!);
          cityCallInitial = false;
        }
      } else {
        setStateListFirstTime = false;
      }
    }
    if (productProvider.getAllStateData != null) {
      return DropdownButtonFormField2<ReturnObject?>(
        isExpanded: true,
        value: initialData,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          fillColor: textFiledBackgroundColour,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
        ),
        hint: const Text(
          'State',
          style: TextStyle(
            color: blueColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: getAllState(productProvider.getAllStateData!.returnObject!),
        onChanged: setStateListFirstTime
            ? null
            : (ReturnObject? value) {
                citylist.clear();
                setStateListFirstTime = false;
                setCityListFirstTime = false;
                Provider.of<DataProvider>(context, listen: false)
                    .getAllCity(value!.id!);
                selectedStateValue = value.id!.toString();
              },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          customHeights: _getCustomItemsHeights2(
              productProvider.getAllStateData!.returnObject!),
        ),
        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildCityField(DataProvider productProvider) {
    if (productProvider.getAllCityData != null) {
      CityResponce? initialData;
      if (!gstUpdate && productProvider.getCustomerDetailUsingGSTData != null) {
        if (productProvider.getCustomerDetailUsingGSTData!.cityId != null &&
            productProvider.getCustomerDetailUsingGSTData!.cityId != 0) {
          setCityListFirstTime = true;
          if (setCityListFirstTime) {
            initialData = citylist.firstWhere(
                (element) =>
                    element?.id ==
                    productProvider.getCustomerDetailUsingGSTData!.cityId,
                orElse: () => CityResponce());
            selectedCityValue = productProvider
                .getCustomerDetailUsingGSTData!.cityId!
                .toString();
          }
        }
      } else {
        if (setCityListFirstTime) {
          initialData = citylist.firstWhere(
              (element) =>
                  element?.id ==
                  productProvider.getLeadBusinessDetailData!.cityId,
              orElse: () => CityResponce());
          selectedCityValue =
              productProvider.getLeadBusinessDetailData!.cityId!.toString();
        }
      }
      return DropdownButtonFormField2<CityResponce>(
        isExpanded: true,
        value: initialData,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          fillColor: textFiledBackgroundColour,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
        ),
        hint: const Text(
          'City',
          style: TextStyle(
            color: blueColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: getAllCity(citylist),
        onChanged: setCityListFirstTime
            ? null
            : (CityResponce? value) {
                selectedCityValue = value!.id.toString();
                setState(() {
                  setCityListFirstTime = false;
                });
              },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          customHeights: _getCustomItemsHeights3(citylist),
        ),
        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up),
        ),
      );
    } else {
      return Container();
    }
  }

  List<DropdownMenuItem<CityResponce>> getAllCity(List<CityResponce?> list) {
    final List<DropdownMenuItem<CityResponce>> menuItems = [];
    for (final CityResponce? item in list) {
      menuItems.addAll(
        [
          DropdownMenuItem<CityResponce>(
            value: item,
            child: Text(
              item!.name!, // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          if (item != list.last)
            const DropdownMenuItem<CityResponce>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  Future<void> getCustomerDetailUsingGST(
      BuildContext context, String gstNumber) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getCustomerDetailUsingGST(gstNumber);
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> postLeadBuisnessDetail(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    Utils.onLoading(context, "");

    /*'Upto 3 Lacs',
    '3 Lacs - 10 Lacs',
    '10 Lacs - 25 Lacs',
    'Above 25 Lacs */

    var monthelySlaesValue = 0;
    if (selectedMonthlySalesTurnoverValue == "Upto 3 Lacs") {
      monthelySlaesValue = 0;
    } else if (selectedMonthlySalesTurnoverValue == "3 Lacs - 10 Lacs") {
      monthelySlaesValue = 3;
    } else if (selectedMonthlySalesTurnoverValue == "10 Lacs - 25 Lacs") {
      monthelySlaesValue = 10;
    } else if (selectedMonthlySalesTurnoverValue == "Above 25 Lacs") {
      monthelySlaesValue = 25;
    } else {
      monthelySlaesValue = 0;
    }

    var postLeadBuisnessDetailRequestModel = PostLeadBuisnessDetailRequestModel(
      leadId: prefsUtil.getInt(LEADE_ID),
      userId: prefsUtil.getString(USER_ID),
      activityId: widget.activityId,
      subActivityId: widget.subActivityId,
      busName: _businessNameController.text.toString(),
      doi: slectedDate.toString(),
      busGSTNO: gstNumber,
      busEntityType: selectedBusinessTypeValue,
      busAddCorrLine1: _addressLineController.text.toString(),
      busAddCorrLine2: _addressLine2Controller.text.toString(),
      busAddCorrCity: selectedCityValue,
      busAddCorrState: selectedStateValue,
      busAddCorrPincode: _pinCodeController.text.toString(),
      buisnessMonthlySalary: monthelySlaesValue,
      incomeSlab: selectedMonthlySalesTurnoverValue,
      companyId: prefsUtil.getInt(COMPANY_ID),
      buisnessDocumentNo: _businessDocumentNumberController.text.toString(),
      buisnessProofDocId: businessProofDocId,
      buisnessProof: image,
    );
    debugPrint("Post DATA:: ${postLeadBuisnessDetailRequestModel.toJson()}");
    await Provider.of<DataProvider>(context, listen: false)
        .postLeadBuisnessDetail(postLeadBuisnessDetailRequestModel);
    Navigator.of(context, rootNavigator: true).pop();
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
  }

  Future<void> getPersonalDetailAndStateApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);

    await Provider.of<DataProvider>(context, listen: false)
        .getLeadBusinessDetail(userId!);

    await Provider.of<DataProvider>(context, listen: false).getAllState();
  }

  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final activityId = widget.activityId;
    final subActivityId = widget.subActivityId;

    try {
      final leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: activityId,
        subActivityId: subActivityId,
        userId: prefsUtil.getString(USER_ID),
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );

      final leadCurrentActivityAsyncData =
          await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
              as LeadCurrentResponseModel?;

      final getLeadData = await ApiService().getLeads(
        prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
        prefsUtil.getInt(COMPANY_ID)!,
        prefsUtil.getInt(PRODUCT_ID)!,
        prefsUtil.getInt(LEADE_ID)!,
      ) as GetLeadResponseModel?;

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData);
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
