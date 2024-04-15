import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/api/ApiService.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/common_elevted_button.dart';
import 'package:scale_up_module/utils/constants.dart';
import 'package:scale_up_module/view/personal_info/EmailOtpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/common_check_box.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../login_screen/login_screen.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/AllStateResponce.dart';
import 'model/CityResponce.dart';
import 'model/EmailExistRespoce.dart';
import 'model/PersonalDetailsRequestModel.dart';
import 'model/ReturnObject.dart';
import 'model/SendOtpOnEmailResponce.dart';

class PersonalInformation extends StatefulWidget {
  int? activityId;
  int? subActivityId;
  String image = "";

  PersonalInformation(
      {required this.activityId, required this.subActivityId, super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  //basic details
  final TextEditingController _firstNameCl = TextEditingController();
  final TextEditingController _middleNameCl = TextEditingController();
  final TextEditingController _lastNameCl = TextEditingController();
  final TextEditingController _genderCl = TextEditingController();
  final TextEditingController _emailIDCl = TextEditingController();
  final TextEditingController _alternatePhoneNumberCl = TextEditingController();
  final TextEditingController _countryCl = TextEditingController();
  String? selectedGenderValue;
  String? selectedMaritalStatusValue;
  final List<String> genderList = [
    'Male',
    'Female',
  ];
  final List<String> maritalList = [
    'Married',
    'UnMarried',
    'Widow',
  ];

  //permanent Address
  final TextEditingController _permanentStateNameCl = TextEditingController();
  final TextEditingController _permanentCityNameCl = TextEditingController();
  final TextEditingController _permanentAddressPinCodeCl =
      TextEditingController();
  final TextEditingController _permanentAddresslineOneCl =
      TextEditingController();
  final TextEditingController _permanentAddresslineTwoCl =
      TextEditingController();
  List<CityResponce?> permanentCitylist = [];

  //current Address
  final TextEditingController _currentAddressLineOneCl =
      TextEditingController();
  final TextEditingController _currentAddressLineTwoCl =
      TextEditingController();
  final TextEditingController _currentAddressPinCodeCl =
      TextEditingController();
  List<CityResponce?> citylist = [];
  ReturnObject? selectedCurrentState;
  CityResponce? selectedCurrentCity;

  //ownership type
  String? selectedOwnershipTypeValue = "";
  final List<String> ownershipTypeList = [
    'Owned',
    'Owned by parents',
    'Owned by Spouse',
    'Rented',
  ];

  String? selectOwnershipProofValue;
  final List<String> ownershipProofList = [
    'Electricity Manual Bill Upload ',
  ];

  bool ischeckCurrentAdress = true;
  var isLoading = true;
  late int selectedStateID;
  var stateId = 0;
  var isEmailClear = false;
  var isValidEmail = false;
  var cityCallInitial = true;
  var isCurrentAddSame = false;
  var updateData = false;

  @override
  void initState() {
    super.initState();
    getPersonalDetailAndStateApi(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child:
            Consumer<DataProvider>(builder: (context, productProvider, child) {
          if (productProvider.getPersonalDetailsData == null && isLoading) {
            return Center(child: Loader());
          } else {
            if (productProvider.getPersonalDetailsData != null && isLoading) {
              Navigator.of(context, rootNavigator: true).pop();
              isLoading = false;
            }

            if (!updateData) {
              _countryCl.text = "India";

              _firstNameCl.text =
                  productProvider.getPersonalDetailsData!.firstName!;
              if (productProvider.getPersonalDetailsData!.middleName != null) {
                _middleNameCl.text =
                    productProvider.getPersonalDetailsData!.middleName!;
              }
              _lastNameCl.text =
                  productProvider.getPersonalDetailsData!.lastName!;

              if (productProvider.getPersonalDetailsData!.emailId!.isNotEmpty) {
                _emailIDCl.text =
                    productProvider.getPersonalDetailsData!.emailId!;
              }

              if (productProvider.getPersonalDetailsData!.gender == "M") {
                _genderCl.text = "Male";
              } else if (productProvider.getPersonalDetailsData!.gender ==
                  "F") {
                _genderCl.text = "Female";
              } else {
                _genderCl.text = "Other";
              }

              if (productProvider.getPersonalDetailsData!.marital!.isNotEmpty) {
                if (productProvider.getPersonalDetailsData!.marital == "M") {
                  selectedMaritalStatusValue = "Married";
                } else if (productProvider.getPersonalDetailsData!.gender ==
                    "UM") {
                  selectedMaritalStatusValue = "UnMarried";
                } else {
                  selectedMaritalStatusValue = "Widow";
                }
              }

              //set permanent Address
              if (productProvider
                  .getPersonalDetailsData!.permanentAddressLine1!.isNotEmpty) {
                _permanentAddresslineOneCl.text = productProvider
                    .getPersonalDetailsData!.permanentAddressLine1!;
              }

              if (productProvider
                  .getPersonalDetailsData!.permanentAddressLine2!.isNotEmpty) {
                _permanentAddresslineTwoCl.text = productProvider
                    .getPersonalDetailsData!.permanentAddressLine2!;
              }

              if (productProvider.getPersonalDetailsData!.permanentPincode !=
                  null) {
                _permanentAddressPinCodeCl.text = productProvider
                    .getPersonalDetailsData!.permanentPincode!
                    .toString();
              }

              if (productProvider
                          .getPersonalDetailsData!.permanentAddressLine1 ==
                      productProvider.getPersonalDetailsData!.resAddress1 &&
                  productProvider
                          .getPersonalDetailsData!.permanentAddressLine2 ==
                      productProvider.getPersonalDetailsData!.resAddress2) {
                isCurrentAddSame = true;
              }

              //set Current Address
              if (productProvider
                  .getPersonalDetailsData!.resAddress1!.isNotEmpty) {
                _currentAddressLineOneCl.text =
                    productProvider.getPersonalDetailsData!.resAddress1!;
              }
              if (productProvider
                  .getPersonalDetailsData!.resAddress2!.isNotEmpty) {
                _currentAddressLineTwoCl.text =
                    productProvider.getPersonalDetailsData!.resAddress2!;
              }
              if (productProvider.getPersonalDetailsData!.pincode != null) {
                _currentAddressPinCodeCl.text =
                    productProvider.getPersonalDetailsData!.pincode!.toString();
              }

              if (productProvider.getPersonalDetailsData!.state != null) {
                stateId = productProvider.getPersonalDetailsData!.state!;
              }

              if (productProvider.getAllCityData != null) {
                permanentCitylist = productProvider.getAllCityData!;
              }

              if (productProvider.getCurrentAllCityData != null) {
                citylist = productProvider.getCurrentAllCityData!;
              }
            } else {
              if (!isEmailClear && !isValidEmail) {
                _emailIDCl.text =
                    productProvider.getPersonalDetailsData!.emailId!;
              } else if (!isValidEmail) {
                _emailIDCl.clear();
              }

              if (productProvider.getAllCityData != null) {
                permanentCitylist = productProvider.getAllCityData!;
              }

              if (productProvider.getCurrentAllCityData != null) {
                citylist = productProvider.getCurrentAllCityData!;
              }
              if (citylist.isNotEmpty) {
                selectedCurrentCity = citylist.first;
                print("dsds" + selectedCurrentCity!.name!);
              }
            }

            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Personal Information',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 35, color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        basicDetailsFields(productProvider),
                        const SizedBox(height: 20),
                        permanentAddressField(productProvider),
                        currentAddressFields(productProvider),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Ownership Type",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 8),
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
                            'Ownership Type',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items: getDropDownOption(ownershipTypeList),
                          value: selectedOwnershipTypeValue!.isNotEmpty
                              ? selectedOwnershipTypeValue
                              : null,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOwnershipTypeValue = value;
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
                                _getCustomItemsHeights(ownershipTypeList),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                        const SizedBox(height: 15),
                        (selectedOwnershipTypeValue!.isNotEmpty &&
                                selectedOwnershipTypeValue == "Rented")
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      "Ownership Proof",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
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
                                        borderSide: BorderSide(
                                            color: kPrimaryColor, width: 1),
                                      ),
                                    ),
                                    hint: const Text(
                                      'Select Ownership Proof',
                                      style: TextStyle(
                                        color: blueColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    items:
                                        getDropDownOption(ownershipProofList),
                                    value: selectOwnershipProofValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectOwnershipProofValue = value;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                      maxHeight: 200,
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      customHeights: _getCustomItemsHeights(
                                          ownershipProofList),
                                    ),
                                    iconStyleData: const IconStyleData(
                                      openMenuIcon: Icon(Icons.arrow_drop_up),
                                    ),
                                  ),
                                  SizedBox(height: 15),
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
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: (productProvider
                                                      .getPostSingleFileData !=
                                                  null)
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    productProvider
                                                        .getPostSingleFileData!
                                                        .filePath!,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 148,
                                                  ),
                                                )
                                              : (widget.image.isNotEmpty)
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        widget.image,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 148,
                                                      ),
                                                    )
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                            child: SvgPicture.asset(
                                                                "assets/icons/gallery.svg",
                                                                colorFilter: const ColorFilter
                                                                    .mode(
                                                                    kPrimaryColor,
                                                                    BlendMode
                                                                        .srcIn))),
                                                        const Text(
                                                          'Upload Bill',
                                                          style: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Supports : JPEG, PNG',
                                                          style: TextStyle(
                                                            color: blackSmall,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                        ),
                                        onTap: () {
                                          bottomSheetMenu(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 50),
                        CommonElevatedButton(
                          onPressed: () async {
                            ValidationResult result =
                                await validateData(context, productProvider);
                            PersonalDetailsRequestModel postData =
                                result.postData;
                            bool isValid = result.isValid;
                            if (isValid) {
                              submitPersonalInformationApi(
                                  context, productProvider, postData);
                            } else {
                              print("unValid");
                            }
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
      ),
    );
  }

  void submitPersonalInformationApi(
      BuildContext context,
      DataProvider productProvider,
      PersonalDetailsRequestModel postData) async {
    Utils.onLoading(context, "Wait...");
    await productProvider.postLeadPersonalDetail(postData);
    if (productProvider.getPostPersonalDetailsResponseModel?.statusCode != 401) {
      if (productProvider.getPostPersonalDetailsResponseModel != null) {
        Navigator.of(context, rootNavigator: true).pop();
        if(productProvider.getPostPersonalDetailsResponseModel!.isSuccess!) {
          if (productProvider.getPostPersonalDetailsResponseModel!.message != null) {
            Utils.showToast(
                " ${productProvider.getPostPersonalDetailsResponseModel!.message!}");
          }
          fetchData(context);
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              const LoginScreen(activityId: 1, subActivityId: 0),
        ),
        (route) => false, //if you want to disable back feature set to false
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
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId:widget.activityId,
        subActivityId: widget.subActivityId,
        userId:  prefsUtil.getString(USER_ID),
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

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData);
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

  void callSendOptEmail(BuildContext context, String emailID) async {
    updateData = true;
    SendOtpOnEmailResponce data;
    data = await ApiService().sendOtpOnEmail(emailID);

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
        setState(() {
          isValidEmail = result['isValid'];
          _emailIDCl.text = result['Email'];
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

  List<DropdownMenuItem<CityResponce>> getCurrentAllCity(
      List<CityResponce?> list) {
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
      _permanentStateNameCl.text = initialData!.name!;
      if (productProvider.getPersonalDetailsData!.permanentState != null) {
        if (productProvider.getPersonalDetailsData!.permanentCity != null &&
            cityCallInitial) {
          permanentCitylist.clear();
          Provider.of<DataProvider>(context, listen: false).getAllCity(
              productProvider.getPersonalDetailsData!.permanentState!);
          cityCallInitial = false;
        }
      }
      return TextField(
        enabled: false,
        controller: _permanentStateNameCl,
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

      _permanentCityNameCl.text = initialData!.name!;

      return TextField(
        enabled: false,
        controller: _permanentCityNameCl,
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

  Future<void> getPersonalDetailAndStateApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? leadId = prefsUtil.getString(USER_ID);
    Provider.of<DataProvider>(context, listen: false)
        .getLeadPersonalDetails(leadId!);
    Provider.of<DataProvider>(context, listen: false).getAllState();
  }

  Widget permanentAddressField(DataProvider productProvider) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Permanent Address',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
        const SizedBox(height: 15),
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Address line 1",
              labelText: "Address line 1",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Address line 2",
              labelText: "Address line 2",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Pin Code*",
              labelText: "Pin Code*",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        buildStateField(productProvider),
        const SizedBox(height: 15),
        permanentCitylist!.isNotEmpty
            ? buildCityField(productProvider)
            : Container(),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          controller: _countryCl,
          keyboardType: TextInputType.text,
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
              hintText: "Country",
              labelText: "Country",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget basicDetailsFields(DataProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "First Name",
              labelText: "First Name",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Middle Name",
              labelText: "Middle Name",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Last Name",
              labelText: "Last Name",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Gender",
              labelText: "Gender",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            "Martial Status",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            fillColor: textFiledBackgroundColour,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: kPrimaryColor, width: 1),
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
            setState(() {
              selectedMaritalStatusValue = value;
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
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: "E-mail ID",
                labelText: "E-mail ID",
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            _emailIDCl.text.isNotEmpty
                ? Positioned(
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
                  )
                : Container(),
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
                    } else if (!Utils.validateEmail(_emailIDCl.text)) {
                      Utils.showToast("Please Enter Valid Email ID");
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
          maxLength: 10,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Alternate Phone Number",
              labelText: "Alternate Phone Number",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
      ],
    );
  }

  Widget currentAddressFields(DataProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
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
              updateData = true;
              if (isChecked) {
                print("Check${isChecked}");
                ischeckCurrentAdress = false;
                _currentAddressLineOneCl.text = productProvider
                    .getPersonalDetailsData!.permanentAddressLine1!;
                _currentAddressLineTwoCl.text = productProvider
                    .getPersonalDetailsData!.permanentAddressLine2!;
                _currentAddressPinCodeCl.text = productProvider
                    .getPersonalDetailsData!.permanentPincode!
                    .toString();
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Address line 1",
              labelText: "Address line 1",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: ischeckCurrentAdress,
          controller: _currentAddressLineTwoCl,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Address line 2",
              labelText: "Address line 2",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Pin Code*",
              labelText: "Pin Code*",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        isCurrentAddSame
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildStateField(productProvider),
                  const SizedBox(height: 15),
                  permanentCitylist.isNotEmpty
                      ? buildCityField(productProvider)
                      : Container(),
                  const SizedBox(height: 15),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField2<ReturnObject>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      fillColor: textFiledBackgroundColour,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: kPrimaryColor, width: 1),
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
                    items: getAllState(
                        productProvider.getAllStateData!.returnObject!),
                    onChanged: (ReturnObject? value) {
                      setState(() {
                        selectedCurrentCity = null;
                        selectedCurrentState = value;
                        citylist.clear();
                        Provider.of<DataProvider>(context, listen: false)
                            .getCurrentAllCity(value!.id!);
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
                      customHeights: _getCustomItemsHeights2(
                          productProvider.getAllStateData!.returnObject!),
                    ),
                    iconStyleData: const IconStyleData(
                      openMenuIcon: Icon(Icons.arrow_drop_up),
                    ),
                  ),
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
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1),
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
                          items: getCurrentAllCity(citylist),
                          onChanged: (CityResponce? value) {
                            setState(() {
                              selectedCurrentCity = value;
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
                            customHeights: _getCustomItemsHeights3(citylist),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        )
                      : Container(),
                ],
              ),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          controller: _countryCl,
          keyboardType: TextInputType.text,
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
              hintText: "Country",
              labelText: "Country",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
      ],
    );
  }

  Future<ValidationResult> validateData(
      BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final int? companyId = prefsUtil.getInt(COMPANY_ID);

    var currentStateId = "";
    var currentCityId = "";

    //address
    if (isCurrentAddSame) {
      currentStateId =
          productProvider.getPersonalDetailsData!.permanentState!.toString();
      currentCityId =
          productProvider.getPersonalDetailsData!.permanentCity!.toString();
    } else {
      if (selectedCurrentState != null) {
        currentStateId = selectedCurrentState!.id.toString();
      }
      if (selectedCurrentCity != null) {
        currentCityId = selectedCurrentCity!.id.toString();
      }
    }

    //bill
    int? billDocId;

    if (productProvider.getPostSingleFileData != null) {
      billDocId = productProvider.getPostSingleFileData!.docId!;
    }

    PersonalDetailsRequestModel postData = PersonalDetailsRequestModel(
        firstName: _firstNameCl.text.toString(),
        lastName: _lastNameCl.text.toString(),
        fatherName: productProvider.getPersonalDetailsData!.fatherName!,
        fatherLastName: productProvider.getPersonalDetailsData!.fatherLastName!,
        dOB: "",
        alternatePhoneNo: _alternatePhoneNumberCl.text.toString(),
        emailId: _emailIDCl.text.toString(),
        typeOfAddress: "",
        permanentAddressLine1:
            productProvider.getPersonalDetailsData!.permanentAddressLine1!,
        permanentAddressLine2:
            productProvider.getPersonalDetailsData!.permanentAddressLine2!,
        permanentPincode: productProvider
            .getPersonalDetailsData!.permanentPincode!
            .toString(),
        permanentCity:
            productProvider.getPersonalDetailsData!.permanentCity!.toString(),
        permanentState:
            productProvider.getPersonalDetailsData!.permanentState!.toString(),
        pincode: _currentAddressPinCodeCl.text.toString(),
        state: currentStateId,
        city: currentCityId,
        residenceStatus: "",
        leadId: leadId,
        userId: userId,
        activityId: widget.activityId!,
        subActivityId: widget.subActivityId!,
        middleName: _middleNameCl.text.toString(),
        companyId: companyId,
        mobileNo: productProvider.getPersonalDetailsData!.mobileNo!.toString(),
        ownershipType: selectedOwnershipTypeValue,
        ownershipTypeAddress: "",
        ownershipTypeProof: selectOwnershipProofValue,
        electricityBillDocumentId: billDocId,
        ownershipTypeName: "",
        ownershipTypeResponseId: 0);

    bool isValid = false;
    String errorMessage = "";

    if (_firstNameCl.text.toString().isEmpty) {
      errorMessage = "First name should not be empty";
      isValid = false;
    } else if (_lastNameCl.text.toString().isEmpty) {
      errorMessage = "Last name should not be empty";
      isValid = false;
    } else if (_alternatePhoneNumberCl.text.toString().isEmpty) {
      errorMessage = "Alternate Mobile Number should not be empty";
      isValid = false;
    } else if (_emailIDCl.text.toString().isEmpty) {
      errorMessage = "Email should not be empty";
      isValid = false;
    } else if (userId!.isEmpty) {
      errorMessage = "User Id should not be empty";
      isValid = false;
    } else if (selectedMaritalStatusValue == null) {
      errorMessage = "Martial Status should not be empty";
      isValid = false;
    } else if (currentStateId.isEmpty) {
      errorMessage = "Current State is required";
      isValid = false;
    } else if (currentStateId.isEmpty) {
      errorMessage = "Current City is required";
      isValid = false;
    } else if (selectedOwnershipTypeValue != "Rented" && billDocId == null) {
      errorMessage = "Add Electricity Bill Document";
      isValid = false;
    } else if (!isValidEmail) {
      errorMessage = "Verify Email ";
      isValid = false;
    } else {
      isValid = true;
    }

    if (errorMessage.isNotEmpty) {
      Utils.showToast(errorMessage.toString());
    }

    print("postData::: " + postData.toString());
    return ValidationResult(postData, isValid);
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
  }

  // Callback function to receive the selected image
  void _onImageSelected(File imageFile) async {
    Utils.onLoading(context, "");
    // Perform asynchronous work first
    await Provider.of<DataProvider>(context, listen: false)
        .postSingleFile(imageFile, true, "", "");

    // Update the widget state synchronously inside setState
    setState(() {
      // Clear loading indicator
      Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }
}

class ValidationResult {
  final PersonalDetailsRequestModel postData;
  final bool isValid;

  ValidationResult(this.postData, this.isValid);
}
