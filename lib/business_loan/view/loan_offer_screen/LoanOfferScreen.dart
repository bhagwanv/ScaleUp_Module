import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/business_loan/api/ApiService.dart';
import 'package:scale_up_module/business_loan/api/FailureException.dart';
import 'package:scale_up_module/business_loan/utils/common_elevted_button.dart';
import 'package:scale_up_module/business_loan/utils/loader.dart';

import '../../../business_loan/data_provider/DataProvider.dart';
import '../../../business_loan/utils/Utils.dart';
import '../../../business_loan/utils/constants.dart';
import '../../shared_preferences/SharedPref.dart';
import 'loan_offer_otp_screen.dart';
import 'model/LeadMasterByLeadIdResModel.dart';

class LoanOfferScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final String? pageType;

  const LoanOfferScreen(
      {super.key,
      required this.activityId,
      required this.subActivityId,
      this.pageType});

  @override
  State<LoanOfferScreen> createState() => _LoanOfferScreenState();
}

class _LoanOfferScreenState extends State<LoanOfferScreen> {
  var isLoading = false;
  late List<String> listData;
  double _sliderValue = 0.0;
  var nameOnCard = "";
  List<bool> isSelected = [false, true];
  bool _toggleValue = true;
  bool _isToggled = false;
  double sliderValue = 0;
  double newavalue=0.0;


  @override
  void initState() {
    super.initState();
    // Initialize the list with dummy data
    listData = List<String>.generate(20, (index) => 'Item ${index + 1}');
    getLeadMasterByLeadId(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        debugPrint("didPop1: $didPop");
        if (didPop) {
          return;
        }
        if (widget.pageType == "pushReplacement") {
          final bool shouldPop = await Utils().onback(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Consumer<DataProvider>(
              builder: (context, productProvider, child) {
            if (productProvider.getLeadMasterByLeadIdData == null &&
                isLoading) {
              return Loader();
            } else {
              if (productProvider.getLeadMasterByLeadIdData != null &&
                  isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }

              if (productProvider.getLeadMasterByLeadIdData != null) {
                productProvider.getLeadMasterByLeadIdData!.when(
                  success: (data) {
                    // Handle successful response
                    var leadMasterByLeadId = data;
                    if (leadMasterByLeadId.nameOnCard != null) {
                      nameOnCard = leadMasterByLeadId.nameOnCard!;
                    }
                    if (leadMasterByLeadId.nameOnCard != null) {
                      nameOnCard = leadMasterByLeadId.nameOnCard!;
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

              if (productProvider.getRateOfInterestData != null) {
                productProvider.getRateOfInterestData!.when(
                  success: (data) {
                    // Handle successful response
                    var rateOfInterestData = data;
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

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: Text(
                            "loan Offer",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: blackSmall,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Center(
                          child: Text(
                            "$nameOnCard",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: dark_green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Center(
                          child: Text(
                            "You are qualified for credit limit of",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Center(
                          child: Text(
                            "₹50,000,00",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 4,
                          color: Colors.white,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the value to change the roundness
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text('Total Loan Amount',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ),
                                        Flexible(
                                          child: Text('₹500000',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Center(
                                      child: Container(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          LinearProgressIndicator(
                                            backgroundColor: light_gray,
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(kPrimaryColor),
                                            value: 0.5,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SvgPicture.asset(
                                            'assets/images/ic_scale_view.svg',
                                            semanticsLabel: 'document',
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ],
                                      )),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text('Interest Rate',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ),
                                        Flexible(
                                          child: Text('11%',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Center(
                                      child: Container(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          LinearProgressIndicator(
                                            backgroundColor: light_gray,
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(kPrimaryColor),
                                            value: 0.5,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SvgPicture.asset(
                                            'assets/images/ic_scale_view.svg',
                                            semanticsLabel: 'document',
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ],
                                      )),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text('Loan Tenure',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ),
                                        Row(
                                          children: [
                                            Text('${newavalue.toInt()}',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isToggled = !_isToggled;
                                                });
                                              },
                                              child: Container(
                                                width: 70,
                                                // Increased width to accommodate text
                                                height: 25,
                                                // Adjust height for better appearance
                                                decoration: BoxDecoration(
                                                  color: togel_color,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5),
                                                  border: Border.all(
                                                    color: kPrimaryColor,
                                                    // Outline border color
                                                    width:
                                                        1.0, // Outline border width
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    AnimatedPositioned(
                                                      duration: Duration(
                                                          milliseconds: 200),
                                                      curve: Curves.easeIn,
                                                      left:
                                                          _isToggled ? 35 : 0,
                                                      // Adjusted position for the text
                                                      right:
                                                          _isToggled ? 0 : 35,
                                                      child: Container(
                                                        width: 35,
                                                        // Adjusted width for the thumb
                                                        height: 23,
                                                        // Adjusted height for the thumb
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _isToggled
                                                              ? kPrimaryColor
                                                              : kPrimaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            _isToggled
                                                                ? 'Mo'
                                                                : 'Yr',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: _isToggled
                                                          ? Alignment
                                                              .centerLeft
                                                          : Alignment
                                                              .centerRight,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(
                                                          _isToggled
                                                              ? 'Yr'
                                                              : 'Mo',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),



                                    Container(
                                      width: double.infinity, // Ensures the slider takes full width of its parent
                                      child: Column(
                                        children: [
                                          Theme(
                                            data: Theme.of(context).copyWith(
                                              sliderTheme: SliderThemeData(
                                                thumbShape: SquareSliderComponentShape(),
                                                trackShape: MyRoundedRectSliderTrackShape(),
                                              ),
                                            ),
                                            child: Slider(
                                              onChanged: (value) =>
                                                  setState(() {
                                                    sliderValue = value;

                                                     newavalue=value/20;
                                                    print("newValue$newavalue");
                                                  }),

                                              value: sliderValue,
                                              divisions: 5,
                                              min: 0,
                                              max: 100,
                                              activeColor: kPrimaryColor,
                                              inactiveColor: light_gray,
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20),
                                            child: SvgPicture.asset(
                                              'assets/images/ic_scale_view.svg',
                                              semanticsLabel: 'document',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),



                                  ],
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                color: kPrimaryColor, // Border color
                                width: 1, // Border width
                              ),
                            ),
                            child: Text('View EMI',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text('Loan Repayment Schedule  ',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        Table(
                          border: TableBorder.all(
                            color: tabel_border_color,
                            width: 1,
                          ),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(),
                              // Use BoxDecoration for table row decoration
                              children: [
                                TableCell(
                                  child: Container(
                                    height: 40,
                                    // Ensure height is consistent across cells
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                        child: Text('Month/Year',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                            ))),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: tabel_cell_color,
                                    ),
                                    child: Center(
                                        child: Text('Principal',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                            ))),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                        child: Text('Interest',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                            ))),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: tabel_cell_color,
                                    ),
                                    child: Center(
                                        child: Text('Total Payment',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                            ))),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                        child: Text('Balance',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                            ))),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: tabel_cell_color,
                                    ),
                                    child: Center(
                                        child: Text('Loan Paid',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                            ))),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 100,
                          child: _myListView(context, listData),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: kPrimaryColor, // Border color
                              width: 1, // Border width
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/ic_document.svg',
                                semanticsLabel: 'document',
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Download repayment schedule',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        CommonElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoanOfferOtpScreen(
                                        activityId: 0,
                                        subActivityId: 0,
                                        requestId: '',
                                      )),
                            );
                          },
                          text: "Proceed to sign agreement",
                          upperCase: true,
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
    ;
  }

  Widget _myListView(BuildContext context, List<String> listData) {
    if (listData.isEmpty) {
      // Return a widget indicating that the list is empty or null
      return Center(
        child: Text('No data available'),
      );
    }

    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index) {
        return Table(
          border: TableBorder.all(
            color: tabel_border_color,
            width: 1,
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(),
              // Use BoxDecoration for table row decoration
              children: [
                TableCell(
                  child: Container(
                    height: 40, // Ensure height is consistent across cells
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                        child: Text('Sep 05, 2023',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 8,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ))),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: tabel_cell_color,
                    ),
                    child: Center(
                        child: Text('₹30,284',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 8,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ))),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                        child: Text('₹1,49,661',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 8,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ))),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: tabel_cell_color,
                    ),
                    child: Center(
                        child: Text('₹1,76,945',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 8,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ))),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                        child: Text('₹49,69,716',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 8,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ))),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: tabel_cell_color,
                    ),
                    child: Center(
                        child: Text('0.61%',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 8,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ))),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> getLeadMasterByLeadId(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    //final int? leadId = prefsUtil.getInt(LEADE_ID);
    final int? leadId = 431;

    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false)
        .getLeadMasterByLeadId(leadId!);
  }

  Future<void> getRateOfInterest(BuildContext context, String pancardNumber,
      DataProvider productProvider, int tenure) async {
    Utils.hideKeyBored(context);
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getRateOfInterest(tenure);
    Navigator.of(context, rootNavigator: true).pop();
  }
}


class RectSliderThumbShape extends SliderComponentShape {
  const RectSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 4.0,
  });

  final double enabledThumbRadius;
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;
  final double elevation;
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor!,
      end: sliderTheme.thumbColor!,
    );

    final Color color = colorTween.evaluate(enableAnimation)!;
    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
    elevationTween.evaluate(activationAnimation);

    // Calculate the size of the rectangular thumb
    final double thumbWidth = 0.7 * radius;
    final double thumbHeight = 2 * radius; // Adjust height as needed

    // Draw rectangular thumb
    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: thumbWidth,
      height: thumbHeight,
    );

    bool paintShadows = true;
    assert(() {
      if (debugDisableShadows) {
        paintShadows = false;
      }
      return true;
    }());

    if (paintShadows) {
      canvas.drawShadow(
        Path()..addRect(thumbRect),
        Colors.black,
        evaluatedElevation,
        true,
      );
    }

    canvas.drawRect(
      thumbRect,
      Paint()..color = color,
    );
  }
}
class SquareSliderComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(20, 30);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    canvas.drawShadow(
        Path()
          ..addRRect(RRect.fromRectAndRadius(
            Rect.fromCenter(center: center, width: 10, height: 30),
            const Radius.circular(4),
          )),
        Colors.black,
        5,
        false);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 10, height: 30),
        const Radius.circular(4),
      ),
      Paint()..color = kPrimaryColor,
    );
  }
}

class MyRoundedRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const MyRoundedRectSliderTrackShape();

  @override
  void paint(PaintingContext context, Offset offset, {required RenderBox parentBox, required SliderThemeData sliderTheme, required Animation<double> enableAnimation, required Offset thumbCenter, Offset? secondaryOffset, bool isEnabled = false, bool isDiscrete = false, required TextDirection textDirection, double additionalTrackHeight = 1}) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius activeTrackRadius =
    Radius.circular((trackRect.height + additionalTrackHeight) / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top - (additionalTrackHeight / 2),
        thumbCenter.dx,
        trackRect.bottom + (additionalTrackHeight / 2),
        topLeft: activeTrackRadius,
        bottomLeft: activeTrackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        trackRect.top - (additionalTrackHeight / 2),
        trackRect.right,
        trackRect.bottom + (additionalTrackHeight / 2),
        topRight: activeTrackRadius,
        bottomRight: activeTrackRadius,
      ),
      rightTrackPaint,
    );

  }

}
