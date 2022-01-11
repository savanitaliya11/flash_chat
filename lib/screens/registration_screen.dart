// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_null_comparison, curly_braces_in_flow_control_structures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_app/components/constant.dart';
import 'package:flash_chat_app/components/reusabletextfield_screen.dart';
import 'package:flash_chat_app/components/rounded_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController? email = TextEditingController();
  TextEditingController? password = TextEditingController();
  TextEditingController? controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool spinner = false;

  RegExp regexemail =
      RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$");

  RegExp regexpwd =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  dynamic validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);

    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return 'Enter a valid email address=======================';
    else
      return null;
  }

  dynamic validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'Register',
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
                      ),
                    ),
                  ),

                  SizedBox(
                    height: sizeBoxHeight,
                  ),

                  //Registration
                  ReusableTextField(
                    controller: email!,
                    hintText: 'xyz@gmail.com',
                    label: 'Username',
                  ),

                  SizedBox(
                    height: sizeBoxHeight1,
                  ),

                  //pwd
                  ReusableTextField(
                    controller: password!,
                    hintText: 'Password',
                    label: 'Xyz2021@',
                  ),

                  //Register
                  Roundbutton(
                    title: 'Register',
                    onPrimary: Colors.black,
                    primary: Colors.blue.shade300,
                    onpress: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          spinner = true;
                        });

                        try {
                          _auth
                              .createUserWithEmailAndPassword(
                                  email: email!.text, password: password!.text)
                              .then((value) =>
                                  Navigator.pushNamed(context, 'login_screen'));

                          email!.clear();
                          password!.clear();

                          setState(() {
                            spinner = false;
                          });
                        } catch (e) {
                          print('register error =======>>>>>>>>>$e');
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
                              'Enter the data',
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
