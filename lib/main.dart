import 'package:flutter/material.dart';
//import 'package:flutter_login_signup/main.dart';
import 'jobsListing.dart';
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
      home: JobsListing("",false),
    );
  }
}
