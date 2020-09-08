import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import './../utils/constants.dart';

class JobsListingPage extends StatefulWidget {
  JobsListingPage(BuildContext context) : super();

  @override
  _JobsListingState createState() => _JobsListingState();
}

class _JobsListingState extends State<JobsListingPage> {
  var _isLoading = true;
  var _isSearching = false;
  var anuncios = [];
  final firestoreInstance = Firestore.instance;
  final searchFilterController = TextEditingController();

  @override
  void dispose() {
    searchFilterController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAnunciosFeed();
  }

  _loadAnunciosFeed([filtro = ""]) async {
    List<dynamic> listaAnuncios = [];
    if (filtro == "") {
      await this
          .firestoreInstance
          .collection("anuncios")
          .orderBy("fecha", descending: true)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          listaAnuncios.add(result.data);
        });
      });
      setState(() {
        _isLoading = false;
        this.anuncios = listaAnuncios;
      });
    } else {
      await this
          .firestoreInstance
          .collection("anuncios")
          .orderBy("fecha", descending: true)
          .where("cargo", isEqualTo: filtro)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          print(result.data);
          listaAnuncios.add(result.data);
        });
      });
      setState(() {
        _isLoading = false;
        this.anuncios = listaAnuncios;
      });
    }
  }

  Future<String> _getAutorAnuncio(usuarioId) async {
    var autor = await this
        .firestoreInstance
        .collection("usuarios")
        .document(usuarioId)
        .get();
    return autor.data["nombre"];
  }

  _verDetalles(BuildContext context, anuncio) {
    Widget cerrarBtn = FlatButton(
      child: Text(
        "CERRAR",
        style: CARD_BUTTON_TEXT_STYLE,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Detalles"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Cargo: "),
              Text(camelize(anuncio["cargo"]), textAlign: TextAlign.left)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Publicado por: "),
              Text(camelize(anuncio["autor"]), textAlign: TextAlign.left)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Publicado en: "),
              Text(anuncio["fecha"].toDate().toString().split(" ")[0],
                  textAlign: TextAlign.left)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Jornada: "),
              Text(camelize(anuncio["jornada"]), textAlign: TextAlign.left)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Contrato: "),
              Text(camelize(anuncio["contrato"]), textAlign: TextAlign.left)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Detalles: "),
            ],
          ),
          Container(
              child: Text(anuncio["detalles"],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  textAlign: TextAlign.left))
        ],
      ),
      actions: [cerrarBtn],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
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
              actions: <Widget>[
                _isSearching
                    ? SizedBox.shrink()
                    : IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          print("Reloading...");
                          setState(() {
                            _isLoading = true;
                          });
                          _loadAnunciosFeed();
                        },
                      ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Icon(Icons.add, size: 40),
              backgroundColor: Color(0xff40B491),
            ),
            body: Center(
                child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(PADDING),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: _isSearching
                        ? <Widget>[
                            Expanded(
                                child: Text(
                              "Resultados para: \"${searchFilterController.text}\"",
                              style: RESULT_TEXT_STYLE,
                            )),
                            IconButton(
                                icon:
                                    Icon(Icons.close, color: Color(0xff40B491)),
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                    _isSearching = false;
                                  });
                                  searchFilterController.clear();
                                  _loadAnunciosFeed();
                                })
                          ]
                        : <Widget>[
                            Expanded(
                                child: TextField(
                              style: RESULT_TEXT_STYLE,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff40B491)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff40B491)),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff40B491)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  hintText: 'Buscar por cargo o empleo'),
                              controller: searchFilterController,
                            )),
                            IconButton(
                                icon: Icon(Icons.search,
                                    color: Color(0xff40B491)),
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                    _isSearching = true;
                                  });
                                  _loadAnunciosFeed(searchFilterController.text
                                      .toLowerCase());
                                })
                          ]),
              ),
              Divider(
                color: Colors.transparent,
                height: 1.0,
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff40B491)),
                    ))
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(PADDING),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: this.anuncios != null
                                ? this.anuncios.length
                                : 0,
                            itemBuilder: (context, i) {
                              final anuncio = this.anuncios[i];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.white,
                                shadowColor: Colors.white,
                                elevation: CARD_ELEVATION,
                                child: Padding(
                                  padding: EdgeInsets.all(PADDING),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          camelize(anuncio["cargo"]),
                                          textAlign: TextAlign.left,
                                          style: CARD_TITLE_STYLE,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                        height: 5.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Icon(Icons.business,
                                              color: CARD_ICON_COLOR),
                                          SizedBox(width: CARD_ICON_TEXT_SPACE),
                                          FutureBuilder<String>(
                                              future: _getAutorAnuncio(
                                                  anuncio["usuarioId"]),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  anuncio["autor"] =
                                                      snapshot.data;
                                                  return Text(snapshot.data,
                                                      style: CARD_TEXT_STYLE);
                                                } else {
                                                  return Text("");
                                                }
                                              })
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Icon(Icons.calendar_today,
                                              color: CARD_ICON_COLOR),
                                          SizedBox(width: CARD_ICON_TEXT_SPACE),
                                          Text(
                                              anuncio["fecha"]
                                                  .toDate()
                                                  .toString()
                                                  .split(" ")[0],
                                              style: CARD_TEXT_STYLE,
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Icon(Icons.access_time,
                                              color: CARD_ICON_COLOR),
                                          SizedBox(width: CARD_ICON_TEXT_SPACE),
                                          Text(
                                              "Jornada: " +
                                                  camelize(anuncio["jornada"]),
                                              style: CARD_TEXT_STYLE)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Icon(Icons.business_center,
                                              color: CARD_ICON_COLOR),
                                          SizedBox(width: CARD_ICON_TEXT_SPACE),
                                          Text(
                                              "Contrato: " +
                                                  camelize(anuncio["contrato"]),
                                              style: CARD_TEXT_STYLE)
                                        ],
                                      ),
                                      ButtonBar(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              'DETALLES',
                                              style: CARD_BUTTON_TEXT_STYLE,
                                            ),
                                            onPressed: () {
                                              _verDetalles(context, anuncio);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              'POSTULAR',
                                              style: CARD_BUTTON_TEXT_STYLE,
                                            ),
                                            onPressed: () {/* ... */},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
            ]))));
  }
}
