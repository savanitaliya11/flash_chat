// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_app/components/messagebubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageStream extends StatefulWidget {
  @override
  State<MessageStream> createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  bool spinner = false;

  @override
  void initState() {
    getCurruntUser();
    super.initState();
  }

  void getCurruntUser() async {
    setState(() {
      spinner = true;
    });

    try {
      final regUser = _auth.currentUser;

      if (regUser != null) {
        loggedInUser = regUser;
        setState(() {
          spinner = false;
        });
        print(loggedInUser);
      } else if (regUser == null) {
        setState(() {
          spinner = false;
        });
        print('reguser not found');
      }
    } catch (e) {
      setState(() {
        spinner = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return spinner == true
        ? CircularProgressIndicator()
        : StreamBuilder<QuerySnapshot>(
            stream:
                _fireStore.collection('messages').orderBy('time').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                );
              }

              if (snapshot.hasData) {
                final messages = snapshot.data!.docs.reversed;
                List<Widget>? widgetData = [];
                for (var message in messages) {
                  final messageText = message.get('text');
                  final messageSender = message.get('sender');
                  final currentUser = loggedInUser!.email;
                  final widgetText = MessageBubble(
                    text: messageText,
                    sender: messageSender,
                    isMe: currentUser == messageSender,
                  );

                  widgetData.add(widgetText);
                }
                return ListView(
                  reverse: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  children: widgetData,
                );
              } else {
                return Text('Error====================>>>>>>>>>>');
              }
            },
          );
  }
}
