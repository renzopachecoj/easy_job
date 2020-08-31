import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(new EasyJobApp());

class EasyJobApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new EasyJobState();
  }
}

class EasyJobState extends State<EasyJobApp> {
  var _isLoading = true;
  var anuncios;
  final firestoreInstance = Firestore.instance;
  _loadAnunciosFeed() async {
    List<dynamic> listaAnuncios = [];
    await this
        .firestoreInstance
        .collection("anuncios")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        listaAnuncios.add(result.data);
      });
      setState(() {
        _isLoading = false;
        this.anuncios = listaAnuncios;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadAnunciosFeed();
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
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
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
          body: Center(
            child: Column(
              children: <Widget>[
                Center(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          itemCount:
                              this.anuncios != null ? this.anuncios.length : 0,
                          itemBuilder: (context, i) {
                            final anuncio = this.anuncios[i];
                            return Column(
                              children: <Widget>[
                                Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          anuncio["cargo"],
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Icon(Icons.calendar_today),
                                          SizedBox(width: 20),
                                          Text(
                                              anuncio["fecha"]
                                                  .toDate()
                                                  .toString()
                                                  .split(" ")[0],
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Icon(Icons.access_time),
                                          SizedBox(width: 20),
                                          Text("Jornada: " + anuncio["jornada"])
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Icon(Icons.business_center),
                                          SizedBox(width: 20),
                                          Text("Contrato: " +
                                              anuncio["contrato"])
                                        ],
                                      ),
                                      ButtonBar(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('POSTULAR'),
                                            onPressed: () {/* ... */},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider()
                              ],
                            );
                          }),
                ),
              ],
            ),
          ),
        ));
  }
}
