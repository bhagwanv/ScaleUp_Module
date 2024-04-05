import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class CheckboxTerm extends StatefulWidget {
  const CheckboxTerm({super.key});

  @override
  State<CheckboxTerm> createState() => _CheckboxTermState();
}

class _CheckboxTermState extends State<CheckboxTerm> {
  bool isChecked = false;

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

    return Row(children: [
      Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        side: const BorderSide(color: kPrimaryColor),
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),
      const Text(
        'Terms & Conditions. ',
        style: TextStyle(fontSize: 14.0),
      ),
    ]);
  }
}