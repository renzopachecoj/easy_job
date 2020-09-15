import 'package:flutter/material.dart';
import '../components/bezierContainer.dart';
import 'loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../jobsListing.dart';
import '../enterprise/enterprisePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

enum TipoUsuario { Aspirante, Empleador }

class _SignUpPageState extends State<SignUpPage> {
  TipoUsuario _tipoUsuario = TipoUsuario.Aspirante;
  final firestoreInstance = Firestore.instance;
  bool isAspirante = true;

  final userNameController = TextEditingController();
  final userMailController = TextEditingController();
  final userLinkedinController = TextEditingController();
  final userPasswordController = TextEditingController();

  String tipo = "aspirante";

  @override
  void dispose() {
    userNameController.dispose();
    userMailController.dispose();
    userLinkedinController.dispose();
    userPasswordController.dispose();
    super.dispose();
  }

  _sendInfoToDB() async {
    await this.firestoreInstance.collection('usuarios').add({
      'clave': userPasswordController.text,
      'correo': userMailController.text,
      'fotoPerfil': "",
      'nombre': userNameController.text,
      'perfilLinkedIn': userLinkedinController.text,
      'tipo': tipo
    });
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
        if (isAspirante) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => JobsListing(userMailController.text, true, context)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EnterprisePage(userMailController.text, context)));
        }
        _sendInfoToDB();
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
          'Regístrate ahora',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¿Ya tienes una cuenta?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Iniciar sesion',
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
        _entryField("Nombre", userNameController),
        _entryField("Correo electrónico", userMailController),
        _entryField("Perfil de LinkedIn", userLinkedinController),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Tipo de usuario",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Row(
              children: <Widget>[
                Radio(
                    value: TipoUsuario.Aspirante,
                    groupValue: _tipoUsuario,
                    onChanged: (TipoUsuario value) {
                      setState(() {
                        _tipoUsuario = value;
                      });
                    }),
                Text('Postulante'),
                SizedBox(width: 50),
                Radio(
                    value: TipoUsuario.Empleador,
                    groupValue: _tipoUsuario,
                    onChanged: (TipoUsuario value) {
                      setState(() {
                        _tipoUsuario = value;
                        isAspirante = false;
                      });
                      tipo = "empleador";
                    }),
                Text('Empleador'),
              ],
            ),
          ],
        ),
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
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .04),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
