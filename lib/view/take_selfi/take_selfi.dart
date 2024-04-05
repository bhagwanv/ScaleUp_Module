import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scale_up_module/utils/common_elevted_button.dart';
import 'package:scale_up_module/utils/constants.dart';
import 'package:scale_up_module/view/personal_info/PersonalInformation.dart';
import 'package:scale_up_module/view/take_selfi/camera_page.dart';

class TakeSelfie extends StatelessWidget {
  final XFile? picture;

  const TakeSelfie({super.key, this.picture});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      backgroundColor: textFiledBackgroundColour,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, top: 50, right: 30, bottom: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      border: Border.all(color: kPrimaryColor, width: 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (picture != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(picture!.path),
                                fit: BoxFit.cover,
                                width: 245,
                                height: 245,
                              ),
                            )
                          : Container(
                              child: SvgPicture.asset(
                                  'assets/images/take_selfie.svg'),
                            )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            (picture == null)
                ? CommonElevatedButton(
                    onPressed: () async {
                      await availableCameras().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CameraPage(cameras: value))));
                    },
                    text: "Take a Selfie",
                    upperCase: true,
                  )
                : CommonElevatedButton(
                    onPressed: () async {
                      await availableCameras().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PersonalInformation())));
                    },
                    text: "Next",
                    upperCase: true,
                  ),
          ]),
        ),
      ),
    ));
  }
}
