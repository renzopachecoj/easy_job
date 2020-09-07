import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import './../../utils/constants.dart';
import './jobsPosting.dart';

class NewJobPostPage extends StatefulWidget {
  NewJobPostPage(BuildContext context) : super();

  @override
  _NewJobPostState createState() => _NewJobPostState();
}

enum Jornada { Completa, MedioTiempo }
enum Contrato { LargoPlazo, Temporal }

class _NewJobPostState extends State<NewJobPostPage> {
  var anuncios = [];
  final firestoreInstance = Firestore.instance;
  final searchFilterController = TextEditingController();

  @override
  void dispose() {
    searchFilterController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Inicio'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.face),
                  title: Text('Perfil'),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xff40B491),
              onTap: _onItemTapped,
            ),
            body: Center(
                child: Column(children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                'Crear Anuncio',
                style: PAGE_TITLE,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(PADDING),
                child: Column(
                  children: <Widget>[
                    TextField(
                      style: RESULT_TEXT_STYLE,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40B491)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40B491)),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Cargo'),
                      controller: searchFilterController,
                      maxLines: 1,
                    ),
                    Text('Jornada', style: CARD_TITLE_STYLE),
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
                    Text('Contrato', style: CARD_TITLE_STYLE),
                    ListTile(
                      title: const Text('Lafayette'),
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
                      title: const Text('Thomas Jefferson'),
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
                    Text('Detalles', style: CARD_TITLE_STYLE),
                    TextField(
                      style: RESULT_TEXT_STYLE,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40B491)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40B491)),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Escribe aquí los detalles del cargo'),
                      controller: searchFilterController,
                      maxLines: 6,
                    ),
                  ],
                ),
              ),
            ]))));
  }
}
