// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, avoid_unnecessary_containers, non_constant_identifier_names, avoid_init_to_null, unnecessary_string_interpolations, prefer_void_to_null, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';
import 'package:chat_church/pages/accueil.dart';
import 'package:chat_church/pages/config.dart';
import 'package:chat_church/pages/include/modifnomid.dart';
import 'package:chat_church/pages/include/modifnomutil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class Profil extends StatefulWidget {
  Profil({Key? key});

  String resp = "";
  String nomutil = "";
  String nom = "";
  int id = 0;

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  final mdpController = TextEditingController();
  final nouveauMdpController = TextEditingController();
  final confirmationMdpController = TextEditingController();
  String errorMessage = '';
  bool afficherNouveauxChamps = false;


  @override
  void initState() {
    super.initState();
    sharedrefutil();
  }


  Future<void> sharedrefutil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? utilisateur = prefs.getString('utilisateur');
    String utilstring = utilisateur.toString();

    Map<String, dynamic> data = jsonDecode(utilstring);

    setState(() {
      widget.id = (data['id']);
      widget.resp = data['resp_ilite'];
      widget.nomutil = data['email'];
      widget.nom = data['name'];
    });

  }



  // NOM IDENTIFIANT


  void affichernom_id(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Le contenu de votre carte ou bottom sheet
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Cher ${widget.resp}'),
              ),
              ListTile(
                leading: Icon(Icons.account_box),
                title: Text('Modifier le nom d\'identifiant'),
                onTap: () {
                  // Action à effectuer lorsque l'utilisateur clique sur Option 1
                  // Par exemple, fermer la bottom sheet
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifierNomId(
                        utilisateur: widget.nom, 
                        identite: widget.id),
                    ),
                  );
                },
              ),
              // ... Ajoutez d'autres éléments au besoin
            ],
          ),
        );
      },
    );
  }


  // NOM UTILISATEUR


  void affichernom_util(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Le contenu de votre carte ou bottom sheet
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Cher ${widget.resp}'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.at),
                title: Text('Modifier le nom d\'utilisateur'),
                onTap: () {
                  // Action à effectuer lorsque l'utilisateur clique sur Option 1
                  // Par exemple, fermer la bottom sheet
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifierNomUtil(
                        utilisateur: widget.nomutil, 
                        identite: widget.id),
                    ),
                  );
                },
              ),
              // ... Ajoutez d'autres éléments au besoin
            ],
          ),
        );
      },
    );
  }

void changemdp(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Changer votre mot de passe"),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      obscureText: true,
                      controller: mdpController,
                      decoration: InputDecoration(
                        labelText: 'Ancien mot de passe',
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  TextFormField(
                    obscureText: true,
                    controller: nouveauMdpController,
                    decoration: InputDecoration(
                      labelText: 'Nouveau mot de passe',
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    obscureText: true,
                    controller: confirmationMdpController,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le nouveau mot de passe',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Container()), // Espace vide à gauche du bouton
                  ElevatedButton(
                    onPressed: () {
                      _verifiermdp();
                    },
                    child: Text("Modifier"),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Fermer",
              style: TextStyle(
                color: Colors.red[700],
              ),
            ),
          ),
          if (errorMessage.isNotEmpty)
            Center(
              child: Card(
                elevation: 4.0,
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            )
        ],
      );
      
    },
  );
}



  Future<void> _verifiermdp()
  async {
    String _email = widget.nomutil;
    String _password = mdpController.text;
    String _nvmdpcntlr = nouveauMdpController.text;
    String _confmdpcntlr = confirmationMdpController.text;

    const String apiPath = 'checkpass';

    final Uri apiUrl = Uri.parse('$baseUrl$apiPath');

    final response = await http.post(apiUrl, body: {'email': _email, 'password': _password, 'newpassword': _nvmdpcntlr, 'confpassword': _confmdpcntlr});

    if (response.statusCode == 200)
    {
      debugPrint('OK');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Screen2(),
      ));
    } else {
      debugPrint('Erreur de requête. Statut : ${response.statusCode}');
      if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Ancien mot de passe incorrect.';
        });
      } else if(response.statusCode == 422){
         setState(() {
          errorMessage = 'Verifier la longueur du champ';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                margin: EdgeInsets.fromLTRB(0, 50, 0, 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: ClipOval(
                  child: Image(image: AssetImage('assets/image/Musicien.jpg')),
                ),
              ),
              Text(
                widget.resp,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),

              // GESTURE NOMIDENTIFIANT

              GestureDetector(
                onTap: () {
                  affichernom_id(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 10), // Marge de 10 pixels en haut
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Alignez les éléments à gauche
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 10), // Marge à droite de l'icône
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent[400], // Couleur de fond de l'icône
                        ),
                        child: Icon(
                          Icons.perm_identity_rounded, // Icône de votre choix
                          color: Colors.white, // Couleur de l'icône
                          size: 20, // Taille de l'icône
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Aligner le texte et le sous-texte à gauche
                        children: [
                          Text(
                            'Nom identifiant',
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            widget.nom,
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // GESTURE NOMUTILISATEUR
              GestureDetector(
                onTap: () {
                  affichernom_util(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 10), // Marge de 10 pixels en haut
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Alignez les éléments à gauche
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 10), // Marge à droite de l'icône
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent[700], // Couleur de fond de l'icône
                        ),
                        child: Icon(
                          FontAwesomeIcons.at, // Icône de votre choix
                          color: Colors.white, // Couleur de l'icône
                          size: 20, // Taille de l'icône
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Aligner le texte et le sous-texte à gauche
                        children: [
                          Text(
                            'Nom d\'utilisateur',
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            widget.nomutil,
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // GESTURE PASSWORD
              GestureDetector(
                onTap: () {
                  changemdp(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 10), // Marge de 10 pixels en haut
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Alignez les éléments à gauche
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 10), // Marge à droite de l'icône
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87, 
                        ),
                        child: Icon(
                          Icons.key, // Icône de votre choix
                          color: Colors.white, // Couleur de l'icône
                          size: 20, // Taille de l'icône
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Aligner le texte et le sous-texte à gauche
                        children: [
                          Text(
                            'Changer mot de passe',
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
