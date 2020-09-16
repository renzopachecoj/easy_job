import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup.dart';
import '../components/bezierContainer.dart';
import '../jobsListing/jobsListing.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userMailController = TextEditingController();
  final userPasswordController = TextEditingController();
  final firestoreInstance = Firestore.instance;
  bool validUser = false;

  @override
  void dispose() {
    userMailController.dispose();
    userPasswordController.dispose();
    super.dispose();
  }

  _validateAccount(String mail, String password) async {
    var snapshots = await this
        .firestoreInstance
        .collection("usuarios")
        .where("correo", isEqualTo: mail)
        .where("clave", isEqualTo: password)
        .getDocuments();
    if (snapshots.documents.isNotEmpty) {
      setState(() {
        validUser = true;
      });
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Regresar',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController userController,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              controller: userController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        String mail = userMailController.text;
        String password = userPasswordController.text;
        _validateAccount(mail, password);
        if (validUser) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => JobsListing(mail, true)));
        } else {
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Error de inicio de sesión"),
                    content: Text("Usuario o clave incorrectos"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('CERRAR'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ]);
              });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff40B491), Color(0xff246752)])),
        child: Text(
          'Iniciar sesión',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.only(top: 3, bottom: 12),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¿No tienes una cuenta?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Regístrate',
              style: TextStyle(
                  color: Color(0xff39A282),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff339175),
          ),
          children: [
            TextSpan(
              text: 'easy',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Job',
              style: TextStyle(color: Color(0xff2A876C), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Correo electrónico", userMailController),
        _entryField("Contraseña", userPasswordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
