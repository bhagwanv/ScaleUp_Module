import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
import 'model/LeadMasterByLeadIdResModel.dart';

class LoanOfferScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final String?  pageType;
  const LoanOfferScreen({super.key,required this.activityId, required this.subActivityId, this.pageType});

  @override
  State<LoanOfferScreen> createState() => _LoanOfferScreenState();
}

class _LoanOfferScreenState extends State<LoanOfferScreen> {
  var isLoading = false;
  late List<String> listData;
  double _sliderValue = 0.0;
  var nameOnCard="";



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
        if(widget.pageType == "pushReplacement" ) {
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
                if (productProvider.getLeadMasterByLeadIdData == null && isLoading) {
                  return Loader();
                } else {
                  if (productProvider.getLeadMasterByLeadIdData != null && isLoading) {
                    Navigator.of(context, rootNavigator: true).pop();
                    isLoading = false;



                  }

                  if (productProvider.getLeadMasterByLeadIdData != null) {
                    productProvider.getLeadMasterByLeadIdData!.when(
                      success: (data) {
                        // Handle successful response
                       var leadMasterByLeadId = data;
                       if(leadMasterByLeadId.nameOnCard!=null){
                         nameOnCard=leadMasterByLeadId.nameOnCard!;
                       }
                       if(leadMasterByLeadId.nameOnCard!=null){
                         nameOnCard=leadMasterByLeadId.nameOnCard!;
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


                  if (productProvider.getRateOfInterestData != null) {
                    productProvider.getRateOfInterestData!.when(
                      success: (data) {
                        // Handle successful response
                        var rateOfInterestData = data;


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

                  return SingleChildScrollView(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                                  color:Colors.black,
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
                                              child: Text(
                                                  'Total Loan Amount',
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
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  LinearProgressIndicator(
                                                    backgroundColor: light_gray,
                                                    valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                                    value: 0.5,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/images/ic_scale_view.svg',
                                                    semanticsLabel: 'document',
                                                    width: MediaQuery.of(context).size.width,
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),


                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  'Interest Rate',
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
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  LinearProgressIndicator(
                                                    backgroundColor: light_gray,
                                                    valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                                    value: 0.5,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/images/ic_scale_view.svg',
                                                    semanticsLabel: 'document',
                                                    width: MediaQuery.of(context).size.width,
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  'Loan Tenure',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                            ),
                                            Flexible(
                                              child: Text('5',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ),
                                          ],
                                        ),

                                        /*Center(
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                                      _updateProgress(details.localPosition, context);
                                    },
                                    child: Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 5.0,
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.grey[200],
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                            value: _progress,
                                            minHeight: 10.0,
                                          ),
                                        ),
                                        Positioned(// Adjust to center the handle
                                          child: GestureDetector(
                                            onPanUpdate: (DragUpdateDetails details) {
                                              _updateProgress(details.localPosition, context);
                                            },
                                            child: SvgPicture.asset(
                                              'assets/icons/progrssbar_rectangle.svg',
                                              semanticsLabel: 'document',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/ic_scale_view.svg',
                                    semanticsLabel: 'document',
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ],
                              ),
                            ),
                          ),*/

                                        /*  SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 10, // Radius of the thumb when enabled
                                disabledThumbRadius: 5, // Radius of the thumb when disabled
                              ),
                            //  overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                              // Other properties you want to customize
                            ),
                            child: Slider(
                              value: _sliderValue,
                              min: 0.0,
                              max: 100.0,
                              divisions: 10,
                              onChanged: (double value) {
                                setState(() {
                                  _sliderValue = value;
                                });
                              },
                            ),
                          )*/

                                        SliderTheme(
                                          data: const SliderThemeData(
                                              thumbColor: kPrimaryColor,
                                              thumbShape: RectSliderThumbShape()
                                          ),
                                          child: Slider(
                                            value: _sliderValue,
                                            max: 100,
                                            divisions: 5,
                                            // label: _currentSliderValue.round().toString(),
                                            onChanged: (double value) {
                                              setState(() {
                                                _sliderValue = value;
                                              });
                                            },
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
                                    width: 1,           // Border width
                                  ),
                                ),
                                child: Text(
                                    'View EMI',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),),
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
                                  decoration: BoxDecoration(), // Use BoxDecoration for table row decoration
                                  children: [
                                    TableCell(
                                      child: Container(
                                        height: 40, // Ensure height is consistent across cells
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Center(child: Text('Month/Year' ,
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
                                          color:tabel_cell_color,
                                        ),
                                        child: Center(child: Text('Principal',
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
                                        child: Center(child: Text('Interest',
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
                                        child: Center(child: Text('Total Payment',
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
                                        child: Center(child: Text('Balance',
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
                                        child: Center(child: Text('Loan Paid',
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
                              child: _myListView(context,listData),),

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
                                  width: 1,           // Border width
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
    );;
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
              decoration: BoxDecoration(), // Use BoxDecoration for table row decoration
              children: [
                TableCell(
                  child: Container(
                    height: 40, // Ensure height is consistent across cells
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(child: Text('Sep 05, 2023',
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
                    child: Center(child: Text('₹30,284',
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
                    child: Center(child: Text('₹1,49,661',
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
                    child: Center(child: Text('₹1,76,945',
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
                    child: Center(child: Text('₹49,69,716',
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
                    child: Center(child: Text('0.61%',
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
    final int? leadId =431;

    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false).getLeadMasterByLeadId(leadId!);
  }

  Future<void> getRateOfInterest(BuildContext context, String pancardNumber,
      DataProvider productProvider,int tenure) async {
    Utils.hideKeyBored(context);
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getRateOfInterest(tenure);
    Navigator.of(context, rootNavigator: true).pop();
  }
}


class RectSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a Rect.
  const RectSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 4.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// [enabledThumbRadius]
  final double? disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  ///
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
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
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final Color color = colorTween.evaluate(enableAnimation)!;
    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation = elevationTween.evaluate(activationAnimation);
    final Path path = Path()
      ..addArc(Rect.fromCenter(center: center, width: 10 * radius, height: 6 * radius), 0,0);

    bool paintShadows = true;
    assert(() {
      if (debugDisableShadows) {
        paintShadows = false;
      }
      return true;
    }());

    if (paintShadows) {
      canvas.drawShadow(path, Colors.black, evaluatedElevation, true);
    }

    // Use drawRect instead of drawCircle
    canvas.drawRect(Rect.fromCircle(center: center, radius: radius),
      Paint()..color = color,
    );
  }

}

