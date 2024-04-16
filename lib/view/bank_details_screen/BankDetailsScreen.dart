

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/utils/Utils.dart';
import 'package:scale_up_module/view/agreement_screen/Agreementscreen.dart';
import 'package:scale_up_module/view/bank_details_screen/model/LiveBankList.dart';
import 'package:scale_up_module/view/bank_details_screen/model/SaveBankDetailsRequestModel.dart';

import '../../api/ApiService.dart';
import '../../data_provider/DataProvider.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';


class BankDetailsScreen extends StatefulWidget {

  final int activityId;
  final int subActivityId;
  BankDetailsScreen({super.key, required this.activityId, required this.subActivityId});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankAccountNumberCl = TextEditingController();
  final TextEditingController _accountTypeCl = TextEditingController();
  final TextEditingController _ifsccodeCl = TextEditingController();

  @override
  void initState() {
    super.initState();
    callAPI(context);
  }
  var personalDetailsData;
  var isLoading = true;
  List<LiveBankList?>? liveBankList = [];
  late String selectedAccountTypeValue;
  String? selectedBankValue;

  List<String> accountTypeList = ['saving', 'current','other'];
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

  List<double> _getCustomItemsHeights1(List<LiveBankList?> items) {
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

  List<DropdownMenuItem<LiveBankList>> _addDividersAfterItems1(List<LiveBankList?> items) {
    final List<DropdownMenuItem<LiveBankList>> menuItems = [];
    for (final LiveBankList? item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<LiveBankList>(
            value: item,
            child: Text(
              item!.bankName!, // Assuming 'name' is the property to display
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
            if (productProvider.getBankListData == null &&
                isLoading) {
              return Center(child: Loader());
            } else {
              Navigator.of(context, rootNavigator: true).pop();
              isLoading = false;

              if (productProvider.getBankListData != null) {
                if (productProvider.getBankListData!.liveBankList != null) {
                  liveBankList = productProvider.getBankListData!.liveBankList!;
                }
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
                      bankListWidget(productProvider),
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
                       inputFormatter: [
                         LengthLimitingTextInputFormatter(17),
                         // Limit to 10 characters
                       ],
                        keyboardType: TextInputType.number,
                        controller: _bankAccountNumberCl,
                        maxLines: 1,
                        hintText: "Bank Acc Number ",
                        labelText: "Bank Acc Number ",
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                     accountTypeWidget(productProvider),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        inputFormatter: [
                          LengthLimitingTextInputFormatter(11),
                          // Limit to 10 characters
                        ],
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
                          submitBankDetailsApi(context);


                         /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const AgreementScreen();
                              },
                            ),
                          );*/
                        },
                        text: 'Next',
                        upperCase: true,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ));
  }

  Future<void> callAPI(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<DataProvider>(context, listen: false).getBankList();

    personalDetailsData = await ApiService().GetLeadBankDetail(leadId!);

    if (personalDetailsData != null && personalDetailsData.isSuccess!) {
      _accountHolderController.text = personalDetailsData.result!.accountHolderName!;
      _bankAccountNumberCl.text = personalDetailsData.result!.accountNumber!;
      _ifsccodeCl.text = personalDetailsData.result!.ifscCode!;
      _bankNameController.text = personalDetailsData.result!.bankName!;
      _accountTypeCl.text = personalDetailsData.result!.accountType!;

    } else {
       Utils.showToast(personalDetailsData.message!);
    }
  }
  Widget bankListWidget(DataProvider productProvider) {
    if (personalDetailsData.result!.bankName! != null) {
      var initialData = liveBankList!.where((element) => element?.bankName ==personalDetailsData!.result!.bankName!).toList();
      if(initialData.isNotEmpty){
        selectedBankValue =initialData.first!.bankName!.toString();
      }

    return DropdownButtonFormField2<LiveBankList>(
      value: initialData.isNotEmpty?initialData.first:null,
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
        items: _addDividersAfterItems1(liveBankList!),
        onChanged: (LiveBankList? value) {
          selectedBankValue = value!.bankName!;
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          customHeights: _getCustomItemsHeights1(liveBankList!),
        ),
        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget accountTypeWidget(DataProvider productProvider) {
    if (personalDetailsData.result!.accountType! != null) {
      //var initialData = accountTypeList.where((element) => element ==personalDetailsData!.result!.accountType!).toList();
      //List<String> initialData = accountTypeList.where((element) => element.contains(personalDetailsData!.result!.accountType!)).toList();
      List<String> initialData = accountTypeList.where((element) => element.contains(personalDetailsData?.result?.accountType ?? '')).toList();
      if(initialData.isNotEmpty){
        selectedAccountTypeValue =initialData.first;
      }

      print("Bhagwan ${initialData}");
      return  DropdownButtonFormField2<String>(
        value: initialData.isNotEmpty?initialData.first:null,
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
        onChanged: (String? value) {
          selectedAccountTypeValue = value!;
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
      );
    } else {
      return Container();
    }
  }

  void submitBankDetailsApi(BuildContext contextz)async {
    Utils.onLoading(context, "");
    if(selectedBankValue!.isEmpty){
      Utils.showToast("Please Select Bank");
    } else if(_accountHolderController.text.isEmpty){
      Utils.showToast("Please Enter Account Holder Name");
    } else if(_bankAccountNumberCl.text.isEmpty){
      Utils.showToast("Please Enter Account Number");
    }else if(selectedAccountTypeValue.isEmpty){
      Utils.showToast("Please Select account Type");
    }else if(_ifsccodeCl.text.isEmpty){
      Utils.showToast("Please Enter IFSC code");
    }else if(!Utils.isValidIFSCCode(_ifsccodeCl.text)){
      Utils.showToast("IFSC code should be minimum 9 digits and max 11 digits!!");
    }else{
      final prefsUtil = await SharedPref.getInstance();
      final int? leadID = prefsUtil.getInt(LEADE_ID);
      var saveBankDetailsModel = await ApiService().saveLeadBankDetail(SaveBankDetailsRequestModel(accountType: selectedAccountTypeValue,bankName: selectedBankValue,iFSCCode:_ifsccodeCl.text,leadId: leadID!,eNach: "BankDetail",activityId: widget.activityId,subActivityId: widget.subActivityId,accountNumber: _bankAccountNumberCl.text,accountHolderName: _accountHolderController.text));
      if(saveBankDetailsModel.isSuccess!){
        Navigator.of(context, rootNavigator: true).pop();
        fetchData(context);
      }else{
        Utils.showToast(saveBankDetailsModel.message!);
      }

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
        userId: prefsUtil.getString(USER_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData = await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel) as LeadCurrentResponseModel?;

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
}


