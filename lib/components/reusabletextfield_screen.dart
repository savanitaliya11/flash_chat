import 'package:flash_chat_app/components/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// typedef OnValidate = Function(String);

class ReusableTextField extends StatelessWidget {
  String hintText;
  String label;
  final TextEditingController controller;
  ReusableTextField({
    required this.hintText,
    required this.label,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
          validator: (String? value) {
            if (value!.isEmpty) {
              return '*Mandatory';
            } else {
              return null;
            }
          },
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText, //'xyz@gmail.com',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              labelText: label //'Username',
              ),
          style: textfieldTextStyle),
    );
  }
}
