import 'package:flash_chat_app/components/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Roundbutton extends StatelessWidget {
  final String title;
  final Color primary;
  final Color onPrimary;
  final Function onpress;
  Roundbutton(
      {required this.title,
      required this.onpress,
      required this.primary,
      required this.onPrimary});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(100, 50),
            side: BorderSide(color: Colors.black, width: 1.9),
            elevation: 8,
            shadowColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPrimary: onPrimary, //Colors.black,
            primary: primary //Colors.blue
            ),
        onPressed: () {
          onpress();
        },
        child: Text(title, style: roundedTextstyle),
      ),
    );
  }
}
