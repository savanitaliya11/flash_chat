// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_app/components/constant.dart';
import 'package:flash_chat_app/components/reusabletextfield_screen.dart';
import 'package:flash_chat_app/components/rounded_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController? email = TextEditingController();
  TextEditingController? password = TextEditingController();
  bool spinner = false;

  dynamic validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);

    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }

  // dynamic validatePassword(String value) {
  //   RegExp regex =
  //       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  //   if (value.isEmpty) {
  //     return 'Please enter password';
  //   } else {
  //     if (!regex.hasMatch(value)) {
  //       return 'Enter valid password';
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'Log In',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25.0,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(
          reverse: true,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Hero(
                      tag: 'Hero',
                      child: Image.asset(
                        'images/logo.png',
                        height: 160.0,
                        // width: 80.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizeBoxHeight,
                  ),
                  ReusableTextField(
                    //validator: (value) => validateEmail(value),
                    controller: email!,
                    hintText: 'xyz@gmail.com',
                    label: 'Username',
                  ),
                  SizedBox(
                    height: sizeBoxHeight1,
                  ),
                  ReusableTextField(
                    //validator: (value) => validatePassword(value),
                    controller: password!,
                    label: 'Password',
                    hintText: 'Xyz2021',
                  ),
                  Roundbutton(
                    title: 'LogIn',
                    onPrimary: Colors.black,
                    primary: Colors.blue.shade300,
                    onpress: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          spinner = true;
                        });
                        try {
                          _auth
                              .signInWithEmailAndPassword(
                                  email: email!.text, password: password!.text)
                              .then(
                                (value) =>
                                    Navigator.pushNamed(context, 'Chat_screen'),
                              );

                          email!.clear();
                          password!.clear();

                          setState(() {
                            spinner = false;
                          });
                        } catch (e) {
                          print('Error is ================>>>>>>>>>>>>>$e');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            backgroundColor: Colors.blue[100],
                            duration: Duration(seconds: 4),
                            elevation: 15.0,
                            content: Text(
                              'Enter the correct data',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
