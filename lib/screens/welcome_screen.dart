import 'package:fire_chat/screens/login_screen.dart';
import 'package:fire_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import'package:fire_chat/rounded_button.dart';
class WelcomeScreen extends StatefulWidget {
  static const String id= 'Welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;
  @override
  void initState(){
    super.initState();
    controller=AnimationController(
      duration:Duration(seconds:1),
      vsync: this,
     );
     animation=ColorTween(begin:Colors.red,end:Colors.blue).animate(controller);
    
        controller.forward();
    
    controller.addListener((){
      setState(() {});
      print(animation.value);
    });
@override
void dispose(){
  controller.dispose();
  super.dispose();
}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag:'logo',
                   child: Container(
                    child: Image.asset('images/logo.png'),
                    height:60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                 text:['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log In',color: Colors.blueAccent,onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton(
              title: 'Register',
              color:Colors.blueAccent,
              onPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}

