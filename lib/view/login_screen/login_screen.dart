import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scale_up_module/data_provider/DataProvider.dart';
import 'package:scale_up_module/responsive/Responsive.dart';
import '../../shared_preferences/SharedPref.dart';
import '../../utils/constants.dart';
import 'Background.dart';
import 'components/LoginForm.dart';

/*class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  SingleChildScrollView(child: LoginScreen());
  }

}*/

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<DataProvider>(
          builder: (context, productProvider, child) {
          return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    LoginScreenTopImage(),
                    Row(
                      children: [
                        Spacer(),
                        Expanded(
                          flex: 8,
                          child: LoginForm(productProvider: productProvider),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage( {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 100, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30, top: 50),
            child: Text(
              "Enter\nPhone Number",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 35.5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 30),
            child: Text(
              "Please Enter Your registered number.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 30),
            child: Text(
              "Enter Your Number",
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 14, color: gryColor),
              textAlign: TextAlign.start,
            ),
          ),
          Row(
            children: [
              Spacer(),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
