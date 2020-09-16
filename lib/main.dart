import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import './jobsListing/jobsListingWelcome.dart';
import './loginAndSignup/welcomePage.dart';

void main() => runApp(EasyJobApp());

class EasyJobApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List widgets = <Widget>[
      WelcomePage(),
      JobsListing("", false),
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
