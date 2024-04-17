import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class CheckboxTerm extends StatefulWidget {
  final String? content;
  bool isChecked = false;
  final ValueChanged<bool>? onChanged;

  CheckboxTerm({super.key, this.content, this.isChecked = false, this.onChanged});

  @override
  State<CheckboxTerm> createState() => _CheckboxTermState();
}

class _CheckboxTermState extends State<CheckboxTerm> {

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Checkbox(
        checkColor: Colors.white,
        value: widget.isChecked,
        side: const BorderSide(color: kPrimaryColor),
        onChanged: (bool? value) {
          setState(() {
            widget.isChecked = value!;
            widget.onChanged!(value);
          });
        },
      ),
          Expanded(
        child: Text(
          widget.content ?? "",
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    ]);
  }
}