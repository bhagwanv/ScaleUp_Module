import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scale_up_module/view/agreement_screen/Agreementscreen.dart';

import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constants.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final TextEditingController _gstController = TextEditingController();

  final List<String> bankNameList = [
    'State Bank Of India',
    'Kotak Bank',
    'Yes Bank',
    'PNB'
  ];

  String? selectedBankNameValue;

  final List<String> accountTypeList = [
    'Saving',
    'Current',
  ];

  String? selectedAccountTypeValue;


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
              SizedBox(height: 16.0,),
              Text(
                "Step 4",
                style: TextStyle(
                  fontSize: 15.0,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 30.0,),
              Text(
                "Bank Details",
                style: TextStyle(
                  fontSize: 40.0,
                  color: blackSmall,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 30.0,),
              DropdownButtonFormField2<String>(
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
                  'Bank Name',
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                items: _addDividersAfterItems(bankNameList),
                value: selectedBankNameValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedBankNameValue = value;
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
                  customHeights: _getCustomItemsHeights(bankNameList),
                ),
                iconStyleData: const IconStyleData(
                  openMenuIcon: Icon(Icons.arrow_drop_up),
                ),
              ),
              SizedBox(height: 16.0,),
              CommonTextField(
                controller: _gstController,
                hintText: "Account Holder Name ",
                labelText: "Account Holder Name ",
              ),
              SizedBox(height: 16.0,),
              CommonTextField(
                controller: _gstController,
                hintText: "Bank Acc Number ",
                labelText: "Bank Acc Number ",
              ),
              SizedBox(height: 16.0,),
              DropdownButtonFormField2<String>(
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
                  'Account Type',
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                items: _addDividersAfterItems(accountTypeList),
                value: selectedAccountTypeValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedAccountTypeValue = value;
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
                  customHeights: _getCustomItemsHeights(accountTypeList),
                ),
                iconStyleData: const IconStyleData(
                  openMenuIcon: Icon(Icons.arrow_drop_up),
                ),
              ),
              SizedBox(height: 16.0,),
              CommonTextField(
                controller: _gstController,
                hintText: "IFSC Code",
                labelText: "IFSC Code",
              ),
              SizedBox(height: 30.0,),
              CommonElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const AgreementScreen();
                      },
                    ),
                  );
                },
                text: 'Next',
                upperCase: true,
              ),

            ],
          ),
        ),
      )),
    );
  }
}
