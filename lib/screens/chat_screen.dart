// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  User? loggedInUser;
  String? messages;

  TextEditingController? controller = TextEditingController();
  bool spinner = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    getCurruntUser();
    super.initState();
  }

  void getCurruntUser() async {
    try {
      final regUser = _auth.currentUser;

      if (regUser != null) {
        loggedInUser = regUser;

        print(loggedInUser);
      } else if (regUser == null) {
        print('reguser not found');
      }
    } catch (e) {
      print(e);
    }
  }

  // var message;
  //
  // void getMessage() async {
  //   await for (var snap in _fireStore.collection('messages').snapshots()) {
  //     for (message in snap.docs) {
  //       print(
  //           'message is ${message['text']} and sender is ${message['sender']}');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                    SnackBar(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: Colors.blue[100],
                        duration: Duration(seconds: 2),
                        elevation: 15.0,
                        content: Text(
                          'Log Out Successful',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                  .closed
                  .then((value) =>
                      Navigator.pushNamed(context, 'welcome_screen'));
              // Navigator.pushNamed(context, 'welcome_screen');
            },
          ),
        ],
        backgroundColor: Colors.blue.shade400,
        title: Text(
          '${loggedInUser!.email}',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: spinner == true
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: MessageStream()),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'You have to type new message';
                                } else {
                                  return null;
                                }
                              },
                              controller: controller,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 25.0),
                                hintText: 'type message here',
                              ),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _fireStore.collection('messages').add({
                                    'text': controller!.text,
                                    'sender': loggedInUser?.email,
                                    'time': DateTime.now()
                                  });
                                  controller!.clear();
                                }

                                setState(() {
                                  spinner = false;
                                });
                              },
                              child: Text(
                                'Send',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 20.0),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

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

class MessageBubble extends StatelessWidget {
  String text;
  String sender;
  bool isMe;

  MessageBubble({
    required this.text,
    required this.sender,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          sender,
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            elevation: 10.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            color: isMe ? Colors.blueAccent : Colors.redAccent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                '$text',
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.blueAccent,
                    fontSize: 15.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
