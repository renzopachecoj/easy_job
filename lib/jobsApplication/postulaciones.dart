import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strings/strings.dart';
import '../utils/constants.dart';

class PostulacionListing extends StatefulWidget {
  final anuncio;
  PostulacionListing({Key key, @required this.anuncio}) : super(key: key);

  @override
  _PostulacionListingState createState() => _PostulacionListingState();
}

class _PostulacionListingState extends State<PostulacionListing> {
  var _postulaciones = [];

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final titleController = TextEditingController();
  final pathController = TextEditingController();

  final databaseReference = Firestore.instance;

  @override
  void initState() {
    super.initState();
    getPostulacion();
  }

  void getPostulacion() async {
    List<dynamic> listaAnuncios = [];
    await this
        .databaseReference
        .collection("postulaciones")
        .where("anuncioId", isEqualTo: widget.anuncio["id"])
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        listaAnuncios.add(result.data);
      });
    });
    setState(() {
      this._postulaciones = listaAnuncios;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("EasyJob"),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff40B491), Color(0xff246752)])),
            )),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Center(
                  child: Text(
                'Postulación: ' + widget.anuncio["cargo"],
                style: PAGE_TITLE_ANUNCIO,
              )),
              SizedBox(
                height: 10,
              ),
              _postulaciones.isEmpty
                  ? Column(children: <Widget>[
                      Text("No hay postulaciones para mostrar",
                          style: RESULT_TEXT_STYLE),
                      Icon(Icons.mood_bad, size: 100, color: MAIN_THEME_COLOR)
                    ])
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(PADDING),
                        child: Scrollbar(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _postulaciones.length,
                              itemBuilder: (context, i) {
                                final postulacion = _postulaciones[i];
                                return PostulacionCard(postulante: postulacion);
                              }),
                        ),
                      ),
                    )
            ],
          ),
        ));
  }
}

class PostulacionCard extends StatelessWidget {
  final postulante;

  PostulacionCard({this.postulante});
  @override
  Widget build(BuildContext context) {
    print(postulante);
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BORDER_RADIUS),
        ),
        color: Colors.white,
        shadowColor: Colors.white,
        elevation: CARD_ELEVATION,
        child: Padding(
            padding: EdgeInsets.all(PADDING),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  camelize(postulante["nombre"]),
                  textAlign: TextAlign.left,
                  style: CARD_TITLE_STYLE,
                ),
              ),
              Divider(
                color: Colors.transparent,
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.bookmark, color: CARD_ICON_COLOR),
                  SizedBox(width: CARD_ICON_TEXT_SPACE),
                  Text(postulante["titulo"],
                      style: CARD_TEXT_STYLE,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.call, color: CARD_ICON_COLOR),
                  SizedBox(width: CARD_ICON_TEXT_SPACE),
                  Text(postulante["telefono"],
                      style: CARD_TEXT_STYLE,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.description, color: CARD_ICON_COLOR),
                  SizedBox(width: CARD_ICON_TEXT_SPACE),
                  Flexible(
                    child: new Container(
                      child: Text(postulante["curriculum"],
                          style: CARD_TEXT_STYLE,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              ),
            ])));
  }
}
