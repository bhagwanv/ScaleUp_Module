import 'package:flutter/material.dart';
import 'package:scale_up_module/utils/screen_type.dart';
import 'package:scale_up_module/view/Bank_details_screen/BankDetailsScreen.dart';
import 'package:scale_up_module/view/aadhaar_screen/aadhaar_screen.dart';
import 'package:scale_up_module/view/business_details/business_details.dart';
import 'package:scale_up_module/view/pancard_screen/PancardScreen.dart';
import 'package:scale_up_module/view/personal_info/PersonalInformation.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/view/splash_screen/model/LeadCurrentResponseModel.dart';
import 'package:scale_up_module/view/take_selfi/camera_selfie_open.dart';
import 'package:scale_up_module/view/take_selfi/take_selfi_screen.dart';
import '../view/login_screen/login_screen.dart';
import '../view/profile_screen/ProfileReview.dart';

ScreenType? customerSequence(
    BuildContext context,
    GetLeadResponseModel? getLeadData,
    LeadCurrentResponseModel? leadCurrentActivityAsyncData) {
  if ((getLeadData != null) && (leadCurrentActivityAsyncData != null)) {
    if (getLeadData.sequenceNo! != 0) {
      print("sequence no.  ${getLeadData.sequenceNo.toString()}");
      var leadCurrentActivity =
          leadCurrentActivityAsyncData.leadProductActivity!.firstWhere(
              (product) => product.sequence == getLeadData!.sequenceNo!);
      if (leadCurrentActivity.activityName == "MobileOtp") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
        );
        return ScreenType.login;
      } else if (leadCurrentActivity.activityName == "KYC") {
        if (leadCurrentActivity.subActivityName == "Pan") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PancardScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
          );
          return ScreenType.pancard;
        } else if (leadCurrentActivity.subActivityName == "Aadhar") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AadhaarScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
          );
          return ScreenType.aadhar;
        } else if (leadCurrentActivity.subActivityName == "Selfie") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TakeSelfieScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
          );
          return ScreenType.selfie;
        }
      } else if (leadCurrentActivity.activityName == "Bank Detail") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BankDetailsScreen()),
        );
        return ScreenType.bankDetail;
      } else if (leadCurrentActivity.activityName == "PersonalInfo") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PersonalInformation()),
        );
        return ScreenType.personalInfo;
      } else if (leadCurrentActivity.activityName == "BusinessInfo") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BusinessDetails()),
        );
        return ScreenType.businessInfo;
      } else if (leadCurrentActivity.activityName == "Inprogress") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileReview()),
        );
        return ScreenType.login;
      } else if (leadCurrentActivity.activityName == "Show Offer") {
       /* Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );*/
        return ScreenType.login;
      }
    } else {
      print("2222");
      return null;
    }
  } else {
    print("333333");
    return null;
  }
}
