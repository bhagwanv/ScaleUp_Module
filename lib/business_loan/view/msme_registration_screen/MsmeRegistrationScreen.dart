import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/business_loan/shared_preferences/SharedPref.dart';
import 'package:scale_up_module/business_loan/utils/Utils.dart';
import 'package:scale_up_module/business_loan/view/bank_details_screen/model/BankDetailsResponceModel.dart';
import 'package:scale_up_module/business_loan/view/bank_details_screen/model/LiveBankList.dart';
import 'package:scale_up_module/business_loan/view/bank_details_screen/model/SaveBankDetailsRequestModel.dart';
import 'package:scale_up_module/main.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../data_provider/DataProvider.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constants.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/LeadMSMEResModel.dart';
import 'model/PostLeadMSMEReqModel.dart';


class MsmeRegistrationScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final int sequenceNo;

  MsmeRegistrationScreen({
    super.key,
    required this.activityId,
    required this.subActivityId,
    required this.sequenceNo,
  });

  @override
  State<MsmeRegistrationScreen> createState() => _MsmeRegistrationScreenState();
}

class _MsmeRegistrationScreenState extends State<MsmeRegistrationScreen> {
  final TextEditingController _msmeRegNumCl = TextEditingController();
  final TextEditingController _businesNameCl = TextEditingController();
  final TextEditingController _vintageCl = TextEditingController();


  // var personalDetailsData;
  var isLoading = false;
  List<LiveBankList?>? liveBankList = [];
  late String selectedBusinessTypeValue = "";
  LeadMsmeResModel? leadMsmeResModel = null;
  var msmeCertificateUrl="";
  var doi="";
  var frontDocumentId=0;
  var isImageDelete=false;


  @override
  void initState() {
    super.initState();
    getLeadMSME(context);
  }


  List<String> BusinessTypeList = ['Proprietorship', 'Partnership', 'Private Ltd','LLP',"Trading","Menufacturing","Oters"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: Consumer<DataProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.getLeadMSMEData == null && isLoading) {
                  return Center(child: Loader());
                } else {
                  if (productProvider.getLeadMSMEData != null && isLoading) {
                    Navigator.of(context, rootNavigator: true).pop();
                    isLoading = false;
                  }

                  if (productProvider.getLeadMSMEData != null) {
                    productProvider.getLeadMSMEData!.when(
                      success: (data) async {
                        leadMsmeResModel = data;
                        if (leadMsmeResModel != null) {

                          if(leadMsmeResModel!.msmeRegNum!=null){
                            _msmeRegNumCl.text=leadMsmeResModel!.msmeRegNum!;
                          }

                          if(leadMsmeResModel!.businessName!=null){
                            _businesNameCl.text=leadMsmeResModel!.businessName!;
                          }

                          if(leadMsmeResModel!.businessType!=null){
                            selectedBusinessTypeValue=leadMsmeResModel!.businessType!;
                          }


                          if(leadMsmeResModel!.doi!=null){
                            doi=leadMsmeResModel!.doi!;
                          }
                          if(leadMsmeResModel!.frontDocumentId!=null){
                            frontDocumentId=leadMsmeResModel!.frontDocumentId!;
                          }
                          if(leadMsmeResModel!.vintage!=null){
                            _vintageCl.text=leadMsmeResModel!.vintage!.toString();
                          }
                          if(leadMsmeResModel!.msmeCertificateUrl!=null && !isImageDelete){
                            msmeCertificateUrl=leadMsmeResModel!.msmeCertificateUrl!;
                          }

                        }
                      },
                      failure: (exception) {
                        if (exception is ApiException) {
                          if(exception.statusCode==401){
                            productProvider.disposeAllProviderData();
                            ApiService().handle401(context);
                          }else{
                            Utils.showToast(exception.errorMessage,context);
                          }
                        }
                      },
                    );
                  }

                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "MSME Registration Verification",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: blackSmall,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),

                          Text(
                            "Udyam Registration number",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),

                          CommonTextField(
                              enabled: true,
                            controller: _msmeRegNumCl,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.characters,
                              maxLines: 1,
                              inputFormatter: [
                                LengthLimitingTextInputFormatter(19), // Limit the input to 19 characters
                              ],
                            hintText: "UDYAM-XX-00-0000000",
                            labelText: "UDYAM-XX-00-0000000",
                              onChanged: (value) {
                                String formattedInput = value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
                                if (formattedInput.length >= 6 && !formattedInput.substring(5, 6).contains('-')) {
                                  formattedInput = formattedInput.substring(0, 5) + '-' + formattedInput.substring(5);
                                }

                                if (formattedInput.length >= 9 && !formattedInput.substring(8, 9).contains('-')) {
                                  formattedInput = formattedInput.substring(0, 8) + '-' + formattedInput.substring(8);
                                }

                                if (formattedInput.length >= 12 && !formattedInput.substring(11, 12).contains('-')) {
                                  formattedInput = formattedInput.substring(0, 11) + '-' + formattedInput.substring(11);
                                }
                                if (formattedInput.length > 19) {
                                  formattedInput = formattedInput.substring(0, 19);
                                }
                                _msmeRegNumCl.value = TextEditingValue(
                                  text: formattedInput,
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: formattedInput.length), // Maintain cursor position
                                  ),
                                );
                              }
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          CommonTextField(
                            inputFormatter: [
                              LengthLimitingTextInputFormatter(17),
                              // Limit to 10 characters
                            ],
                            keyboardType: TextInputType.text,
                            controller: _businesNameCl,
                            maxLines: 1,
                            hintText: "Business Name",
                            labelText: "Business Name",
                          ),
                          SizedBox(
                            height: 16.0,
                          ),

                          selectBusinessTypeWidget(productProvider),

                          SizedBox(
                            height: 16.0,
                          ),

                          CommonTextField(
                            inputFormatter: [
                              LengthLimitingTextInputFormatter(17),
                              // Limit to 10 characters
                            ],
                            keyboardType: TextInputType.number,
                            controller: _vintageCl,
                            maxLines: 1,
                            hintText: "Vintage(in Month)",
                            labelText: "Vintage(in Month)",
                          ),

                          SizedBox(
                            height: 16.0,
                          ),
                          Stack(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Color(0xff0196CE))),
                                  width: double.infinity,
                                  child: GestureDetector(
                                      onTap: () async {
                                        if(msmeCertificateUrl.isEmpty) {
                                          await uoploadPDF(
                                              context, productProvider);
                                        }else{
                                          await downloadFile();

                                        }
                                      },
                                    child: Container(
                                      height: 148,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xffEFFAFF),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: (!msmeCertificateUrl.isEmpty)
                                          ? Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: SvgPicture.asset('assets/images/ic_pdf.svg',height: 10,width: 10,),
                                          )
                                          : (msmeCertificateUrl.isNotEmpty)
                                          ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: const Color(0xff0196CE))),
                                        width: double.infinity,

                                      )
                                          : Container(
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
                                            SvgPicture.asset('assets/images/gallery.svg'),
                                            const Text(
                                              'Upload Bank Proof',
                                              style: TextStyle(
                                                  color: Color(0xff0196CE), fontSize: 12),
                                            ),
                                            const Text('Supports : PDF',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xffCACACA))),

                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isImageDelete = true;
                                    msmeCertificateUrl = "";
                                  });
                                },
                                child: !msmeCertificateUrl.isEmpty
                                    ? Container(
                                  padding: EdgeInsets.all(4),
                                  alignment: Alignment.topRight,
                                  child: SvgPicture.asset(
                                      'assets/icons/delete_icon.svg'),
                                )
                                    : Container(),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 16.0,
                          ),



                         /* documentList!.isNotEmpty
                              ?
                          Column(
                            children:
                            documentList!.asMap().entries.map((entry) {
                              final index = entry.key;
                              final document = entry.value;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
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
                                              documentList!.removeAt(index);
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
                              : Container(),*/
                          SizedBox(
                            height: 30.0,
                          ),
                          CommonElevatedButton(
                            onPressed: () async {
                              await submitpostLeadMSMEApi(
                                  context, productProvider);

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

  Widget selectBusinessTypeWidget(DataProvider productProvider) {

    return DropdownButtonFormField2<String>(
      value: selectedBusinessTypeValue.isEmpty || selectedBusinessTypeValue == null ? null: selectedBusinessTypeValue,
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
      hint: Text('Business Type',
        style: TextStyle(
          color: blueColor,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      items: _addDividersAfterItems(BusinessTypeList),
      onChanged: (String? value) {
        selectedBusinessTypeValue = value!;
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      dropdownStyleData: const DropdownStyleData(
        maxHeight: 200,
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        customHeights: _getCustomItemsHeights(BusinessTypeList),
      ),
      iconStyleData: const IconStyleData(
        openMenuIcon: Icon(Icons.arrow_drop_up),
      ),
    );
  }

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
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  Future<void> getLeadMSME(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);

    //String? userId = "0ae22741-5bba-48e8-a768-569beebaabfa";
    //final String? productCode = "BusinessLoan";
    Provider.of<DataProvider>(context, listen: false).getLeadMSME(userId!,productCode!);

  }

  Future<void> submitpostLeadMSMEApi(BuildContext context, DataProvider productProvider,) async {
    if (_msmeRegNumCl.text.isEmpty) {
      Utils.showToast("Please Enter MSME Registration Number", context);
    } else if (_businesNameCl!.text.isEmpty) {
      Utils.showToast("Please Enter Business Name", context);
    }  else if (selectedBusinessTypeValue.isEmpty) {
      Utils.showToast("Please Select Business Type", context);
    } else if (_vintageCl.text.isEmpty) {
      Utils.showToast("Please Vintage Month", context);
    } else if (msmeCertificateUrl.isEmpty) {
      Utils.showToast("Please Upload Pdf Document", context);
    } else {
      final prefsUtil = await SharedPref.getInstance();
      final int? leadID = prefsUtil.getInt(LEADE_ID);
      final String? userId = prefsUtil.getString(USER_ID);
      final int? companyId = prefsUtil.getInt(COMPANY_ID);

      var postLeadMsmeReqModel = PostLeadMsmeReqModel(
          doi:doi,
          msmeCertificateUrl:msmeCertificateUrl,
          msmeRegNum:_msmeRegNumCl.text,
          frontDocumentId:frontDocumentId,
          businessName:_businesNameCl.text,
          businessType:selectedBusinessTypeValue,
          vintage:int.parse(_vintageCl.text),
          leadMasterId:leadID,
          sequenceNo:widget.sequenceNo,
          leadId:leadID,
          userId:userId,
          activityId:widget.activityId,
          subActivityId:widget.subActivityId,
          companyId:companyId
      );

      print("Save Data"+postLeadMsmeReqModel.toJson().toString());
      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context, listen: false).postLeadMSME(postLeadMsmeReqModel);
      Navigator.of(context, rootNavigator: true).pop();
      if (productProvider.getPostLeadMSMEData != null) {
        productProvider.getPostLeadMSMEData!.when(
          success: (data) async {
            // Handle successful response
            var postLeadMSMEData = data;
            if (postLeadMSMEData.isSuccess!) {
              fetchData(context);
            } else {
              Utils.showToast(postLeadMSMEData.message!, context);
            }
          },
          failure: (exception) {
            if (exception is ApiException) {
              if(exception.statusCode==401){
                productProvider.disposeAllProviderData();
                ApiService().handle401(context);
              }else{
                Utils.showToast(exception.errorMessage,context);
              }
            }
          },
        );
      }
    }
  }

  Future<void> uoploadPDF(BuildContext context, DataProvider productProvider) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (result != null) {
      File file = File(result.files.single.path!);
      print(file.path);
      //widget.onImageSelected(file);


      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context,
          listen: false)
          .postBusineesDoumentSingleFile(
          file, true, "", "");
      if (productProvider.getpostBusineesDoumentSingleFileData != null) {
        msmeCertificateUrl=productProvider.getpostBusineesDoumentSingleFileData!.filePath!;
        print("aaaaa$msmeCertificateUrl");
      }
      setState(() {
        Navigator.pop(context);
      });
    } else {
      // User canceled the picker
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

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

  Future<void> downloadFile() async {
    var dl = DownloadManager();
    bool dirDownloadExists = true;
    var directory;
    if (Platform.isIOS) {
      directory = await getDownloadsDirectory();
    } else {
      directory = "/storage/emulated/0/Download/";

      dirDownloadExists = await Directory(directory).exists();
      if(dirDownloadExists){
        directory = "/storage/emulated/0/Download/";
      }else{
        directory = "/storage/emulated/0/Downloads/";
      }
    }

    var currentDate = "Scaleup_msme_"+convertCurrentDateTimeToString();
    final path = '$directory$currentDate.pdf';
    dl.addDownload(msmeCertificateUrl, path);
    await dl.whenDownloadComplete(msmeCertificateUrl);
    //_showProgressNotification();
    print("path$path");

  }

  String convertCurrentDateTimeToString() {
    return DateFormat('yyyyMMdd_kkmmss').format(DateTime.now());
  }

/*  Future<void> showDownloadNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'download_channel_id',
      'Downloads',
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Download Complete',
      'Your PDF file has been downloaded successfully',
      platformChannelSpecifics,
      payload: 'Downloaded File',
    );
  }*/

/*  Future<void> _showProgressNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('progress channel', 'progress channel',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'PDF file has been download',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }*/



}

