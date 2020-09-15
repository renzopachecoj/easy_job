import 'package:flutter/material.dart';
//import 'package:flutter_login_signup/main.dart';
import 'jobsListingWelcome.dart';
import './loginAndSignup/welcomePage.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

void main() => runApp(EasyJobApp());

class EasyJobApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List widgets = <Widget>[
      WelcomePage(),
      JobsListing(null, true, context),
    ];
    return MaterialApp(
      title: 'EasyJob',
      theme: ThemeData(
        fontFamily: 'Rubik',
      ),
      debugShowCheckedModeBanner: false,
      home: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return widgets[index];
        },
        loop: false,
        itemCount: 2,
        pagination: new SwiperPagination(),
        control: new SwiperControl(iconNext: null, iconPrevious: null),
      ),
    );
  }
}
// JobsListing(null, true, context),
