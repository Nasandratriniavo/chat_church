// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, avoid_unnecessary_containers, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'package:chat_church/pages/accueil.dart';
import 'package:chat_church/pages/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ModifierNomId extends StatefulWidget {
  final String utilisateur;
  final int identite;

  const ModifierNomId({super.key, required this.utilisateur, required this.identite});

  @override
  State<ModifierNomId> createState() => _ModifierNomIdState();
}

class _ModifierNomIdState extends State<ModifierNomId> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nomidController;
  bool isButtonEnabled = false;
  String errorMessage = '';

  @override

void initState(){
  super.initState();
  _nomidController = TextEditingController(text: widget.utilisateur);

  _nomidController.addListener(() {
    final text = _nomidController.text;
    // Vérifiez si la valeur de l'input est différente de la valeur par défaut
    setState(() {
      isButtonEnabled = text != widget.utilisateur;
    });
  });
}


Future<void> _enregistrernomid() async {
  if (_formKey.currentState!.validate()) {
    // Le formulaire est valide, traitez les données ici
    final _nomident = _nomidController.text;
    final _identite = widget.identite.toString();
    
    // Effectuez des opérations pour enregistrer la nouvelle valeur
    const String apiPath = 'savenomid';

    final Uri apiUrl = Uri.parse('$baseUrl$apiPath');

    final response = await http.post(apiUrl, body: {'id': _identite,'nomid': _nomident});

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final data = json.decode(response.body);


      final donnee = data['user'];
      prefs.remove("utilisateur");

      debugPrint(prefs.getString('utilisateur').toString());
      await prefs.setString('utilisateur', json.encode(donnee).toString());

      
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Screen2(),
      ));

    } else {
      debugPrint('Erreur de requête. Statut : ${response.statusCode}');

      
      if (response.statusCode == 404) {
        debugPrint('La ressource demandée n\'a pas été trouvée.');
      } else if (response.statusCode == 500) {
        debugPrint('Erreur interne du serveur.');
      } else if(response.statusCode == 422){
        errorMessage = 'Champ trop long';
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier nom d\'identifiant',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: isButtonEnabled ? () {
              // Action à effectuer lorsque le bouton est cliqué
              _enregistrernomid();
            } : null,
            // Le bouton est désactivé si isButtonEnabled est false
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                isButtonEnabled ? Colors.blue : Colors.blue, // Personnalisez la couleur ici
              ),
              shape: isButtonEnabled ? MaterialStateProperty.all<OutlinedBorder?>(null) : null,
            ),
            child: Text(
              'ENREGISTRER',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: TextField(
                        controller: _nomidController,
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                ],
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
          
        ),
      ),
    );
  }
}

