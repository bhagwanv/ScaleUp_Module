import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/view/agreement_screen/Agreementscreen.dart';
import 'package:scale_up_module/view/bank_details_screen/model/LiveBankList.dart';

import '../../api/ApiService.dart';
import '../../data_provider/DataProvider.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constants.dart';
import '../../utils/loader.dart';
import 'model/BankListResponceModel.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _bankAccountNumberCl = TextEditingController();
  final TextEditingController _ifsccodeCl = TextEditingController();

  @override
  void initState() {
    super.initState();
    callAPI(context);
  }

  var isLoading = true;

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

  List<double> _getCustomItemsHeights1(List<LiveBankList> items) {
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

  List<DropdownMenuItem<LiveBankList>> _addDividersAfterItems1(
      List<LiveBankList> items) {
    final List<DropdownMenuItem<LiveBankList>> menuItems = [];
    for (final LiveBankList item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<LiveBankList>(
            value: item,
            child: Text(
              item.bankName!, // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<LiveBankList>(
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: Consumer<DataProvider>(
              builder: (context, productProvider, child) {
            if (productProvider.getBankListData != null &&
                productProvider.getBankDetailsData != null &&
                isLoading) {
              Navigator.of(context, rootNavigator: true).pop();
              isLoading = false;
              if (productProvider.getBankDetailsData != null &&
                  productProvider.getBankDetailsData!.isSuccess!) {
                _accountHolderController.text = productProvider
                    .getBankDetailsData!.result!.accountHolderName!;
                _bankAccountNumberCl.text =
                    productProvider.getBankDetailsData!.result!.accountNumber!;
                _ifsccodeCl.text =
                    productProvider.getBankDetailsData!.result!.ifscCode!;
              } else {
                Utils.showToast(productProvider.getBankDetailsData!.message!);
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Step 4",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Bank Details",
                        style: TextStyle(
                          fontSize: 40.0,
                          color: blackSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      DropdownButtonFormField2<LiveBankList>(
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
                          'Bank Name',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: _addDividersAfterItems1(
                            productProvider.getBankListData!.liveBankList!),
                        onChanged: (LiveBankList? value) {
                          /*setState(() {
                          selectedBankNameValue = value!;
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
                          customHeights: _getCustomItemsHeights1(
                              productProvider.getBankListData!.liveBankList!),
                        ),
                        iconStyleData: const IconStyleData(
                          openMenuIcon: Icon(Icons.arrow_drop_up),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _accountHolderController,
                        hintText: "Account Holder Name ",
                        labelText: "Account Holder Name ",
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        keyboardType: TextInputType.number,
                        controller: _bankAccountNumberCl,
                        maxLines: 1,
                        hintText: "Bank Acc Number ",
                        labelText: "Bank Acc Number ",
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      DropdownButtonFormField2<String>(
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
                          customHeights:
                              _getCustomItemsHeights(accountTypeList),
                        ),
                        iconStyleData: const IconStyleData(
                          openMenuIcon: Icon(Icons.arrow_drop_up),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _ifsccodeCl,
                        hintText: "IFSC Code",
                        labelText: "IFSC Code",
                        textCapitalization: TextCapitalization.characters,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
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
              );
            } else {
              return Center(child: Loader());
            }
          }),
        ));
  }

  Future<void> callAPI(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    print("daddd ${leadId}");
    Provider.of<DataProvider>(context, listen: false).getBankList();

    if(leadId != null) {
      Provider.of<DataProvider>(context, listen: false).getBankDetails(leadId!);
    } else {
      Utils.showToast("Lead Id should not be null or 0");
    }
  }
}
