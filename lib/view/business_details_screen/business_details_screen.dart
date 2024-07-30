import 'dart:io';

import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/common_text_field.dart';

import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/ImagePickerFile.dart';
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
  final String? pageType;

  const BusinessDetailsScreen(
      {super.key,
      required this.activityId,
      required this.subActivityId,
      this.pageType});

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
  var isGstFilled = false;

  var updateData = false;
  CityResponce? selectedCompanyCity = null;
  ReturnObject? selectedCompanyState = null;

  String? selectedCompanyStateValue;
  String? selectedCompanyCityValue;
  String? companyCityId;
  String? companyStateId;

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
          /*if (item != items.last)
            const DropdownMenuItem<ReturnObject>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),*/
        ],
      );
    }
    return menuItems;
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
  String? selectedChooseBusinessProofValue = null;

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
          /* if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),*/
        ],
      );
    }
    return menuItems;
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
          slectedDate =
              Utils.dateFormate(context, _dateTime.toString(), "dd/MM/yyyy");
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

                  _businessNameController.text =
                      productProvider.getLeadBusinessDetailData!.businessName!;
                  _addressLineController.text = productProvider
                      .getLeadBusinessDetailData!.addressLineOne!;
                  slectedDate = Utils.dateFormate(
                      context,
                      productProvider.getLeadBusinessDetailData!.doi!,
                      "dd/MM/yyyy");
                  _addressLine2Controller.text = productProvider
                      .getLeadBusinessDetailData!.addressLineTwo!;
                  _pinCodeController.text = productProvider
                      .getLeadBusinessDetailData!.zipCode!
                      .toString();
                  _businessDocumentNumberController.text = productProvider
                      .getLeadBusinessDetailData!.buisnessDocumentNo!;
                  image = productProvider
                      .getLeadBusinessDetailData!.buisnessProofUrl!;
                  selectedBusinessTypeValue =
                      productProvider.getLeadBusinessDetailData!.busEntityType!;
                  selectedStateValue = productProvider
                      .getLeadBusinessDetailData!.stateId!
                      .toString();
                  selectedCityValue = productProvider
                      .getLeadBusinessDetailData!.cityId!
                      .toString();

                  companyStateId = productProvider
                      .getLeadBusinessDetailData!.stateId!
                      .toString();
                  companyCityId = productProvider
                      .getLeadBusinessDetailData!.cityId!
                      .toString();

                  selectedMonthlySalesTurnoverValue = productProvider
                      .getLeadBusinessDetailData!.incomeSlab!
                      .toString();
                  businessProofDocId = productProvider
                      .getLeadBusinessDetailData!.buisnessProofDocId!;
                  if (productProvider
                          .getLeadBusinessDetailData!.buisnessProof !=
                      null) {
                    selectedChooseBusinessProofValue = productProvider
                        .getLeadBusinessDetailData!.buisnessProof!;
                  }
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
                    slectedDate = Utils.dateFormate(
                        context,
                        productProvider.getCustomerDetailUsingGSTData!.doi!,
                        "dd/MM/yyyy");
                    if (productProvider.getCustomerDetailUsingGSTData!
                            .buisnessProofDocId !=
                        0) {
                      businessProofDocId = productProvider
                          .getCustomerDetailUsingGSTData!.buisnessProofDocId!;
                    }
                    if (productProvider
                            .getCustomerDetailUsingGSTData!.buisnessProofUrl !=
                        null) {
                      image = productProvider
                          .getCustomerDetailUsingGSTData!.buisnessProofUrl!;
                    }

                    if (productProvider
                            .getCustomerDetailUsingGSTData!.buisnessProof !=
                        null) {
                      print("yha pr aaya ");
                      selectedChooseBusinessProofValue = productProvider
                          .getCustomerDetailUsingGSTData!.buisnessProof!;
                    }
                    if (productProvider
                            .getCustomerDetailUsingGSTData!.buisnessProof !=
                        null) {
                      if (productProvider
                              .getCustomerDetailUsingGSTData!.busEntityType !=
                          null) {
                        selectedBusinessTypeValue = productProvider
                            .getCustomerDetailUsingGSTData!.busEntityType!;
                      }
                    }
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SvgPicture.asset(
                            "assets/icons/back_arrow_icon.svg",
                            colorFilter: const ColorFilter.mode(
                                kPrimaryColor, BlendMode.srcIn)),
                      ),*/
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
                              hintText: "GST Number(Optional)",
                              keyboardType: TextInputType.text,
                              enabled: updateData,
                              labelText: "GST Number(Optional)",
                              textCapitalization: TextCapitalization.characters,
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp((r'[A-Z0-9]'))),
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
                                        //chooseBusinessProofList!.first;
                                        isGstFilled = true;
                                        selectedChooseBusinessProofValue =
                                            "GST Certificate";
                                        _businessDocumentNumberController.text =
                                            productProvider
                                                .getCustomerDetailUsingGSTData!
                                                .busGSTNO!;
                                        companyStateId = productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .stateId
                                            .toString();
                                        companyCityId = productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .cityId
                                            .toString();
                                        selectedStateValue = productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .stateId
                                            .toString();
                                        selectedCityValue = productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .cityId
                                            .toString();
                                      } else {
                                        Utils.showToast(
                                            productProvider
                                                .getCustomerDetailUsingGSTData!
                                                .message!,
                                            context);
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
                                  businessProofDocId = null;
                                  selectedBusinessTypeValue = null;
                                  selectedStateValue = null;
                                  selectedCityValue = null;
                                  selectedMonthlySalesTurnoverValue = null;
                                  selectedChooseBusinessProofValue = null;
                                  isClearData = true;
                                  gstNumber = "";
                                  image = "";
                                  businessProofDocId = null;
                                  isGstFilled = false;
                                  companyStateId = null;
                                  companyCityId = null;
                                  selectedCompanyState = null;
                                  selectedCompanyCity = null;
                                  citylist.clear();
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
                        hintText: "Business Name(As Per Doc) ",
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
                        keyboardType: TextInputType.number,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                          LengthLimitingTextInputFormatter(6)
                        ],
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
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.keyboard_arrow_down),
                          ), // Down arrow icon when closed
                          openMenuIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.keyboard_arrow_up),
                          ), // Up arrow icon when open
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
                        items: _addDividersAfterItems(monthlySalesTurnoverList),
                        value: selectedMonthlySalesTurnoverValue,
                        onChanged: (String? value) {
                          selectedMonthlySalesTurnoverValue = value;
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.keyboard_arrow_down),
                          ), // Down arrow icon when closed
                          openMenuIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.keyboard_arrow_up),
                          ), // Up arrow icon when open
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        items: _addDividersAfterItems(chooseBusinessProofList),
                        value: selectedChooseBusinessProofValue,
                        onChanged: isGstFilled
                            ? null
                            : (String? value) {
                                setState(() {
                                  selectedChooseBusinessProofValue = value;
                                });
                              },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.keyboard_arrow_down),
                          ), // Down arrow icon when closed
                          openMenuIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.keyboard_arrow_up),
                          ), // Up arrow icon when open
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      selectedChooseBusinessProofValue ==
                              "Udyog Aadhaar Certificate"
                          ? TextField(
                              enabled: true,
                              controller: _businessDocumentNumberController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.characters,
                              maxLines: 1,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(19),
                                // Limit the input to 19 characters
                              ],
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  hintText: "UDYAM-XX-00-0000000",
                                  labelText: "Udyog Aadhaa Document",
                                  fillColor: textFiledBackgroundColour,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryColor, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  )),
                              onChanged: (value) {
                                String formattedInput = value.replaceAll(
                                    RegExp(r'[^A-Za-z0-9]'), '');
                                if (formattedInput.length >= 6 &&
                                    !formattedInput
                                        .substring(5, 6)
                                        .contains('-')) {
                                  formattedInput =
                                      formattedInput.substring(0, 5) +
                                          '-' +
                                          formattedInput.substring(5);
                                }

                                if (formattedInput.length >= 9 &&
                                    !formattedInput
                                        .substring(8, 9)
                                        .contains('-')) {
                                  formattedInput =
                                      formattedInput.substring(0, 8) +
                                          '-' +
                                          formattedInput.substring(8);
                                }

                                if (formattedInput.length >= 12 &&
                                    !formattedInput
                                        .substring(11, 12)
                                        .contains('-')) {
                                  formattedInput =
                                      formattedInput.substring(0, 11) +
                                          '-' +
                                          formattedInput.substring(11);
                                }
                                if (formattedInput.length > 19) {
                                  formattedInput =
                                      formattedInput.substring(0, 19);
                                }
                                _businessDocumentNumberController.value =
                                    TextEditingValue(
                                  text: formattedInput,
                                  selection: TextSelection.fromPosition(
                                    TextPosition(
                                        offset: formattedInput
                                            .length), // Maintain cursor position
                                  ),
                                );
                              },
                            )
                          : CommonTextField(
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
                                        ? image.contains(".pdf")
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.picture_as_pdf),
                                                ],
                                              )
                                            : ClipRRect(
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
                                                    BorderRadius.circular(8.0),
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
                          if (_businessNameController.text.trim().isEmpty) {
                            Utils.showToast(
                                "Please Enter Business Name (As Per Doc)",
                                context);
                          } else if (_addressLineController.text
                              .trim()
                              .isEmpty) {
                            Utils.showToast(
                                "Please Enter Address Line 1", context);
                          } else if (_addressLine2Controller.text
                              .trim()
                              .isEmpty) {
                            Utils.showToast(
                                "Please Enter Address Line 2", context);
                          } else if (_pinCodeController.text.trim().isEmpty) {
                            Utils.showToast("Please Enter Pin Code", context);
                          } else if (selectedStateValue == null) {
                            Utils.showToast("Please select state", context);
                          } else if (selectedCityValue == null) {
                            Utils.showToast("Please select city", context);
                          } else if (selectedBusinessTypeValue == null) {
                            Utils.showToast(
                                "Please Select Business Type", context);
                          } else if (selectedMonthlySalesTurnoverValue ==
                              null) {
                            Utils.showToast(
                                "Please Select Income Slab", context);
                          } else if (_businessDocumentNumberController.text
                              .trim()
                              .isEmpty) {
                            Utils.showToast(
                                "Please Enter Business Document Number",
                                context);
                          } else if (businessProofDocId == null) {
                            Utils.showToast("Please Select Proof", context);
                          } else if (slectedDate!.isEmpty) {
                            Utils.showToast(
                                "Please Select Incorporation Date", context);
                          } else {
                            await postLeadBuisnessDetail(
                                context, productProvider);

                            /* if (productProvider.getPostLeadBuisnessDetailData !=
                                null) {
                              if (productProvider
                                  .getPostLeadBuisnessDetailData!.isSuccess!) {
                                fetchData(context);
                              } else {
                                Utils.showToast(
                                    productProvider
                                        .getPostLeadBuisnessDetailData!.message!,
                                    context);
                              }
                            }*/
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
      ),
    );
  }

  Widget buildStateField(DataProvider productProvider) {
    if (productProvider.getAllStateData != null) {
      if (productProvider.getAllStateData != null) {
        var allStates = productProvider.getAllStateData!.returnObject!;
        if (companyStateId != null) {
          selectedCompanyState = allStates.firstWhere(
              (element) => element?.id == int.parse(companyStateId!),
              orElse: () => null);

          if (cityCallInitial) {
            citylist.clear();
            Provider.of<DataProvider>(context, listen: false)
                .getAllCity(int.parse(companyStateId!), context);
            cityCallInitial = false;
          }
        }
      }
      return DropdownButtonFormField2<ReturnObject?>(
        isExpanded: true,
        value: selectedCompanyState,
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
        onChanged: (ReturnObject? value) {
          setState(() {
            citylist.clear();
            setStateListFirstTime = false;
            Provider.of<DataProvider>(context, listen: false)
                .getAllCity(value!.id!, context);
            selectedStateValue = value.id!.toString();
            selectedCityValue = null;
            selectedCompanyCity = null;
            selectedCompanyState = value;
            companyCityId = null;
            companyStateId = null;
          });
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        ),
        iconStyleData: const IconStyleData(
          icon: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.keyboard_arrow_down),
          ), // Down arrow icon when closed
          openMenuIcon: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.keyboard_arrow_up),
          ), // Up arrow icon when open
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildCityField(DataProvider productProvider) {
    if (productProvider.getAllCityData != null &&
        productProvider.getAllCityData!.isNotEmpty) {
      citylist = productProvider.getAllCityData!;
      print("companyCityId:: ${companyCityId}");
      print("cityCallInitial:: ${cityCallInitial}");
      if (companyCityId != null) {
        selectedCompanyCity = citylist.firstWhere(
            (element) => element?.id == int.parse(companyCityId!),
            orElse: () => CityResponce());
      }
      return DropdownButtonFormField2<CityResponce>(
        isExpanded: true,
        value: selectedCompanyCity,
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
        onChanged: (CityResponce? value) {
          setState(() {
            selectedCompanyCity = value;
            setCityListFirstTime = false;
            selectedCityValue = value?.id.toString();
            companyCityId = null;
          });
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        ),
        iconStyleData: IconStyleData(
          icon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.keyboard_arrow_down),
          ), // Down arrow icon when closed
          openMenuIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.keyboard_arrow_up),
          ), // Up arrow icon when open
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
          /*// If it's not the last item, add Divider after it.
          if (item != list.last)
            const DropdownMenuItem<CityResponce>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),*/
        ],
      );
    }
    return menuItems;
  }

  Future<void> getCustomerDetailUsingGST(
      BuildContext context, String gstNumber) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getCustomerDetailUsingGST(gstNumber, context);
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> postLeadBuisnessDetail(
      BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();

    DateFormat inputFormat = DateFormat("MM/dd/yyyy");
    DateTime dateTime = inputFormat.parse(slectedDate.toString());
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    String formattedDate = outputFormat.format(dateTime);

    print(formattedDate); // Output: 2024-07-30
    var postLeadBuisnessDetailRequestModel = PostLeadBuisnessDetailRequestModel(
      leadId: prefsUtil.getInt(LEADE_ID),
      userId: prefsUtil.getString(USER_ID),
      activityId: widget.activityId,
      subActivityId: widget.subActivityId,
      busName: _businessNameController.text.trim().toString(),
      doi: formattedDate,
      busGSTNO: gstNumber,
      busEntityType: selectedBusinessTypeValue,
      busAddCorrLine1: _addressLineController.text.trim().toString(),
      busAddCorrLine2: _addressLine2Controller.text.trim().toString(),
      busAddCorrCity: selectedCompanyCity?.id.toString(),
      busAddCorrState: selectedCompanyState?.id.toString(),
      busAddCorrPincode: _pinCodeController.text.trim().toString(),
      buisnessMonthlySalary: 0,
      incomeSlab: selectedMonthlySalesTurnoverValue,
      companyId: prefsUtil.getInt(COMPANY_ID),
      buisnessDocumentNo:
          _businessDocumentNumberController.text.trim().toString(),
      buisnessProofDocId: businessProofDocId,
      buisnessProof: selectedChooseBusinessProofValue,
      inquiryAmount: 0,
      surrogateType: null,
    );

    debugPrint("Post DATA:: ${postLeadBuisnessDetailRequestModel.toJson()}");
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postLeadBuisnessDetail(postLeadBuisnessDetailRequestModel);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getPostLeadBuisnessDetailData != null) {
      productProvider.getPostLeadBuisnessDetailData!.when(
        success: (data) {
          // Handle successful response
          if (data.isSuccess != null) {
            if (data.isSuccess!) {
              fetchData(context);
            } else {
              Utils.showToast(data.message!, context);
            }
          }
        },
        failure: (exception) {
          // Handle failure
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            } else {
              Utils.showToast("Something went wrong...", context);
            }
          }
        },
      );
    }
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerFileWidgets(onImageSelected: _onImageSelected);
        });
  }

  Future<void> getPersonalDetailAndStateApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);

    await Provider.of<DataProvider>(context, listen: false)
        .getLeadBusinessDetail(userId!, productCode!, context);
    await Provider.of<DataProvider>(context, listen: false)
        .getAllState(context);
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

      customerSequence(
          context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
