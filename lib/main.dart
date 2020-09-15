import 'package:flutter/material.dart';
import './loginAndSignup/welcomePage.dart';

void main() => runApp(EasyJobApp());

class EasyJobApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyJob',
      theme: ThemeData(
        fontFamily: 'Rubik',
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
