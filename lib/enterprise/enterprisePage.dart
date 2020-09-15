import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './../jobsListing/jobsListing.dart';
import './jobsPosting/jobsPosting.dart';

class EnterprisePage extends StatefulWidget {
  final String mail;

  EnterprisePage(String mail, BuildContext context)
      : this.mail = mail,
        super();

  @override
  _EnterpriseState createState() => _EnterpriseState(mail);
}

class _EnterpriseState extends State<EnterprisePage> {
  final String mail;
  _EnterpriseState(this.mail);

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
    JobsListingPage(context);
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      JobsListingPage(context),
      JobsPostingPage(mail, context),
    ];
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
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ));
  }
}
