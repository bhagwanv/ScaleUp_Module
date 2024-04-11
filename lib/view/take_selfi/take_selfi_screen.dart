import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/utils/common_elevted_button.dart';
import 'package:scale_up_module/utils/constants.dart';
import 'package:scale_up_module/view/personal_info/PersonalInformation.dart';
import 'package:scale_up_module/view/take_selfi/camera_page.dart';

import '../../api/ApiService.dart';
import '../../data_provider/DataProvider.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/Utils.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/loader.dart';
import '../login_screen/login_screen.dart';
import '../splash_screen/model/GetLeadResponseModel.dart';
import '../splash_screen/model/LeadCurrentRequestModel.dart';
import '../splash_screen/model/LeadCurrentResponseModel.dart';
import 'model/PostLeadSelfieRequestModel.dart';

class TakeSelfieScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  TakeSelfieScreen(
      {super.key, required this.activityId, required this.subActivityId});

  @override
  State<TakeSelfieScreen> createState() => _TakeSelfieScreenState();
}

class _TakeSelfieScreenState extends State<TakeSelfieScreen> {
  var selfieImage = "";
  var isLoading = false;
  var frontDocumentId = 0;
  var isSelfieDelete = false;
  var isAgenSelfieDelete = false;

  void _handlePermissionsAccepted(XFile? picture) {
    setState(() {
      File file = File(picture!.path);

      uolpadSelfie(context, file);
    });
  }

  @override
  void initState() {
    super.initState();
    //Api Call
    getLeadSelfie(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: textFiledBackgroundColour,
      body: Consumer<DataProvider>(builder: (context, productProvider, child) {
        if (productProvider.getLeadSelfieData == null && isLoading) {
          return Loader();
        } else {
          if (productProvider.getLeadSelfieData != null && isLoading) {
            Navigator.of(context, rootNavigator: true).pop();
            isLoading = false;
          }
          if (productProvider.getLeadSelfieData != null) {
            if (productProvider.getLeadSelfieData!.frontImageUrl != null &&
                productProvider.getLeadSelfieData!.frontDocumentId != null &&
                !isSelfieDelete) {
              print("isSelfieDelete1$isSelfieDelete");
              selfieImage = productProvider.getLeadSelfieData!.frontImageUrl!;
              frontDocumentId =
                  productProvider.getLeadSelfieData!.frontDocumentId!;
            } else {
              if (productProvider.getPostSingleFileData != null) {
                if (productProvider.getPostSingleFileData!.filePath != null &&
                    productProvider.getPostSingleFileData!.docId != null &&
                    !isAgenSelfieDelete) {
                  selfieImage =
                      productProvider.getPostSingleFileData!.filePath!;
                  frontDocumentId =
                      productProvider.getPostSingleFileData!.docId!;
                }
              }
            }
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 50, right: 30, bottom: 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 69,
                        width: 51,
                        alignment: Alignment.topLeft,
                        child: Image.asset('assets/images/scale.png')),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Take a Selfie',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 35, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Position your face in the center of the\nframe. Make sure your face is well-lit and nclearly visible.',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              border:
                                  Border.all(color: kPrimaryColor, width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Center(
                            child: Container(
                                child: (!selfieImage.isEmpty)
                                    ? Stack(
                                        children: [
                                          Container(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                selfieImage,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 250,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  print("sdfsdfsf");
                                                  isSelfieDelete = true;
                                                  isAgenSelfieDelete = true;
                                                  selfieImage = "";
                                                });
                                              },
                                              child: Container(
                                                height: 250,
                                                width: 250,
                                                padding: EdgeInsets.all(4),
                                                alignment: Alignment.topRight,
                                                child: SvgPicture.asset(
                                                    'assets/icons/delete_icon.svg'),
                                              ))
                                        ],
                                      )
                                    : Container(
                                        child: SvgPicture.asset(
                                            'assets/images/take_selfie.svg'),
                                      )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    (selfieImage.isEmpty)
                        ? CommonElevatedButton(
                            onPressed: () async {
                              isAgenSelfieDelete = false;
                              final result = await availableCameras().then(
                                  (value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              CameraPage(cameras: value))));

                              // Handle the result from Screen B using the callback function
                              _handlePermissionsAccepted(result ?? "");
                            },
                            text: "Take a Selfie",
                            upperCase: true,
                          )
                        : CommonElevatedButton(
                            onPressed: () async {
                              if (!selfieImage.isEmpty) {
                                await postLeadSelfie(
                                    selfieImage, frontDocumentId);
                                if (productProvider
                                        .getPostLeadSelfieData?.statusCode !=
                                    401) {
                                  if (productProvider.getPostLeadSelfieData !=
                                      null) {
                                    if (productProvider
                                        .getPostLeadSelfieData!.isSuccess!) {
                                      fetchData(context);
                                    }
                                  }
                                } else {
                                  Navigator.pushAndRemoveUntil<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          LoginScreen(
                                              activityId: 1, subActivityId: 0),
                                    ),
                                    (route) =>
                                        false, //if you want to disable back feature set to false
                                  );
                                }
                              }
                            },
                            text: "Next",
                            upperCase: true,
                          ),
                  ]),
            ),
          );
        }
      }),
    ));
  }

  Future<void> getLeadSelfie(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    Provider.of<DataProvider>(context, listen: false).getLeadSelfie(userId!);
  }

  Future<void> uolpadSelfie(BuildContext context, File picture) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postSingleFile(picture, true, "", "");
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> postLeadSelfie(String selfieImage, int frontDocumentId) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    var postLeadSelfieRequestModel = PostLeadSelfieRequestModel(
      leadId: prefsUtil.getInt(LEADE_ID),
      userId: userId,
      activityId: widget.activityId,
      subActivityId: widget.subActivityId,
      frontImageUrl: selfieImage,
      frontDocumentId: frontDocumentId,
      companyId: prefsUtil.getInt(COMPANY_ID),
    );

    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postLeadSelfie(postLeadSelfieRequestModel);
    Navigator.of(context, rootNavigator: true).pop();
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
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        userId: prefsUtil.getString(USER_ID),
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
}
