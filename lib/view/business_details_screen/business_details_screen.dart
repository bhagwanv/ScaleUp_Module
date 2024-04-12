import 'dart:io';

import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/utils/common_text_field.dart';
import 'package:scale_up_module/view/profile_screen/ProfileReview.dart';

import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';
import '../../utils/loader.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/PostLeadBuisnessDetailRequestModel.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetailsScreen> {
  var isLoading = true;
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _businessIncorporationDateController = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _BusinessDocumentNumberController = TextEditingController();

  var isEnabledGST = true;
  var gstNumber = "";
  var image="";




  @override
  void initState() {
    super.initState();
    //Api Call
    callApi(context);
  }

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
    'Above 25 Lacs '
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

  DateTime date = DateTime.now().subtract(Duration(days: 1));

  String minDateTime = '2010-05-12';
  String maxDateTime = '2030-11-25';
  String initDateTime = '2021-08-31';

  bool _showTitle = true;

  DateTimePickerLocale? _locale = DateTimePickerLocale.en_us;
  final List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;

  String _format = 'yyyy-MMMM-dd';
  final TextEditingController _formatCtrl = TextEditingController();

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
        titleTextStyle: TextStyle(fontSize: 14),
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
      locale: _locale!,
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
          slectedDate = DateFormat('dd-MM-yyyy').format(dateTime);
          if(kDebugMode) {
            print("$_dateTime");
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        body: Consumer<DataProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.getLeadBusinessDetailData == null && isLoading) {
                return Loader();
              } else {
                if (productProvider.getLeadBusinessDetailData != null && isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }
                if(productProvider.getLeadBusinessDetailData!=null){
                  if(productProvider.getLeadBusinessDetailData?.businessName!=null &&productProvider.getLeadBusinessDetailData?.doi!=null){
                    _gstController.text=productProvider.getLeadBusinessDetailData!.busGSTNO!;
                    _businessNameController.text=productProvider.getLeadBusinessDetailData!.businessName!;
                    _addressLineController.text=productProvider.getLeadBusinessDetailData!.addressLineOne!;
                    _businessIncorporationDateController.text=productProvider.getLeadBusinessDetailData!.doi!;
                    _addressLine2Controller.text=productProvider.getLeadBusinessDetailData!.addressLineTwo!;
                    _pinCodeController.text=productProvider.getLeadBusinessDetailData!.zipCode! as String;
                    _cityController.text=productProvider.getLeadBusinessDetailData!.cityId! as String;
                    _stateController.text=productProvider.getLeadBusinessDetailData!.stateId! as String;
                    _BusinessDocumentNumberController.text=productProvider.getLeadBusinessDetailData!.buisnessDocumentNo!;

                  }
                }


                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
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
                        SizedBox(
                          height: 28.0,
                        ),
                        Stack(
                          children: [
                            CommonTextField(
                              controller: _gstController,
                              hintText: "07AACDW15215NF",
                                keyboardType: TextInputType.text,
                              enabled: isEnabledGST,
                              labelText: "GST Number(Optional)",
                                inputFormatter: [LengthLimitingTextInputFormatter(15)],
                                onChanged: (text) async {
                                  print(
                                      'TextField value: $text (${text.length})');
                                  if (text.length == 15) {
                                    print(
                                        'TextField value11: $text (${text.length})');
                                    try{
                                      await getCustomerDetailUsingGST(context,_gstController.text);
                                      if(productProvider.getCustomerDetailUsingGSTData!=null){
                                        if(productProvider.getCustomerDetailUsingGSTData!.busGSTNO!.isEmpty ||productProvider.getCustomerDetailUsingGSTData!.busGSTNO!=null){
                                          Utils.showToast(productProvider.getCustomerDetailUsingGSTData!.message!);
                                          _gstController.text=productProvider.getCustomerDetailUsingGSTData!.busGSTNO!;
                                          _businessNameController.text=productProvider.getCustomerDetailUsingGSTData!.businessName!;
                                          _addressLineController.text=productProvider.getCustomerDetailUsingGSTData!.addressLineOne!;
                                          _businessIncorporationDateController.text=productProvider.getCustomerDetailUsingGSTData!.doi!;
                                          _addressLine2Controller.text=productProvider.getCustomerDetailUsingGSTData!.addressLineTwo!;
                                          _pinCodeController.text=productProvider.getCustomerDetailUsingGSTData!.zipCode!.toString();
                                          _cityController.text=productProvider.getCustomerDetailUsingGSTData!.cityId.toString();
                                          _stateController.text=productProvider.getCustomerDetailUsingGSTData!.stateId!.toString();
                                          _BusinessDocumentNumberController.text=productProvider.getCustomerDetailUsingGSTData!.buisnessDocumentNo!;


                                          isEnabledGST=false;

                                        }else{
                                          Utils.showToast(productProvider.getCustomerDetailUsingGSTData!.message!);
                                        }
                                      }


                                    }catch(error){
                                      print('Error: $error');
                                    }
                                  }
                                }
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {

                                  print('Edit icon tapped');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: SvgPicture.asset(
                                    'assets/icons/edit_icon.svg',
                                    semanticsLabel: 'Edit Icon SVG',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _businessNameController,
                          hintText: "Shree Balaji Traders ",
                          labelText: "Business Name(As Per Doc)",
                        ),
                        SizedBox(
                          height: 22.0,
                        ),
                        Text(
                          "Business Address ",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: gryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _addressLineController,
                          hintText: "Address Line 1",
                          labelText: "Address Line 1",
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _addressLine2Controller,
                          hintText: "Address Line 2",
                          labelText: "Address Line 2",
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _pinCodeController,
                          hintText: "Pin Code",
                          labelText: "Pin Code",
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _cityController,
                          hintText: "City",
                          labelText: "City",
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _stateController,
                          hintText: "State",
                          labelText: "State",
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            fillColor: textFiledBackgroundColour,
                            filled: true,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                            setState(() {
                              selectedBusinessTypeValue = value;
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
                            customHeights: _getCustomItemsHeights(businessTypeList),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                            setState(() {
                              selectedMonthlySalesTurnoverValue = value;
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
                            customHeights:
                            _getCustomItemsHeights(monthlySalesTurnoverList),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _businessIncorporationDateController,
                          hintText: "Business Incorporation Date",
                          labelText: "Business Incorporation Date",
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        InkWell(
                          onTap: () {
                            _showDatePicker(context);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: textFiledBackgroundColour,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kPrimaryColor)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(slectedDate!.isNotEmpty ? '$slectedDate' : 'Business Incorporation Date',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      )),
                                  Icon(Icons.date_range)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 22.0,
                        ),
                        Text(
                          "Business Address ",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: gryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                            'Choose Business Proof',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items: _addDividersAfterItems(chooseBusinessProofList),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            customHeights:
                            _getCustomItemsHeights(chooseBusinessProofList),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CommonTextField(
                          controller: _BusinessDocumentNumberController,
                          hintText: "Business Document Number",
                          labelText: "Business Document Number",
                        ),
                        SizedBox(
                          height: 36.0,
                        ),
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
                                    : (image.isNotEmpty)
                                    ? ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  child: Image.network(
                                    image!,
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
                        const SizedBox(height: 54.0),
                        CommonElevatedButton(
                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ProfileReview();
                                },
                              ),
                            );
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

  Future<void> callApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);

    Provider.of<DataProvider>(context, listen: false).getLeadBusinessDetail(userId!);
  }

  Future<void> getCustomerDetailUsingGST(BuildContext context ,String GSTnumber) async {
    Utils.onLoading(context,"");
    await Provider.of<DataProvider>(context, listen: false).getCustomerDetailUsingGST(GSTnumber);
    Navigator.of(context, rootNavigator: true).pop();
  }
  Future<void> postLeadBuisnessDetail(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);

   var postLeadBuisnessDetailRequestModel=PostLeadBuisnessDetailRequestModel();
    Utils.onLoading(context,"");
    Provider.of<DataProvider>(context, listen: false).postLeadBuisnessDetail(postLeadBuisnessDetailRequestModel);
    Navigator.of(context, rootNavigator: true).pop();
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
  }


}
