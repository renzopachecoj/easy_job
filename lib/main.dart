import 'package:flutter/material.dart';

void main() => runApp(new EasyJobApp());

class EasyJobApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new EasyJobState();
  }
}

class EasyJobState extends State<EasyJobApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyJob',
      theme: ThemeData(
        fontFamily: 'Rubik',
        primaryColor: Colors.black,
        accentColor: Colors.blueAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("EasyJob"),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
              },
            ),
            // action button
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: Center(
          child: Text("Jobs Here"),
        ),
      ),
    );
  }
}

