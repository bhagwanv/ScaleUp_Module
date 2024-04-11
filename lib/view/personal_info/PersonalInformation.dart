import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/api/ApiService.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/common_elevted_button.dart';
import 'package:scale_up_module/utils/constants.dart';
import 'package:scale_up_module/view/business_details/business_details.dart';
import 'package:scale_up_module/view/personal_info/EmailOtpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/common_check_box.dart';
import '../../utils/loader.dart';
import 'model/AllStateResponce.dart';
import 'model/CityResponce.dart';
import 'model/EmailExistRespoce.dart';
import 'model/ReturnObject.dart';
import 'model/SendOtpOnEmailResponce.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final TextEditingController _firstNameCl = TextEditingController();
  final TextEditingController _middleNameCl = TextEditingController();
  final TextEditingController _lastNameCl = TextEditingController();
  final TextEditingController _alternatePhoneNumberCl = TextEditingController();
  final TextEditingController _emailIDCl = TextEditingController();
  final TextEditingController _genderCl = TextEditingController();
  final TextEditingController _stateNameCl = TextEditingController();
  final TextEditingController _cityNameCl = TextEditingController();
  final TextEditingController _permanentAddresslineOneCl =
      TextEditingController();
  final TextEditingController _permanentAddresslineTwoCl =
      TextEditingController();
  final TextEditingController _permanentAddressPinCodeCl =
      TextEditingController();
  final TextEditingController _permanentAddressCity = TextEditingController();
  final TextEditingController _permanentAddressStateCl =
      TextEditingController();
  final TextEditingController _permanentAddressCountryCl =
      TextEditingController();

  final TextEditingController _currentAddressLineOneCl =
      TextEditingController();
  final TextEditingController _currentAddressLineTwoCl =
      TextEditingController();
  final TextEditingController _currentAddressPinCodeCl =
      TextEditingController();
  final TextEditingController _currentAddressCity = TextEditingController();
  final TextEditingController _currentAddressStateCl = TextEditingController();
  final TextEditingController _currentAddressCountryCl =
      TextEditingController();
  String? selectedGenderValue;
  String? selectedMaritalStatusValue;
  bool ischeckCurrentAdress = true;
  List<CityResponce?> citylist = [];
  List<ReturnObject> filteredStates = [];
  var isLoading = true;
  late int selectedStateID;
  var stateId = 0;
  var isEmailClear = false;
  var isValidEmail = false;
  final List<String> genderList = [
    'Male',
    'Female',
  ];

  final List<String> maritalList = [
    'Married',
    'UnMarried',
    'Widow',
  ];
  var cityCallInitial = true;
  var isCurrentAddSame = false;

  @override
  void initState() {
    super.initState();
    callApi(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(child: Scaffold(
      body: Consumer<DataProvider>(builder: (context, productProvider, child) {
        if (productProvider.getPersonalDetailsData == null && isLoading) {
          return Center(child: Loader());
        } else {
          if (productProvider.getPersonalDetailsData != null && isLoading) {
            Navigator.of(context, rootNavigator: true).pop();
            isLoading = false;
          }
          _firstNameCl.text =
              productProvider.getPersonalDetailsData!.firstName!;
          if (productProvider.getPersonalDetailsData!.middleName != null) {
            _middleNameCl.text =
                productProvider.getPersonalDetailsData!.middleName!;
          }
          _lastNameCl.text = productProvider.getPersonalDetailsData!.lastName!;
          _alternatePhoneNumberCl.text =
              productProvider.getPersonalDetailsData!.alternatePhoneNo!;

          if (productProvider.getPersonalDetailsData!.emailId!.isNotEmpty &&
              !isEmailClear) {
            _emailIDCl.text = productProvider.getPersonalDetailsData!.emailId!;
          } else if(!isValidEmail){
            _emailIDCl.clear();
          }

          if (productProvider.getPersonalDetailsData!.gender == "M") {
            _genderCl.text = "Male";
          } else {
            _genderCl.text = "Female";
          }

          if (productProvider.getPersonalDetailsData!.permanentAddressLine1 ==
                  productProvider.getPersonalDetailsData!.resAddress1 &&
              productProvider.getPersonalDetailsData!.permanentAddressLine2 ==
                  productProvider.getPersonalDetailsData!.resAddress2) {
            isCurrentAddSame = true;
          }

          _permanentAddresslineOneCl.text =
              productProvider.getPersonalDetailsData!.permanentAddressLine1!;
          _permanentAddresslineTwoCl.text =
              productProvider.getPersonalDetailsData!.permanentAddressLine2!;
          _permanentAddressPinCodeCl.text = productProvider
              .getPersonalDetailsData!.permanentPincode!
              .toString();
          //_permanentAddressCity.text= productProvider.getPersonalDetailsData!.permanentCity;
          // _permanentAddressStateCl.text= productProvider.getPersonalDetailsData!.lastName!;
          // _permanentAddressCountryCl.text= productProvider.getPersonalDetailsData!.c!;

          // _currentAddressLineOneCl.text =productProvider.getPersonalDetailsData!.resAddress1!;
          // _currentAddressLineTwoCl.text =productProvider.getPersonalDetailsData!.resAddress2!;
          // _currentAddressPinCodeCl.text =productProvider.getPersonalDetailsData!.pincode!.toString();
          //_currentAddressCity.text= productProvider.getPersonalDetailsData!.lastName!;
          //_currentAddressStateCl.text= productProvider.getPersonalDetailsData!.lastName!;
          //_currentAddressCountryCl.text= productProvider.getPersonalDetailsData!.lastName!;

          if (productProvider.getPersonalDetailsData!.state != null) {
            stateId = productProvider.getPersonalDetailsData!.state!;
            print("stateId ${stateId!}");
          }

          if (productProvider.getAllCityData != null) {
            citylist = productProvider.getAllCityData!;
          }

          return SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  'Personal Information',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 35, color: Colors.black),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      TextField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: _firstNameCl,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        canRequestFocus: true,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "First Name",
                            labelText: "First Name",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: _middleNameCl,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Middle Name",
                            labelText: "Middle Name",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: _lastNameCl,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Last Name",
                            labelText: "Last Name",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: _genderCl,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Gender",
                            labelText: "Gender",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          fillColor: textFiledBackgroundColour,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 1),
                          ),
                        ),
                        hint: const Text(
                          'marital Status',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: getDropDownOption(maritalList),
                        value: selectedMaritalStatusValue,
                        onChanged: (String? value) {
                          /* setState(() {
                          selectedAccountTypeValue = value;
                        });*/
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          customHeights: _getCustomItemsHeights(maritalList),
                        ),
                        iconStyleData: const IconStyleData(
                          openMenuIcon: Icon(Icons.arrow_drop_up),
                        ),
                      ),
                      SizedBox(height: 15),
                      Stack(
                        children: [
                          TextField(
                            enabled: !isValidEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            controller: _emailIDCl,
                            maxLines: 1,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: kPrimaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              hintText: "E-mail ID",
                              labelText: "E-mail ID",
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
                          _emailIDCl.text.isNotEmpty ? Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              child: IconButton(
                                onPressed: () => setState(() {
                                  isEmailClear = true;
                                  isValidEmail = false;
                                  _emailIDCl.clear();
                                }),
                                icon: SvgPicture.asset(
                                  'assets/icons/email_cross.svg',
                                  semanticsLabel: 'My SVG Image',
                                ),
                              ),
                            ),
                          ) : Container(),
                        ],
                      ),
                      SizedBox(height: 15),
                      (!isEmailClear && _emailIDCl.text.isNotEmpty)
                          ? Container(
                              child: Text(
                                'Verify',
                                style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () async {
                                  if (_emailIDCl.text.isEmpty) {
                                    Utils.showToast("Please Enter Email ID");
                                  } else if (!Utils.validateEmail(
                                      _emailIDCl.text)) {
                                    Utils.showToast(
                                        "Please Enter Valid Email ID");
                                  } else {
                                    callEmailIDExist(context, _emailIDCl.text);
                                  }
                                },
                                child: Text(
                                  'Click here to Verify',
                                  style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue),
                                ),
                              )),
                      SizedBox(height: 15),
                      TextField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: _alternatePhoneNumberCl,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Alternate Phone Number   ",
                            labelText: "Alternate Phone Number",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Permanent Address',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        enabled: false,
                        controller: _permanentAddresslineOneCl,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Address line 1",
                            labelText: "Address line 1",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        enabled: false,
                        controller: _permanentAddresslineTwoCl,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Address line 2",
                            labelText: "Address line 2",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        enabled: false,
                        controller: _permanentAddressPinCodeCl,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Pin Code*",
                            labelText: "Pin Code*",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      const SizedBox(height: 15),
                      /* productProvider.getPersonalDetailsData!.state == null
                          ? DropdownButtonFormField2<ReturnObject>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1),
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
                              items: getAllState(productProvider.getAllStateData?.returnObject?),
                              onChanged: (ReturnObject? value) {
                                setState(() {
                                  citylist.clear();
                                  Provider.of<DataProvider>(context,
                                          listen: false)
                                      .getAllCity(value!.id!);
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
                                customHeights: _getCustomItemsHeights2(
                                    productProvider
                                        .getAllStateData!.returnObject!),
                              ),
                              iconStyleData: const IconStyleData(
                                openMenuIcon: Icon(Icons.arrow_drop_up),
                              ),
                            )
                          : TextField(
                              enabled: false,
                              controller: _stateNameCl,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  hintText: "State",
                                  labelText: "State",
                                  fillColor: textFiledBackgroundColour,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryColor, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  )),
                            ),*/
                      buildStateField(productProvider),
                      const SizedBox(height: 15),
                      citylist!.isNotEmpty
                          ? buildCityField(productProvider)
                          : Container(),
                      const SizedBox(height: 15),
                      citylist.isNotEmpty
                          ? DropdownButtonFormField2<CityResponce>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1),
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
                                /* setState(() {
                                   });*/
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
                                    _getCustomItemsHeights3(citylist),
                              ),
                              iconStyleData: const IconStyleData(
                                openMenuIcon: Icon(Icons.arrow_drop_up),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Current Address',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 15),
                      CommonCheckBox(
                        isChecked: isCurrentAddSame,
                        onChanged: (bool isChecked) {
                          setState(() {
                            isCurrentAddSame = isChecked;
                            if (isChecked) {
                              print("Check${isChecked}");
                              ischeckCurrentAdress = false;
                              _currentAddressLineOneCl.text = productProvider
                                  .getPersonalDetailsData!
                                  .permanentAddressLine1!;
                              _currentAddressLineTwoCl.text = productProvider
                                  .getPersonalDetailsData!
                                  .permanentAddressLine2!;
                              _currentAddressPinCodeCl.text = productProvider
                                  .getPersonalDetailsData!.permanentPincode!
                                  .toString();
                              //_currentAddressCity.text= productProvider.getPersonalDetailsData!.lastName!;
                              //_currentAddressStateCl.text= productProvider.getPersonalDetailsData!.lastName!;
                              //_currentAddressCountryCl.text= productProvider.getPersonalDetailsData!.lastName!;
                            } else {
                              ischeckCurrentAdress = true;
                              _currentAddressLineOneCl.clear();
                              _currentAddressLineTwoCl.clear();
                              _currentAddressPinCodeCl.clear();
                            }
                          });
                        },
                        text: "Same as Permanent address",
                        upperCase: false,
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        enabled: ischeckCurrentAdress,
                        controller: _currentAddressLineOneCl,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Address line 1",
                            labelText: "Address line 1",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        enabled: ischeckCurrentAdress,
                        controller: _permanentAddresslineTwoCl,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Address line 2",
                            labelText: "Address line 2",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        enabled: ischeckCurrentAdress,
                        controller: _currentAddressPinCodeCl,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Pin Code*",
                            labelText: "Pin Code*",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        enabled: ischeckCurrentAdress,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "State*",
                            labelText: "State*",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        enabled: ischeckCurrentAdress,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "City*",
                            labelText: "City*",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        enabled: ischeckCurrentAdress,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Country",
                            labelText: "Country",
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                      ),
                      const SizedBox(height: 50),
                      CommonElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const BusinessDetails();
                              },
                            ),
                          );
                        },
                        text: "NEXT",
                        upperCase: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
        }
      }),
    ));
  }

  void callSendOptEmail(BuildContext context, String emailID) async {
    SendOtpOnEmailResponce data;
    data = await ApiService().sendOtpOnEmail(emailID) as SendOtpOnEmailResponce;

    if (data != null && data.status!) {
      Utils.showToast(data.message!);
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmailOtpScreen(
                    emailID: emailID,
                  )));

      if (result != null &&
          result.containsKey('isValid') &&
          result.containsKey('Email')) {
        isValidEmail = result['isValid'];
        _emailIDCl.text = result['Email'];
        setState(() {
        });
      } else {
        print('Result is null or does not contain expected keys');
      }
    } else {
      Utils.showToast(data.message!);
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  void callEmailIDExist(BuildContext context, String emailID) async {
    Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    EmailExistRespoce data;
    data = await ApiService().emailExist(userId!, emailID) as EmailExistRespoce;
    if (data.isSuccess!) {
      Utils.showToast(data.message!);
    } else {
      callSendOptEmail(context, _emailIDCl.text);
    }
  }

  List<DropdownMenuItem<String>> getDropDownOption(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
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
          // If it's not the last item, add Divider after it.
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

  Widget buildStateField(DataProvider productProvider) {
    if (productProvider.getPersonalDetailsData!.permanentState != null) {
      var allStates = productProvider.getAllStateData!.returnObject!;
      var initialData = allStates.firstWhere(
          (element) =>
              element?.id ==
              productProvider.getPersonalDetailsData!.permanentState,
          orElse: () => null);
      _stateNameCl.text = initialData!.name!;
      if (productProvider.getPersonalDetailsData!.permanentState != null) {
        if (productProvider.getPersonalDetailsData!.permanentCity != null &&
            cityCallInitial) {
          citylist.clear();
          Provider.of<DataProvider>(context, listen: false).getAllCity(
              productProvider.getPersonalDetailsData!.permanentState!);
          cityCallInitial = false;
        }
      }
      return TextField(
        enabled: false,
        controller: _stateNameCl,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLines: 1,
        cursorColor: Colors.black,
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: kPrimaryColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            hintText: "State",
            labelText: "State",
            fillColor: textFiledBackgroundColour,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )),
      );
    } else {
      return Container();
    }
  }

  Widget buildCityField(DataProvider productProvider) {
    if (productProvider.getPersonalDetailsData!.permanentCity != null) {
      var initialData = productProvider.getAllCityData!.firstWhere(
          (element) =>
              element?.id ==
              productProvider.getPersonalDetailsData!.permanentCity,
          orElse: () => CityResponce());

      _cityNameCl.text = initialData!.name!;

      return TextField(
        enabled: false,
        controller: _cityNameCl,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLines: 1,
        cursorColor: Colors.black,
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: kPrimaryColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            hintText: "City",
            labelText: "City",
            fillColor: textFiledBackgroundColour,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )),
      );
    } else {
      return Container();
    }
  }

  Future<void> callApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? leadId = prefsUtil.getString(USER_ID);
    Provider.of<DataProvider>(context, listen: false)
        .getLeadPersonalDetails(leadId!);
    Provider.of<DataProvider>(context, listen: false).getAllState();
  }
}
