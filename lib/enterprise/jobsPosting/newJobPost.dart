import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import './../../utils/constants.dart';
import './jobsPosting.dart';
import '../../components/textFieldCustomized.dart';

class NewJobPostPage extends StatefulWidget {
  NewJobPostPage(BuildContext context) : super();

  @override
  _NewJobPostState createState() => _NewJobPostState();
}

enum Jornada { Completa, MedioTiempo }
enum Contrato { LargoPlazo, Temporal }

class _NewJobPostState extends State<NewJobPostPage> {
  final firestoreInstance = Firestore.instance;
  final searchFilterControllerCargo = TextEditingController();
  final searchFilterControllerDetalles = TextEditingController();
  String cargo;
  String contrato = 'largo plazo';
  String detalles;
  String jornada = 'completa';

  @override
  void dispose() {
    searchFilterControllerCargo.dispose();
    searchFilterControllerDetalles.dispose();
    super.dispose();
  }

  _sendInfoToDB([filtro = ""]) async {
    await this.firestoreInstance.collection('anuncios').add({
      'cargo': cargo,
      'contrato': contrato,
      'detalles': detalles,
      'fecha': DateTime.now(),
      'jornada': jornada,
      'usuarioId': 'u7ChfWo3QykdKxGExzS7'
    });
  }

  @override
  Widget build(BuildContext context) {
    Jornada _jornada = Jornada.Completa;
    Contrato _contrato = Contrato.LargoPlazo;

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("EasyJob"),
              flexibleSpace: Container(
                decoration: BoxDecoration(color: Color(0xff40B491)),
              ),
            ),
            body: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                children: <Widget>[
                  Center(
                    child: Text(
                      'Crear Anuncio',
                      style: PAGE_TITLE,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cargo', style: CARD_TITLE_STYLE),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldCustomized(
                    text: 'Cargo',
                    style: RESULT_TEXT_STYLE,
                    maxLines: 1,
                    controller: searchFilterControllerCargo,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Jornada', style: CARD_TITLE_STYLE),
                  ),
                  Column(children: <Widget>[
                    ListTile(
                      title: const Text('Completa'),
                      leading: Radio(
                        value: Jornada.Completa,
                        groupValue: _jornada,
                        onChanged: (Jornada value) {
                          setState(() {
                            _jornada = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Medio Tiempo'),
                      leading: Radio(
                        value: Jornada.MedioTiempo,
                        groupValue: _jornada,
                        onChanged: (Jornada value) {
                          setState(() {
                            _jornada = value;
                          });
                        },
                      ),
                    ),
                  ]),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Contrato', style: CARD_TITLE_STYLE),
                  ),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Largo Plazo'),
                        leading: Radio(
                          value: Contrato.LargoPlazo,
                          groupValue: _contrato,
                          onChanged: (Contrato value) {
                            setState(() {
                              _contrato = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Temporal'),
                        leading: Radio(
                          value: Contrato.Temporal,
                          groupValue: _contrato,
                          onChanged: (Contrato value) {
                            setState(() {
                              _contrato = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Detalles', style: CARD_TITLE_STYLE),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldCustomized(
                    text: 'Escribe aquí los detalles del cargo',
                    style: RESULT_TEXT_STYLE,
                    maxLines: 6,
                    controller: searchFilterControllerDetalles,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      cargo = searchFilterControllerCargo.text;
                      detalles = searchFilterControllerDetalles.text;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobsPostingPage(context)));
                      _sendInfoToDB();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 10),
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
                        'Publicar',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ])));
  }
}
