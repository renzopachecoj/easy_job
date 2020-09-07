// import 'package:flutter/material.dart';

// class BottomNavigationBar extends StatefulWidget {
//   BottomNavigationBar({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _BottomNavigationBarState createState() => _BottomNavigationBarState();
// }

// class _BottomNavigationBarState extends State<BottomNavigationBar> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const BottomNavigationBar({Key key}) : super(key: key);

//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//               items: const <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home),
//                   title: Text('Inicio'),
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.face),
//                   title: Text('Perfil'),
//                 ),
//               ],
//               currentIndex: _selectedIndex,
//               selectedItemColor: Color(0xff40B491),
//               onTap: _onItemTapped,
//             );
//   }
//   }
// }
