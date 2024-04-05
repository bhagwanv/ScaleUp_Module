import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:scale_up_module/utils/common_text_field.dart';
import 'package:scale_up_module/view/profile_screen/ProfileReview.dart';

import '../../utils/common_elevted_button.dart';
import '../../utils/constants.dart';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({super.key});

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  final TextEditingController _gstController = TextEditingController();
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
        body: Padding(
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
                CommonTextField(
                  controller: _gstController,
                  hintText: "07AACDW15215NF",
                  labelText: "GST Number(Optional)",
                ),
                SizedBox(
                  height: 16.0,
                ),
                CommonTextField(
                  controller: _gstController,
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
                  controller: _gstController,
                  hintText: "Address Line 1",
                  labelText: "Address Line 1",
                ),
                SizedBox(
                  height: 16.0,
                ),
                CommonTextField(
                  controller: _gstController,
                  hintText: "Address Line 2",
                  labelText: "Address Line 2",
                ),
                SizedBox(
                  height: 16.0,
                ),
                CommonTextField(
                  controller: _gstController,
                  hintText: "Pin Code",
                  labelText: "Pin Code",
                ),
                SizedBox(
                  height: 16.0,
                ),
                CommonTextField(
                  controller: _gstController,
                  hintText: "City",
                  labelText: "City",
                ),
                SizedBox(
                  height: 16.0,
                ),
                CommonTextField(
                  controller: _gstController,
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
                  controller: _gstController,
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
                  controller: _gstController,
                  hintText: "Business Document Number",
                  labelText: "Business Document Number",
                ),
                SizedBox(
                  height: 36.0,
                ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: SvgPicture.asset(
                                    "assets/icons/gallery.svg",
                                    colorFilter: const ColorFilter.mode(
                                        kPrimaryColor, BlendMode.srcIn))),
                            const Text(
                              'Upload Business Proof',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Text(
                              'Supports : PDF, JPEG, PNG',
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
                        if (kDebugMode) {
                          print("tapped on container");
                        }
                      },
                    ),
                  ),
                ),
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
        ),
      ),
    );
  }
}
