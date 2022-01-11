// ignore_for_file: prefer_const_constructors

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat_app/components/constant.dart';
import 'package:flash_chat_app/components/rounded_btn.dart';
import 'package:flash_chat_app/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    //Curved animation
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    //Twin animation
    //animation = Tween<double>(begin: 50.0, end: 100.0).animate(controller);

    // animation =
    //     ColorTween(begin: Colors.red, end: Colors.white).animate(controller);

    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.addListener(() {
      setState(() {}); // print(animation.value);
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Hero(
                    tag: 'Hero',
                    child: Image.asset(
                      'images/logo.png',
                      height: animation.value * 100,
                      // width: 100,
                       width: 80.0,
                    ),
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText('Flash Chat',
                      textStyle: titleTextStyle),
                ])
              ],
            ),

            SizedBox(
              height: sizeBoxHeight,
            ),

            //Log in
            Roundbutton(
              title: 'Log In',
              onPrimary: Colors.black,
              primary: Colors.blue.shade300,
              onpress: () {
                Navigator.pushNamed(context, 'login_screen');
              },
            ),

            SizedBox(
              height: sizeBoxHeight1,
            ),

            Roundbutton(
                title: 'Register',
                onpress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                  // Navigator.pushNamed(context, 'registration_screen');
                },
                primary: Colors.blue.shade600,
                onPrimary: Colors.black)
          ],
        ),
      ),
    );
  }
}
