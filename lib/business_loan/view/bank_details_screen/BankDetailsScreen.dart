import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/business_loan/utils/Utils.dart';
import 'package:scale_up_module/business_loan/view/bank_details_screen/model/BankDetailsResponceModel.dart';
import 'package:scale_up_module/business_loan/view/bank_details_screen/model/LiveBankList.dart';
import 'package:scale_up_module/business_loan/view/bank_details_screen/model/SaveBankDetailsRequestModel.dart';

import '../../../business_loan/utils/common_check_box.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../data_provider/BusinessDataProvider.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/GetLeadDocumentDetailResModel.dart';

class BankDetailsScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  BankDetailsScreen({
    super.key,
    required this.activityId,
    required this.subActivityId,
  });

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _bankStatmentPassworedController =
      TextEditingController();
  final TextEditingController _bankAccountNumberCl = TextEditingController();
  final TextEditingController _ifsccodeCl = TextEditingController();

  final TextEditingController _nachAccountHolderController =
      TextEditingController();
  final TextEditingController _nachBankStatmentPassworedController =
      TextEditingController();
  final TextEditingController _nachBankAccountNumberCl =
      TextEditingController();
  final TextEditingController _nachIfsccodeCl = TextEditingController();
  var nachsurrogateType = "";

  // var personalDetailsData;
  var isLoading = true;
  List<LiveBankList?>? liveBankList = [];
  String? selectedAccountTypeValue;
  String? selectedNachAccountTypeValue;
  String? selectedBankValue;
  String? nachSelectedBankValue;
  BankDetailsResponceModel? bankDetailsResponceModel = null;
  List<String?>? documentList = [];
  List<String?>? gstDocumentList = [];
  List<String?>? itrDocumentList = [];
  var isEditableStatement = false;
  var isSameBank = false;
  var disbursementDetailType = "borrower";
  var nachTpye = "beneficiary";
  var selectedBankinitialData = null;
  var selectedNatchBankinitialData = null;
  var isFillData = false;
  var isSelectedNatchBank = false;

  @override
  void initState() {
    super.initState();
    callAPI(context);
  }

  List<String> accountTypeList = ['savings', 'current', 'other'];

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          /*if (item != items.last)
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

  List<double> _getCustomItemsHeights(List<String> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  List<DropdownMenuItem<String>> _addNachDividersAfterItems(
      List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
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

  List<double> _getCustomNachItemsHeights(List<String> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
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

  List<DropdownMenuItem<LiveBankList>> _addDividersAfterItems1(
      List<LiveBankList?> items) {
    final List<DropdownMenuItem<LiveBankList>> menuItems = [];
    for (final LiveBankList? item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<LiveBankList>(
            value: item,
            child: Text(
              item!.bankName!,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          /*if (item != items.last)
            const DropdownMenuItem<LiveBankList>(
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: Consumer<BusinessDataProvider>(
              builder: (context, productProvider, child) {
            if (productProvider.getBankDetailsData == null && isLoading) {
              return Center(child: Loader());
            } else {
              if (productProvider.getBankDetailsData != null && isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }

              if (productProvider.getBankDetailsData != null) {
                productProvider.getBankDetailsData!.when(
                  success: (BankDetailsResponceModel) async {
                    bankDetailsResponceModel = BankDetailsResponceModel;

                    if (!isFillData) {
                      if (bankDetailsResponceModel != null) {
                        if (bankDetailsResponceModel!.result != null) {
                          if (bankDetailsResponceModel!.isSuccess!) {

                            //bank details
                            if (bankDetailsResponceModel!
                                    .result!.leadBankDetailDTOs !=
                                null) {
                              _accountHolderController.text =
                                  bankDetailsResponceModel!
                                      .result!
                                      .leadBankDetailDTOs![0]
                                      .accountHolderName!;
                              _bankAccountNumberCl.text =
                                  bankDetailsResponceModel!.result!
                                      .leadBankDetailDTOs![0].accountNumber!;
                              _ifsccodeCl.text = bankDetailsResponceModel!
                                  .result!.leadBankDetailDTOs![0].ifscCode!;

                              selectedBankValue = bankDetailsResponceModel!
                                  .result!.leadBankDetailDTOs![0].bankName!;
                              print("selectedBankValue=$selectedBankValue");

                              selectedAccountTypeValue =
                                  bankDetailsResponceModel!.result!
                                      .leadBankDetailDTOs![0].accountType!;
                              //nachsurrogateType = bankDetailsResponceModel!.result!.leadBankDetailDTOs![0].surrogateType!;
                              if(bankDetailsResponceModel!.result!.leadBankDetailDTOs![0].type!.isNotEmpty){
                                disbursementDetailType = bankDetailsResponceModel!.result!.leadBankDetailDTOs![0].type!;
                              }else{
                                 disbursementDetailType = "borrower";

                              }



                            }

                            //natch bank Details
                            if (bankDetailsResponceModel!
                                    .result!.leadBankDetailDTOs !=
                                null) {
                              _nachAccountHolderController.text =
                                  bankDetailsResponceModel!
                                      .result!
                                      .leadBankDetailDTOs![1]
                                      .accountHolderName!;
                              _nachBankAccountNumberCl.text =
                                  bankDetailsResponceModel!.result!
                                      .leadBankDetailDTOs![1].accountNumber!;
                              _nachIfsccodeCl.text = bankDetailsResponceModel!
                                  .result!.leadBankDetailDTOs![1].ifscCode!;
                              nachSelectedBankValue = bankDetailsResponceModel!
                                  .result!.leadBankDetailDTOs![1].bankName!;
                              selectedNachAccountTypeValue =
                                  bankDetailsResponceModel!.result!
                                      .leadBankDetailDTOs![1].accountType!;
                              _bankStatmentPassworedController.text =
                                  bankDetailsResponceModel!.result!
                                      .leadBankDetailDTOs![1].pdfPassword!;
                              if(bankDetailsResponceModel!.result!.leadBankDetailDTOs![1].type!.isNotEmpty){
                                nachTpye = bankDetailsResponceModel!.result!.leadBankDetailDTOs![1].type!;
                              }else{
                                 nachTpye = "beneficiary";
                              }
                              isFillData = true;
                            }

                            // _bankStatmentPassworedController.text = bankDetailsResponceModel!.result!.leadBankDetailDTOs!.first.pdfPassword!;
                            if (!isEditableStatement) {
                              documentList!.clear();
                              gstDocumentList!.clear();
                              itrDocumentList!.clear();
                              for (int i = 0; i < bankDetailsResponceModel!.result!.bankDocs!.length; i++) {
                                print("bankDocsDAta " + i.toString());
                                if (bankDetailsResponceModel!
                                        .result!.bankDocs![i].documentName ==
                                    "bank_statement") {
                                  documentList!.add(bankDetailsResponceModel!
                                      .result!.bankDocs![i].fileURL);
                                }
                                if (bankDetailsResponceModel!
                                        .result!.bankDocs![i].documentName ==
                                    "surrogate_gst") {
                                  gstDocumentList!.add(bankDetailsResponceModel!
                                      .result!.bankDocs![i].fileURL);
                                }

                                if (bankDetailsResponceModel!
                                        .result!.bankDocs![i].documentName ==
                                    "surrogate_itr") {
                                  itrDocumentList!.add(bankDetailsResponceModel!
                                      .result!.bankDocs![i].fileURL);
                                }
                              }
                              isEditableStatement = true;
                            }

                             for (int i = 0; i < bankDetailsResponceModel!.result!.bankDocs!.length; i++) {
                              print("bankDocsDAta1 "+i.toString());
                            }
                          } else {
                            Utils.showToast(
                                bankDetailsResponceModel!.message!, context);
                          }
                        }
                      }
                    }
                  },
                  failure: (exception) {
                    if (exception is ApiException) {
                      if (exception.statusCode == 401) {
                        productProvider.disposeAllProviderData();
                        ApiService().handle401(context);
                      } else {
                        Utils.showToast(exception.errorMessage, context);
                      }
                    }
                  },
                );
              }


              if (productProvider.getBankListData != null) {
                if (productProvider.getBankListData!.liveBankList != null) {
                  liveBankList = productProvider.getBankListData!.liveBankList!;
                }
              }

              if (productProvider.getLeadBusinessDetailData != null) {
                if (productProvider.getLeadBusinessDetailData!.surrogateType !=
                    null) {
                  nachsurrogateType =
                      productProvider.getLeadBusinessDetailData!.surrogateType!;
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
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
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
                        style: GoogleFonts.urbanist(
                          fontSize: 40,
                          color: blackSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),

                      Text(
                        "Disbursement Bank Detail",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          color: blackSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),

                      bankListWidget(productProvider),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _accountHolderController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z ]'))),
                        ],
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
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
                          LengthLimitingTextInputFormatter(11)
                        ],
                        controller: _ifsccodeCl,
                        hintText: "IFSC Code",
                        labelText: "IFSC Code",
                        textCapitalization: TextCapitalization.characters,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),

                      Text(
                        "NaCH Bank Detail",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          color: blackSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),

                      CommonCheckBox(
                        onChanged: (bool isChecked) async {
                          // Handle the state change here
                          print('Checkbox state changed: $isChecked');
                          setState(() {
                            isSameBank = isChecked;
                            if (isChecked) {
                              _nachAccountHolderController.text =
                                  _accountHolderController.text;
                              _nachBankAccountNumberCl.text =
                                  _bankAccountNumberCl.text;
                              _nachIfsccodeCl.text = _ifsccodeCl.text;
                              selectedNachAccountTypeValue =
                                  selectedAccountTypeValue;
                              nachSelectedBankValue = selectedBankValue;

                              isSelectedNatchBank = false;
                            } else {
                              _nachAccountHolderController.text = "";
                              _nachBankAccountNumberCl.text = "";
                              _nachIfsccodeCl.text = "";
                              selectedNachAccountTypeValue = null;
                              nachSelectedBankValue = null;
                              isSelectedNatchBank = true;
                            }
                          });
                        },
                        isChecked: isSameBank,
                        text: "Same Bank as Disbursement ",
                        upperCase: false,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),

                      nachBankListWidget(productProvider),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        enabled: !isSameBank,
                        controller: _nachAccountHolderController,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z ]'))),
                        ],
                        hintText: "Account Holder Name ",
                        labelText: "Account Holder Name ",
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        enabled: !isSameBank,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                          LengthLimitingTextInputFormatter(17)
                        ],
                        keyboardType: TextInputType.number,
                        controller: _nachBankAccountNumberCl,
                        maxLines: 1,
                        hintText: "Bank Acc Number ",
                        labelText: "Bank Acc Number ",
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      nachAccountTypeWidget(productProvider),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        enabled: !isSameBank,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
                          LengthLimitingTextInputFormatter(11)
                        ],
                        controller: _nachIfsccodeCl,
                        hintText: "IFSC Code",
                        labelText: "IFSC Code",
                        textCapitalization: TextCapitalization.characters,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),

                      CommonTextField(
                        controller: _bankStatmentPassworedController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Za-z0-9]'))),
                        ],
                        hintText: "Bank Statement password(optional)",
                        labelText: "Bank Statement password(optional)",
                      ),
                      //Uplod Bank  Document

                      Column(
                        children: [
                          SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xff0196CE))),
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () async {
                                isEditableStatement = true;
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf']);
                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  print(file.path);
                                  //widget.onImageSelected(file);
                                  Utils.onLoading(context, "");
                                  await Provider.of<BusinessDataProvider>(
                                          context,
                                          listen: false)
                                      .postBusineesDoumentSingleFile(
                                          file, true, "", "");
                                  if (productProvider
                                          .getpostBusineesDoumentSingleFileData !=
                                      null) {
                                    documentList!.add(productProvider
                                        .getpostBusineesDoumentSingleFileData!
                                        .filePath);
                                  }
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: Container(
                                height: 148,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xffEFFAFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/images/gallery.svg'),
                                    Text(
                                      'Upload Bank Proof',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12,
                                        color: Color(0xff0196CE),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'Supports : PDF',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12,
                                        color: Color(0xffCACACA),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          documentList!.isNotEmpty
                              ? Column(
                                  children: documentList!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final document = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.grey[200],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("${index + 1}"),
                                              Spacer(),
                                              Icon(Icons.picture_as_pdf),
                                              Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isEditableStatement = true;
                                                    documentList!
                                                        .removeAt(index);
                                                  });
                                                },
                                                child: Container(
                                                  child: SvgPicture.asset(
                                                      'assets/icons/delete_icon.svg'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Container(),
                        ],
                      ),

                      // upload GST Document
                      nachsurrogateType == "GST"
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 16.0,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color(0xff0196CE))),
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () async {
                                      isEditableStatement = true;
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: ['pdf']);
                                      if (result != null) {
                                        File file =
                                            File(result.files.single.path!);
                                        print(file.path);
                                        //widget.onImageSelected(file);
                                        Utils.onLoading(context, "");
                                        await Provider.of<BusinessDataProvider>(
                                                context,
                                                listen: false)
                                            .postBusineesDoumentSingleFile(
                                                file, true, "", "");
                                        if (productProvider
                                                .getpostBusineesDoumentSingleFileData !=
                                            null) {
                                          gstDocumentList!.add(productProvider
                                              .getpostBusineesDoumentSingleFileData!
                                              .filePath);
                                        }
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        // User canceled the picker
                                      }
                                    },
                                    child: Container(
                                      height: 148,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffEFFAFF),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/images/gallery.svg'),
                                          Text(
                                            'Upload GST',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: Color(0xff0196CE),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            'Supports : PDF',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: Color(0xffCACACA),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            'You can upload multiple files',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: Color(0xff0196CE),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                gstDocumentList!.isNotEmpty
                                    ? Column(
                                        children: gstDocumentList!
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final index = entry.key;
                                          final document = entry.value;
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Colors.grey[200],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text("${index + 1}"),
                                                    Spacer(),
                                                    Icon(Icons.picture_as_pdf),
                                                    Spacer(),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          isEditableStatement =
                                                              true;
                                                          gstDocumentList!
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: Container(
                                                        child: SvgPicture.asset(
                                                            'assets/icons/delete_icon.svg'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : Container(),
                              ],
                            )
                          : Container(),

                      // upload ITR Document
                      nachsurrogateType == "ITR"
                          ? Column(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: const Color(0xff0196CE))),
                                      width: double.infinity,
                                      child: GestureDetector(
                                        onTap: () async {
                                          isEditableStatement = true;
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                                      type: FileType.custom,
                                                      allowedExtensions: [
                                                'pdf'
                                              ]);
                                          if (result != null) {
                                            File file =
                                                File(result.files.single.path!);
                                            print(file.path);
                                            //widget.onImageSelected(file);
                                            Utils.onLoading(context, "");
                                            await Provider.of<
                                                        BusinessDataProvider>(
                                                    context,
                                                    listen: false)
                                                .postBusineesDoumentSingleFile(
                                                    file, true, "", "");
                                            if (productProvider
                                                    .getpostBusineesDoumentSingleFileData !=
                                                null) {
                                              gstDocumentList!.add(productProvider
                                                  .getpostBusineesDoumentSingleFileData!
                                                  .filePath);
                                            }
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          } else {
                                            // User canceled the picker
                                          }
                                        },
                                        child: Container(
                                          height: 148,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffEFFAFF),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/images/gallery.svg'),
                                              Text(
                                                'Upload GST',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Color(0xff0196CE),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                'Supports : PDF',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Color(0xffCACACA),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                'You can upload multiple files',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Color(0xff0196CE),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    gstDocumentList!.isNotEmpty
                                        ? Column(
                                            children: gstDocumentList!
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              final index = entry.key;
                                              final document = entry.value;
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: Colors.grey[200],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("${index + 1}"),
                                                        Spacer(),
                                                        Icon(Icons
                                                            .picture_as_pdf),
                                                        Spacer(),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              isEditableStatement =
                                                                  true;
                                                              gstDocumentList!
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                          child: Container(
                                                            child: SvgPicture.asset(
                                                                'assets/icons/delete_icon.svg'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        : Container(),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: const Color(0xff0196CE))),
                                      width: double.infinity,
                                      child: GestureDetector(
                                        onTap: () async {
                                          isEditableStatement = true;
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                                      type: FileType.custom,
                                                      allowedExtensions: [
                                                'pdf'
                                              ]);
                                          if (result != null) {
                                            File file =
                                                File(result.files.single.path!);
                                            print(file.path);
                                            //widget.onImageSelected(file);
                                            Utils.onLoading(context, "");
                                            await Provider.of<
                                                        BusinessDataProvider>(
                                                    context,
                                                    listen: false)
                                                .postBusineesDoumentSingleFile(
                                                    file, true, "", "");
                                            if (productProvider
                                                    .getpostBusineesDoumentSingleFileData !=
                                                null) {
                                              itrDocumentList!.add(productProvider
                                                  .getpostBusineesDoumentSingleFileData!
                                                  .filePath);
                                            }
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          } else {
                                            // User canceled the picker
                                          }
                                        },
                                        child: Container(
                                          height: 148,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffEFFAFF),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/images/gallery.svg'),
                                              Text(
                                                'Upload ITR',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Color(0xff0196CE),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                'Supports : PDF',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Color(0xffCACACA),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                'You can upload multiple files',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Color(0xff0196CE),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    itrDocumentList!.isNotEmpty
                                        ? Column(
                                            children: itrDocumentList!
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              final index = entry.key;
                                              final document = entry.value;
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: Colors.grey[200],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("${index + 1}"),
                                                        Spacer(),
                                                        Icon(Icons
                                                            .picture_as_pdf),
                                                        Spacer(),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              isEditableStatement =
                                                                  true;
                                                              itrDocumentList!
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                          child: Container(
                                                            child: SvgPicture.asset(
                                                                'assets/icons/delete_icon.svg'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            )
                          : Container(),

                      SizedBox(
                        height: 30.0,
                      ),
                      CommonElevatedButton(
                        onPressed: () async {
                          await submitBankDetailsApi(
                              context,
                              productProvider,
                              documentList!,
                              gstDocumentList!,
                              itrDocumentList!);

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
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    final String? userId = prefsUtil.getString(USER_ID);
    /*final int? leadId = 85;
    final String? productCode = "BusinessLoan";*/
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .getBankDetails(leadId!, productCode!);

    await Provider.of<BusinessDataProvider>(context, listen: false)
        .getLeadBusinessDetail(userId!, productCode!);

   /* await Provider.of<BusinessDataProvider>(context, listen: false)
        .getLeadDocumentDetail(leadId);*/

    //Utils.onLoading(context, "");
    await Provider.of<BusinessDataProvider>(context, listen: false)
        .getBankList();
    // Navigator.of(context, rootNavigator: true).pop();
  }

  Widget bankListWidget(BusinessDataProvider productProvider) {
    if (bankDetailsResponceModel != null) {
      if (bankDetailsResponceModel!.result != null) {
        if (bankDetailsResponceModel!.result!.leadBankDetailDTOs != null) {
          if (bankDetailsResponceModel!
                  .result!.leadBankDetailDTOs![0].bankName !=
              null) {
            selectedBankinitialData = liveBankList!
                .where((element) => element?.bankName == selectedBankValue)
                .toList();
          } else {
            selectedBankinitialData = null;
          }
        }
      } else {
        selectedBankinitialData = null;
      }
      return DropdownButtonFormField2<LiveBankList>(
        value: selectedBankinitialData != null &&
                selectedBankinitialData.isNotEmpty
            ? selectedBankinitialData[0]
            : null,
        isExpanded: true,
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
            borderSide: BorderSide(color: kPrimaryColor, width: 1),
          ),
        ),
        hint: Text(
          'Bank Name',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: blueColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: _addDividersAfterItems1(liveBankList!),
        onChanged: (LiveBankList? value) {
          selectedBankValue = value!.bankName!;
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
      return DropdownButtonFormField2<LiveBankList>(
        isExpanded: true,
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
            borderSide: BorderSide(color: kPrimaryColor, width: 1),
          ),
        ),
        hint: Text(
          'Bank Name',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: blueColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: _addDividersAfterItems1(liveBankList!),
        onChanged: (LiveBankList? value) {
          selectedBankValue = value!.bankName!;
          print("value!.bankName!");
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
    }
  }

  Widget nachBankListWidget(BusinessDataProvider productProvider) {
    if (bankDetailsResponceModel != null) {
      if (bankDetailsResponceModel!.result != null) {
        if (bankDetailsResponceModel!.result!.leadBankDetailDTOs != null) {
          if (isSameBank) {
            selectedNatchBankinitialData = liveBankList!
                .where((element) => element?.bankName == nachSelectedBankValue)
                .toList();
          } else if (bankDetailsResponceModel!
                  .result!.leadBankDetailDTOs![1].bankName !=
              null) {
            selectedNatchBankinitialData = liveBankList!
                .where((element) => element?.bankName == nachSelectedBankValue)
                .toList();
          } else {
            selectedNatchBankinitialData = null;
          }
        } else {
          if (isSameBank) {
            selectedNatchBankinitialData = liveBankList!
                .where((element) => element?.bankName == nachSelectedBankValue)
                .toList();
          } else {
            selectedNatchBankinitialData = null;
          }
        }
      } else {
        if (isSameBank) {
          selectedNatchBankinitialData = liveBankList!
              .where((element) => element?.bankName == nachSelectedBankValue)
              .toList();
        } else {
          selectedNatchBankinitialData = null;
        }
      }
      return DropdownButtonFormField2<LiveBankList>(
        //value: selectedNatchBankinitialData!=null?selectedBankinitialData?.first:null,
        value: selectedNatchBankinitialData != null &&
                selectedNatchBankinitialData.isNotEmpty
            ? selectedNatchBankinitialData[0]
            : null,
        isExpanded: true,
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
            borderSide: BorderSide(color: kPrimaryColor, width: 1),
          ),
        ),
        hint: Text(
          'Bank Name',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: blueColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: _addDividersAfterItems1(liveBankList!),
        onChanged: !isSameBank
            ? (LiveBankList? value) {
                nachSelectedBankValue = value!.bankName!;
              }
            : null,
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
      return DropdownButtonFormField2<LiveBankList>(
        isExpanded: true,
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
            borderSide: BorderSide(color: kPrimaryColor, width: 1),
          ),
        ),
        hint: Text(
          'Bank Name',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: blueColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: _addDividersAfterItems1(liveBankList!),
        onChanged: (LiveBankList? value) {
          nachSelectedBankValue = value!.bankName!;
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
    }
  }

/*  Widget accountTypeWidget(BusinessDataProvider productProvider) {
    if (bankDetailsResponceModel != null) {
      if (bankDetailsResponceModel!.result != null) {
        if (bankDetailsResponceModel!.result!.leadBankDetailDTOs!.first.accountType != null) {
          List<String> initialData = accountTypeList
              .where((element) => element.contains(
                  bankDetailsResponceModel!.result?.leadBankDetailDTOs!.first.accountType ?? ''))
              .toList();
          if (initialData.isNotEmpty) {
            selectedAccountTypeValue = initialData.first;
          }

          print("Bhagwan ${initialData}");
          return DropdownButtonFormField2<String>(
            value: initialData.isNotEmpty ? initialData.first : null,
            isExpanded: true,
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
              customHeights: _getCustomItemsHeights(accountTypeList),
            ),
            iconStyleData: const IconStyleData(
              openMenuIcon: Icon(Icons.arrow_drop_up),
            ),
          );
        } else {
          return DropdownButtonFormField2<String>(
            isExpanded: true,
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
              customHeights: _getCustomItemsHeights(accountTypeList),
            ),
            iconStyleData: const IconStyleData(
              openMenuIcon: Icon(Icons.arrow_drop_up),
            ),
          );
        }
      } else {
        return DropdownButtonFormField2<String>(
          isExpanded: true,
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
            customHeights: _getCustomItemsHeights(accountTypeList),
          ),
          iconStyleData: const IconStyleData(
            openMenuIcon: Icon(Icons.arrow_drop_up),
          ),
        );
      }
    } else {
      return DropdownButtonFormField2<String>(
        isExpanded: true,
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
          customHeights: _getCustomItemsHeights(accountTypeList),
        ),
        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up),
        ),
      );
    }
  }*/

  Widget accountTypeWidget(BusinessDataProvider productProvider) {
    return DropdownButtonFormField2<String>(
      value: selectedAccountTypeValue,
      isExpanded: true,
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
          borderSide: BorderSide(color: kPrimaryColor, width: 1),
        ),
      ),
      hint: Text(
        'Account Type',
        style: GoogleFonts.urbanist(
          fontSize: 14,
          color: blueColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      items: _addDividersAfterItems(accountTypeList),
      onChanged: (String? value) {
        selectedAccountTypeValue = value!;
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
  }

  Widget nachAccountTypeWidget(BusinessDataProvider productProvider) {
    return DropdownButtonFormField2<String>(
      value: selectedNachAccountTypeValue,
      isExpanded: true,
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
          borderSide: BorderSide(color: kPrimaryColor, width: 1),
        ),
      ),
      hint: Text(
        'Account Type',
        style: GoogleFonts.urbanist(
          fontSize: 14,
          color: blueColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      items: _addDividersAfterItems(accountTypeList),
      onChanged: !isSameBank
          ? (String? value) {
              selectedNachAccountTypeValue = value!;
            }
          : null,
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
  }

  Future<void> submitBankDetailsApi(
      BuildContext contextz,
      BusinessDataProvider productProvider,
      List<String?> docList,
      List<String?> gstDocList,
      List<String?> itrDocList) async {
    if (selectedBankValue == null) {
      Utils.showToast("Please Select Bank", context);
    } else if (selectedBankValue!.isEmpty) {
      Utils.showToast("Please Select Bank", context);
    } else if (_accountHolderController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Account Holder Name", context);
    } else if (_bankAccountNumberCl.text.trim().isEmpty) {
      Utils.showToast("Please Enter Account Number", context);
    } else if (selectedAccountTypeValue == null) {
      Utils.showToast("Please Select account Type", context);
    } else if (_ifsccodeCl.text.trim().isEmpty) {
      Utils.showToast("Please Enter IFSC code", context);
    } else if (!Utils.isValidIFSCCode(_ifsccodeCl.text.trim())) {
      Utils.showToast(
          "IFSC code should be minimum 9 digits and max 11 digits!!", context);
    } else if (nachSelectedBankValue == null) {
      Utils.showToast("Please Select Nach Bank", context);
    } else if (nachSelectedBankValue!.isEmpty) {
      Utils.showToast("Please Select Nach Bank", context);
    } else if (_nachAccountHolderController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Nach Account Holder Name", context);
    } else if (_nachBankAccountNumberCl.text.trim().isEmpty) {
      Utils.showToast("Please Enter Nach Account Number", context);
    } else if (selectedNachAccountTypeValue == null) {
      Utils.showToast("Please Select Nach account Type", context);
    } else if (_nachIfsccodeCl.text.trim().isEmpty) {
      Utils.showToast("Please Enter Nach IFSC code", context);
    } else if (!Utils.isValidIFSCCode(_nachIfsccodeCl.text.trim())) {
      Utils.showToast(
          "IFSC code should be minimum 9 digits and max 11 digits!!", context);
    } else if (documentList!.isEmpty) {
      Utils.showToast("Please uploade bank proof", context);
    } else if (nachsurrogateType=="GST") {
      if( gstDocumentList!.isEmpty){
        Utils.showToast("Please uploade GST proof", context);
      }
    }else if (nachsurrogateType=="ITR") {
      if( gstDocumentList!.isEmpty){
        Utils.showToast("Please uploade GST proof", context);
      }else if( itrDocumentList!.isEmpty){
        Utils.showToast("Please uploade ITR proof", context);
      }

    }

    else {
      final prefsUtil = await SharedPref.getInstance();
      final int? leadID = prefsUtil.getInt(LEADE_ID);

      List<LeadBankDetailDTOs> leadBankDetailsList = [];
      List<BankDocs> bankDocList = [];
      leadBankDetailsList.clear();
      bankDocList.clear();

      leadBankDetailsList.add(
        LeadBankDetailDTOs(
          leadId: leadID!,
          type: disbursementDetailType,
          bankName: selectedBankValue,
          iFSCCode: _ifsccodeCl.text.trim(),
          accountType: selectedAccountTypeValue,
          activityId: widget.activityId,
          subActivityId: widget.subActivityId,
          accountNumber: _bankAccountNumberCl.text.trim(),
          accountHolderName: _accountHolderController.text.trim(),
          pdfPassword: _bankStatmentPassworedController.text.trim(),
          surrogateType: nachsurrogateType,
        ),
      );

      leadBankDetailsList.add(
        LeadBankDetailDTOs(
          leadId: leadID!,
          type: nachTpye,
          bankName: nachSelectedBankValue,
          iFSCCode: _nachIfsccodeCl.text.trim(),
          accountType: selectedNachAccountTypeValue,
          activityId: widget.activityId,
          subActivityId: widget.subActivityId,
          accountNumber: _nachBankAccountNumberCl.text.trim(),
          accountHolderName: _nachAccountHolderController.text.trim(),
          pdfPassword: _bankStatmentPassworedController.text.trim(),
          surrogateType: nachsurrogateType,
        ),
      );

      for (int i = 0; i < docList.length; i++) {
        bankDocList.add(
          BankDocs(
              documentType: "id_proof",
              documentName: "bank_statement",
              fileURL: docList[i],
              sequence: i + 1,
              pdfPassword: _bankStatmentPassworedController.text,
              documentNumber: _bankAccountNumberCl.text,
          ),
        );
      }
      for (int i = 0; i < gstDocList.length; i++) {
        bankDocList.add(BankDocs(
            documentType: "id_proof",
            documentName: "surrogate_gst",
            fileURL: gstDocList[i],
            sequence: i + 1,
            pdfPassword: _bankStatmentPassworedController.text,
            documentNumber: _bankAccountNumberCl.text));
      }
      for (int i = 0; i < itrDocList.length; i++) {
        bankDocList.add(BankDocs(
            documentType: "id_proof",
            documentName: "surrogate_itr",
            fileURL: itrDocList[i],
            sequence: i + 1,
            pdfPassword: _bankStatmentPassworedController.text,
            documentNumber: _bankAccountNumberCl.text));
      }

      var postData = SaveBankDetailsRequestModel(
          leadBankDetailDTOs: leadBankDetailsList,
          isScaleUp: false,
          bankDocs: bankDocList);

      print("Save Data" + postData.toJson().toString());
      Utils.onLoading(context, "");
      await Provider.of<BusinessDataProvider>(context, listen: false)
          .saveLeadBankDetail(postData);
      Navigator.of(context, rootNavigator: true).pop();

      if (productProvider.getSaveLeadBankDetailData != null) {
        productProvider.getSaveLeadBankDetailData!.when(
          success: (SaveBankDetailResponce) async {
            // Handle successful response
            var saveBankDetailResponce = SaveBankDetailResponce;
            if (saveBankDetailResponce.isSuccess!) {
              fetchData(context);
            } else {
              Utils.showToast(saveBankDetailResponce.message!, context);
            }
          },
          failure: (exception) {
            if (exception is ApiException) {
              if (exception.statusCode == 401) {
                productProvider.disposeAllProviderData();
                ApiService().handle401(context);
              } else {
                Utils.showToast(exception.errorMessage, context);
              }
            }
          },
        );
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
      leadCurrentActivityAsyncData =
          await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
              as LeadCurrentResponseModel?;

      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;

      customerSequence(
          context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
