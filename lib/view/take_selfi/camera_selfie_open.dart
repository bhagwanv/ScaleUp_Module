import 'package:flutter/material.dart';

class TakeCameraSelfie extends StatefulWidget {
  const TakeCameraSelfie({super.key});

  @override
  State<TakeCameraSelfie> createState() => _TakeCameraSelfieState();
}

class _TakeCameraSelfieState extends State<TakeCameraSelfie> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Center(child:
        Column(
          children: [


          ],)
        ),
      ),
    ));
  }
}
