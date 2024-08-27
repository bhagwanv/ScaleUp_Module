import 'package:flutter/material.dart';

import 'constants.dart';

class Loader extends StatefulWidget {
  const Loader({
    Key? key,
  }) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCustomDialog(context, "");
    });
  }
  void _showCustomDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 20.0,height: 60.0),
              new CircularProgressIndicator(),
              SizedBox(width: 20.0,height: 60.0),
              new Text(msg),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
