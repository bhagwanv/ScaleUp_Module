import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

class CommonCheckBox extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final String? text;
  final bool upperCase;

  CommonCheckBox({
    Key? key,
    this.onChanged,
    this.text,
    this.upperCase = false,
  }) : super(key: key);

  @override
  _CommonCheckBoxState createState() => _CommonCheckBoxState();
}

class _CommonCheckBoxState extends State<CommonCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          widget.onChanged?.call(isChecked);
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: isChecked
                  ? Container(
                color: (kPrimaryColor),
                child: Icon(
                  Icons.check,
                  size: 18.0,
                  color: Colors.white,
                ),

              )
                  : Container(),
            ),
            SizedBox(width: 18.0),
            Expanded(
              child: Text(
                widget.upperCase ? widget.text!.toUpperCase() : widget.text!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}