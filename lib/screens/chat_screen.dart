import 'package:flutter/material.dart';
import 'package:fire_chat/constants.dart';
import 'package:fire_chat/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fire_chat/constants.dart';
final _firestore =FirebaseFirestore.instance;
User loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id= 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();

  final _auth=FirebaseAuth.instance;

  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
    try{
      final user=await _auth.currentUser;
      if(user != null){
        loggedInUser=user;
        print(loggedInUser.email);
      }}
      catch(e){
      print(e);
      }
  }
  //void getMessages()async{
   //final messages= await _firestore.collection('messages').get();
   //for (var message in messages.docs){
    // print(message.data);
   //}
  //}

  void messagesStream() async{
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for (var message in snapshot.docs){
        print(message.data());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {

                 _auth.signOut();
                   Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          MessagesStream(),
            Container(
              //decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText=value;
                      },
                    // decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(

                    onPressed: () {
                      messageTextController.clear();
                     _firestore.collection('messages').add({
                        'text':messageText,
                        'sender':loggedInUser.email,
                      });
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),

          );
        }
        final messages=snapshot.data.docs.reversed;
        List<MessageBubble>messageBubbles=[];
        for(var message in messages){
          final messageText = message.data()['text'];
          final messageSender=message.data()['sender'];

           final currentUser=loggedInUser.email;


          final messageBubble = MessageBubble(
              sender:messageSender,
              text: messageText,
          isMe:currentUser == messageSender,
           );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:EdgeInsets.symmetric(horizontal:20.0,vertical:20.0),
            children: messageBubbles,
          ),
        );

      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender,this.text,this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,style:TextStyle(
            fontSize: 12.0,
            color:Colors.black54,
          )),
        Material(

          borderRadius: isMe ? BorderRadius.only(
            topLeft: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0))
              :BorderRadius.only(bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
          topRight: Radius.circular(30.0)),

          elevation: 5.0,
          color:isMe ? Colors.white :Colors.lightBlueAccent,
          child: Padding(
            padding:EdgeInsets.symmetric(horizontal: 20.0,vertical:10.0),
            child: Text(
              text,
              style:TextStyle(
                  color:isMe ?Colors.black54:Colors.white,
                  fontSize: 15.0),
            ),
          ),
        ),
      ],
      ),

    );
  }
}


