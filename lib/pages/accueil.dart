// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors, unused_element, unused_import, unused_local_variable

import 'dart:convert';

import 'package:chat_church/pages/include/discussion.dart';
import 'package:flutter/material.dart';
import './include/profil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Accueil(),
    );
  }
}

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    sharedrefutil();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      if (index == 1) {
        // Naviguez vers l'écran de profil lorsque l'onglet "Profil" est sélectionné
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Screen2(),
        ));
      } else {
        // Utilisez l'index pour déterminer l'action pour les autres onglets
        _currentIndex = index;
        _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
      }

      sharedrefutil();
    });
  }

  Future<void> sharedrefutil()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? utilisateur = prefs.getString('utilisateur');
    String utilstring = utilisateur.toString();

    Map<String, dynamic> data = jsonDecode(utilstring);

    String resp = data['resp_ilite'];
    String nomutil = data['email'];
    String nom = data['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          Screen1(),
          Screen2(),
        ],
      ),
      bottomNavigationBar: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w200,
          fontSize: 15,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedFontSize: 15,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.normal,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              label: 'Message',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profil',
              backgroundColor: Colors.blue,
            ),
          ],
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        title: Text(
          'Discussions',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: Discussion()),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true, // Affiche le bouton de retour
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Naviguez vers l'écran de discussions lorsqu'on appuie sur le bouton de retour
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Profil(),
      ),
    );
  }
}

