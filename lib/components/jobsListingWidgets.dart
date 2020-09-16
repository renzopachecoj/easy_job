import 'package:easy_job/main.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import '../jobsApplication/postulaciones.dart';
import '../jobsApplication/postular.dart';
import '../utils/constants.dart';

class SearchBarWidget extends StatelessWidget {
  final isSearching;
  final searchFilterController;
  final isLoading;
  final loadAnunciosFeed;
  final searchCargo;
  final setIsSearching;
  final setIsLoading;

  SearchBarWidget(
      {this.isSearching,
      this.isLoading,
      this.loadAnunciosFeed,
      this.searchCargo,
      this.setIsLoading,
      this.setIsSearching,
      this.searchFilterController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PADDING_WIDGETS,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          children: isSearching
              ? <Widget>[
                  Expanded(
                      child: Text(
                    "Resultados para: \"${searchFilterController.text}\"",
                    style: RESULT_TEXT_STYLE,
                  )),
                  IconButton(
                      icon: Icon(Icons.close, color: MAIN_THEME_COLOR),
                      onPressed: () {
                        setIsLoading(true);
                        setIsSearching(false);
                        searchFilterController.clear();
                        loadAnunciosFeed();
                      })
                ]
              : <Widget>[
                  Expanded(
                      child: TextField(
                    style: RESULT_TEXT_STYLE,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(PADDING),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: MAIN_THEME_COLOR),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: MAIN_THEME_COLOR),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: MAIN_THEME_COLOR),
                            borderRadius: BorderRadius.all(
                                Radius.circular(BORDER_RADIUS))),
                        hintText: 'Buscar por cargo o empleo'),
                    controller: searchFilterController,
                  )),
                  IconButton(
                      icon: Icon(Icons.search, color: MAIN_THEME_COLOR),
                      onPressed: () {
                        if (searchFilterController.text != "") {
                          setIsLoading(true);
                          setIsSearching(true);
                          searchCargo(searchFilterController.text);
                        }
                      })
                ]),
    );
  }
}

class FilterBarWidget extends StatelessWidget {
  final isLoading;
  final isFiltering;
  final loadAnunciosFeed;
  final setIsLoading;
  final setIsFiltering;
  final filterJornada;
  final dropDownValue;
  final setDropDownValue;

  FilterBarWidget(
      {this.isLoading,
      this.loadAnunciosFeed,
      this.setIsLoading,
      this.filterJornada,
      this.isFiltering,
      this.setIsFiltering,
      this.dropDownValue,
      this.setDropDownValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PADDING_WIDGETS,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: isFiltering
              ? <Widget>[
                  Expanded(
                      child: Text(
                    "Filtrando para: \"$dropDownValue\"",
                    style: RESULT_TEXT_STYLE,
                  )),
                  FlatButton(
                    child: Text(
                      'QUITAR FILTRO',
                      style: CARD_BUTTON_TEXT_STYLE,
                    ),
                    onPressed: () {
                      setIsLoading(true);
                      setIsFiltering(false);
                      setDropDownValue("Elegir Jornada");
                      loadAnunciosFeed();
                    },
                  )
                ]
              : <Widget>[
                  DropdownButton<String>(
                    value: dropDownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: RESULT_TEXT_STYLE,
                    underline: Container(
                      height: 2,
                      color: MAIN_THEME_COLOR,
                    ),
                    onChanged: (String newValue) {
                      setDropDownValue(newValue);
                    },
                    items: <String>[
                      'Elegir Jornada',
                      'Tiempo Completo',
                      'Medio Tiempo'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: RESULT_TEXT_STYLE,
                        ),
                      );
                    }).toList(),
                  ),
                  FlatButton(
                      child: Text(
                        'FILTRAR',
                        style: CARD_BUTTON_TEXT_STYLE,
                      ),
                      onPressed: () {
                        if (dropDownValue != 'Elegir Jornada') {
                          setIsLoading(true);
                          setIsFiltering(true);
                          filterJornada(dropDownValue);
                        }
                      })
                ]),
    );
  }
}

class DetailsPopUp extends StatelessWidget {
  final anuncioDetails;

  DetailsPopUp({this.anuncioDetails});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Detalles"),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              _getOrderedDetails(anuncioDetails).entries.map<Widget>((entry) {
            return Column(children: <Widget>[
              Row(children: <Widget>[
                Text(camelize(entry.key),
                    style: ALERT_BOLD_TEXT_STYLE, textAlign: TextAlign.left)
              ]),
              Container(
                  child: Text(entry.value,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                      textAlign: TextAlign.left))
            ]);
          }).toList()),
      actions: <Widget>[
        FlatButton(
          child: Text('CERRAR'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

class AnuncioCard extends StatelessWidget {
  final anuncio;
  final getAutorAnuncio;
  final isAspirante;
  final verDetalles;
  final loadAnunciosFeed;
  final isLoggedIn;

  AnuncioCard(
      {this.anuncio,
      this.getAutorAnuncio,
      this.isAspirante,
      this.loadAnunciosFeed,
      this.verDetalles,
      this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.business, color: CARD_ICON_COLOR),
                  SizedBox(width: CARD_ICON_TEXT_SPACE),
                  FutureBuilder<String>(
                      future: getAutorAnuncio(anuncio["usuarioId"]),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          anuncio["autor"] = snapshot.data;
                          return Text(camelize(snapshot.data),
                              style: CARD_TEXT_STYLE);
                        } else {
                          return Text("");
                        }
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.calendar_today, color: CARD_ICON_COLOR),
                  SizedBox(width: CARD_ICON_TEXT_SPACE),
                  Text(anuncio["fecha"].toDate().toString().split(" ")[0],
                      style: CARD_TEXT_STYLE, textAlign: TextAlign.left)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.access_time, color: CARD_ICON_COLOR),
                  SizedBox(width: CARD_ICON_TEXT_SPACE),
                  Text("Jornada: " + camelize(anuncio["jornada"]),
                      style: CARD_TEXT_STYLE)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.business_center, color: CARD_ICON_COLOR),
                  SizedBox(width: CARD_ICON_TEXT_SPACE),
                  Text("Contrato: " + camelize(anuncio["contrato"]),
                      style: CARD_TEXT_STYLE)
                ],
              ),
              AnuncioCardActions(
                  isAspirante: isAspirante,
                  anuncio: anuncio,
                  verDetalles: verDetalles,
                  loadAnunciosFeed: loadAnunciosFeed,
                  isLoggedIn: isLoggedIn)
            ])));
  }
}

class AnuncioCardActions extends StatelessWidget {
  final isAspirante;
  final anuncio;
  final verDetalles;
  final loadAnunciosFeed;
  final isLoggedIn;

  AnuncioCardActions(
      {this.isAspirante,
      this.anuncio,
      this.verDetalles,
      this.loadAnunciosFeed,
      this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return ButtonBar(children: <Widget>[
      FlatButton(
        child: Text(
          'DETALLES',
          style: CARD_BUTTON_TEXT_STYLE,
        ),
        onPressed: () {
          verDetalles(anuncio);
        },
      ),
      if (isAspirante && isLoggedIn)
        FlatButton(
            child: Text(
              'POSTULAR',
              style: CARD_BUTTON_TEXT_STYLE,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Postular(anuncio: anuncio),
                ),
              );
            })
      else
        FlatButton(
            child: Text(
              'POSTULANTES',
              style: CARD_BUTTON_TEXT_STYLE,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostulacionListing(anuncio: anuncio),
                ),
              );
            })
    ]);
  }
}

_getOrderedDetails(anuncio) {
  return {
    "cargo": anuncio["cargo"],
    "autor": anuncio["autor"],
    "fecha": anuncio["fecha"].toDate().toString().split(" ")[0],
    "jornada": anuncio["jornada"],
    "contrato": anuncio["contrato"],
    "detalles": anuncio["detalles"],
  };
}

class ProfilePage extends StatelessWidget {
  final userData;
  ProfilePage(this.userData);
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text("Perfil"),
      Text(userData["nombre"]),
      Text("LinkedIn: " + userData["perfilLinkedIn"]),
      RaisedButton(
          child: Text("CERRAR SESION"),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EasyJobApp()));
          })
    ]);
  }
}
