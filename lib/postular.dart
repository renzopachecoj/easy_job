import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils/constants.dart';

class Postular  extends StatelessWidget {

  final anuncio;
  Postular({Key key, @required this.anuncio}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final titleController = TextEditingController();
  final pathController = TextEditingController();

  final databaseReference = Firestore.instance;

  void createPostulacion() async {
    DocumentReference ref = await databaseReference.collection("postulaciones").add({
      'anuncioId': anuncio["id"],
      'curriculum': pathController.text,
      'nombre': nameController.text,
      'telefono': phoneController.text,
      'titulo': titleController.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("EasyJob"),
            flexibleSpace: Container(
              decoration: BoxDecoration(color: Color(0xff40B491)),
            )),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Postular: ' + anuncio["cargo"],
                  style: PAGE_TITLE,
                ),
              ),
              Form(
                  key: _formKey,
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Nombre Completo",
                          textAlign: TextAlign.left,
                          style: CARD_BUTTON_TEXT_STYLE,
                        ), // Nombre Completo
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor, ingrese su nombre completo.';
                            }
                            return null;
                          },
                          controller: nameController,
                          style: RESULT_TEXT_STYLE,
                          decoration: InputDecoration(
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff40B491)),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        Text(
                          "Teléfono",
                          style: CARD_BUTTON_TEXT_STYLE,
                        ), // Teléfono
                        TextFormField(
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          validator: (value) {
                            if (value.isEmpty || value.length != 10) {
                              return 'Por favor, ingrese un teléfono válido (11 dígitos).';
                            }

                            return null;
                          },
                          controller: phoneController,
                          style: RESULT_TEXT_STYLE,
                          decoration: InputDecoration(
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff40B491)),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        Text(
                          "Título/Nivel de Educación",
                          style: CARD_BUTTON_TEXT_STYLE,
                        ),
                        TextFormField(
                          controller: titleController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor, ingrese su Tílulo o nivel de educación.';
                            }
                            return null;
                          },
                          style: RESULT_TEXT_STYLE,
                          decoration: InputDecoration(
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff40B491)),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        Text(
                          "Adjuntar Link a Linkedin",
                          style: CARD_BUTTON_TEXT_STYLE,
                        ),
                        TextFormField(
                          controller: pathController,
                          validator: (value) {
                            if (value.isEmpty || !value.contains("linkedin")) {
                              return 'Por favor, ingrese un link.';
                            }
                            return null;
                          },
                          style: RESULT_TEXT_STYLE,
                          decoration: InputDecoration(
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff40B491)),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff40B491)),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text("Postulación Exitosa"),
                                        content: Text("Ha postulado correctamente."),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('ACEPTAR'),
                                            onPressed: () {
                                              createPostulacion();
                                              Navigator.pop(context);
                                            },
                                          )
                                        ]);
                                  });
                              Navigator.pop(context);
                            }
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
                              'Postular',
                              style: TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
