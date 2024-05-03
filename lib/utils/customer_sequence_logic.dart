import 'package:flutter/material.dart';
import 'package:scale_up_module/utils/screen_type.dart';
import 'package:scale_up_module/view/Bank_details_screen/BankDetailsScreen.dart';
import 'package:scale_up_module/view/aadhaar_screen/aadhaar_screen.dart';
import 'package:scale_up_module/view/business_details_screen/business_details_screen.dart';
import 'package:scale_up_module/view/pancard_screen/PancardScreen.dart';
import 'package:scale_up_module/view/personal_info/PersonalInformation.dart';
import 'package:scale_up_module/view/profile_screen/components/credit_line_approved.dart';
import 'package:scale_up_module/view/dashboard_screen/my_account/my_account.dart';
import 'package:scale_up_module/view/splash_screen/model/GetLeadResponseModel.dart';
import 'package:scale_up_module/view/splash_screen/model/LeadCurrentResponseModel.dart';
import 'package:scale_up_module/view/take_selfi/take_selfi_screen.dart';
import '../view/agreement_screen/Agreementscreen.dart';
import '../view/login_screen/login_screen.dart';
import '../view/profile_screen/ProfileReview.dart';
import '../view/rejected/rejected_screen.dart';


ScreenType? customerSequence(
    BuildContext context,
    GetLeadResponseModel? getLeadData,
    LeadCurrentResponseModel? leadCurrentActivityAsyncData) {
  if ((getLeadData != null) && (leadCurrentActivityAsyncData != null)) {
    if (leadCurrentActivityAsyncData.currentSequence! != 0) {
      var currentSequence = leadCurrentActivityAsyncData.currentSequence!;
      print("sequence no.  ${currentSequence}");
      var leadCurrentActivity = leadCurrentActivityAsyncData.leadProductActivity!.firstWhere((product) => product.sequence == currentSequence);
      print("ACTIVITYnAME  ${leadCurrentActivity.activityName}");
      print("SubActivityName  ${leadCurrentActivity.subActivityName}");
      if (leadCurrentActivity.activityName == "MobileOtp") {
        print("11111");
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
        );
        return ScreenType.login;
      } else if (leadCurrentActivity.activityName == "KYC") {
        if (leadCurrentActivity.subActivityName == "Pan") {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PancardScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
          );
          return ScreenType.pancard;
        } else if (leadCurrentActivity.subActivityName == "Aadhar") {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AadhaarScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
          );
          return ScreenType.aadhar;
        } else if (leadCurrentActivity.subActivityName == "Selfie") {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TakeSelfieScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
          );
          return ScreenType.selfie;
        }
      } else if (leadCurrentActivity.activityName == "Bank Detail") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BankDetailsScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
        );
        return ScreenType.bankDetail;
      } else if (leadCurrentActivity.activityName == "PersonalInfo") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PersonalInformation(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
        );
        return ScreenType.personalInfo;
      } else if (leadCurrentActivity.activityName == "BusinessInfo") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BusinessDetailsScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
        );
        return ScreenType.businessInfo;
      } else if (leadCurrentActivity.activityName == "Inprogress") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProfileReview()),
        );
        return ScreenType.Inprogress;

      } else if (leadCurrentActivity.activityName == "Show Offer") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CreditLineApproved(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!,isDisbursement: false)),
        );
        return ScreenType.showoOffer;
      } else if (leadCurrentActivity.activityName == "Rejected") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RejectedScreen()),
        );
        return ScreenType.Rejected;
      }else if (leadCurrentActivity.activityName == "Agreement") {
        if (leadCurrentActivity.subActivityName == "AgreementEsign") {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AgreementScreen(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!)),
          );
          return ScreenType.AgreementEsign;
        }
      }else if (leadCurrentActivity.activityName == "Disbursement") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CreditLineApproved(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!,isDisbursement: true)),
        );
        return ScreenType.Disbursement;
      }
      else if (leadCurrentActivity.activityName == "Disbursement Completed") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CreditLineApproved(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!,isDisbursement: false,)),
        );
        return ScreenType.DisbursementCompleted;
      } else if (leadCurrentActivity.activityName == "MyAccount") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MyAccount()),
        );
        return ScreenType.DisbursementCompleted;
      }
    } else {
      return null;
    }
  } else {
    return null;
  }
}
