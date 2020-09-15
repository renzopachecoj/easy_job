import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'jobsListingWidgets.dart';

class JobsListing extends StatefulWidget {
  final usuario;
  final _isLoggedIn;
  const JobsListing(this.usuario, this._isLoggedIn);
  @override
  _JobsListingState createState() => _JobsListingState();
}

class _JobsListingState extends State<JobsListing> {
  var userData = {};
  var _isLoading = true;
  var _isSearching = false;
  var _isFiltering = false;
  var _inProfile = false;
  var _searchFilterController = TextEditingController();
  var _anuncios = [];

  String _dropDownValue = "Elegir Jornada";
  final _firestoreInstance = Firestore.instance;

  _switchIsLoading(newState) {
    setState(() {
      _isLoading = newState;
    });
  }

  _switchIsSearching(newState) {
    setState(() {
      _isSearching = newState;
    });
  }

  _switchIsFiltering(newState) {
    setState(() {
      _isFiltering = newState;
    });
  }

  _setDropDownValue(newValue) {
    setState(() {
      _dropDownValue = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData(widget.usuario);
    _loadAnunciosFeed();
  }

  _loadAnunciosFeed() async {
    List<dynamic> listaAnuncios = [];
    if (widget.usuario == "" || userData["tipo"] == "aspirante") {
      await this
          ._firestoreInstance
          .collection("anuncios")
          .orderBy("fecha", descending: true)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          result.data["id"] = result.documentID;
          listaAnuncios.add(result.data);
        });
      });
    } else {
      await this
          ._firestoreInstance
          .collection("anuncios")
          .orderBy("fecha", descending: true)
          .where("usuarioId", isEqualTo: widget.usuario)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          result.data["id"] = result.documentID;
          listaAnuncios.add(result.data);
        });
      });
    }
    setState(() {
      _isLoading = false;
      this._anuncios = listaAnuncios;
    });
  }

  _getUserData(usuario) async {
    if (widget.usuario == "") {
      setState(() {
        userData = {"tipo": "aspirante"};
      });
    } else {
      await this
          ._firestoreInstance
          .collection("usuarios")
          .where("correo", isEqualTo: usuario)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          setState(() {
            userData = result.data;
          });
        });
      });
    }
  }

  _searchCargo(String filtro) {
    List<dynamic> listaAnuncios = [];
    this._anuncios.forEach((anuncio) {
      if (anuncio["cargo"].toString().contains(filtro.toLowerCase())) {
        listaAnuncios.add(anuncio);
      }
    });
    setState(() {
      _isLoading = false;
      this._anuncios = listaAnuncios;
    });
  }

  _filterJornada(String jornada) {
    List<dynamic> listaAnuncios = [];
    this._anuncios.forEach((anuncio) {
      if (anuncio["jornada"] == jornada.toLowerCase()) {
        listaAnuncios.add(anuncio);
      }
    });
    setState(() {
      _isLoading = false;
      this._anuncios = listaAnuncios;
    });
  }

  Future<String> _getAutorAnuncio(usuarioId) async {
    var autor = await this
        ._firestoreInstance
        .collection("usuarios")
        .where("correo", isEqualTo: usuarioId)
        .getDocuments();
    return autor.documents[0]["nombre"];
  }

  Future<void> _verDetalles(anuncio) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DetailsPopUp(anuncioDetails: anuncio);
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
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'easyJob',
            theme: ThemeData(
              fontFamily: 'Rubik',
            ),
            home: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(
                    "easyJob",
                    style: APPBAR_TITLE_STYLE,
                  ),
                  centerTitle: false,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xff40B491), Color(0xff246752)])),
                  ),
                ),
                floatingActionButton: !(userData["tipo"] == "aspirante")
                    ? FloatingActionButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        child: Icon(Icons.add, size: 40),
                        backgroundColor: MAIN_THEME_COLOR,
                      )
                    : Container(),
                body: Center(
                    child: !_inProfile
                        ? Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(PADDING),
                              child: Text(
                                !(userData["tipo"] == "aspirante")
                                    ? "Mis Anuncios"
                                    : "Empleos para ti",
                                style: BODY_TITLE_STYLE,
                              ),
                            ),
                            if (!_isFiltering)
                              SearchBarWidget(
                                isSearching: _isSearching,
                                isLoading: _isLoading,
                                searchCargo: _searchCargo,
                                loadAnunciosFeed: _loadAnunciosFeed,
                                setIsLoading: _switchIsLoading,
                                setIsSearching: _switchIsSearching,
                                searchFilterController: _searchFilterController,
                              ),
                            if (!_isSearching)
                              FilterBarWidget(
                                dropDownValue: _dropDownValue,
                                isFiltering: _isFiltering,
                                isLoading: _isLoading,
                                setDropDownValue: _setDropDownValue,
                                setIsFiltering: _switchIsFiltering,
                                setIsLoading: _switchIsLoading,
                                loadAnunciosFeed: _loadAnunciosFeed,
                                filterJornada: _filterJornada,
                              ),
                            _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        MAIN_THEME_COLOR),
                                  ))
                                : _anuncios.isEmpty
                                    ? Column(children: <Widget>[
                                        Text("No hay resultados para mostrar",
                                            style: RESULT_TEXT_STYLE),
                                        Icon(Icons.mood_bad,
                                            size: 100, color: MAIN_THEME_COLOR)
                                      ])
                                    : Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(PADDING),
                                          child: Scrollbar(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: _anuncios != null
                                                    ? _anuncios.length
                                                    : 0,
                                                itemBuilder: (context, i) {
                                                  final anuncio = _anuncios[i];
                                                  return AnuncioCard(
                                                      anuncio: anuncio,
                                                      getAutorAnuncio:
                                                          _getAutorAnuncio,
                                                      isAspirante:
                                                          (userData["tipo"] ==
                                                              "aspirante"),
                                                      verDetalles: _verDetalles,
                                                      loadAnunciosFeed:
                                                          _loadAnunciosFeed);
                                                }),
                                          ),
                                        ),
                                      )
                          ])
                        : ProfilePage(userData)))));
  }
}
