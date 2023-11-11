// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, prefer_const_declarations, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:chat_church/champs/champ_utilisateur.dart';
import 'package:chat_church/champs/champ_mdp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './config.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Connexion(),
    );
  }
}

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  String _username = '';
  String _password = '';
  bool isButtonEnabled = false;
  bool isLoading = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    maFonctionauto();
  }

  Future<void> maFonctionauto() async {
    final String apiPath = 'compteadmin';
    final Uri apiUrl = Uri.parse('$baseUrl$apiPath');

    final response = await http.post(apiUrl);
    if (response.statusCode == 200) {
      // Traitez la réponse JSON ici
      final data = json.decode(response.body);

      debugPrint(data['message']);
    } else {
      // La requête a échoué ou a renvoyé un statut d'erreur

      // Affichez l'erreur dans la console
      debugPrint('Erreur de requête. Statut : ${response.statusCode}');

      // Vous pouvez également afficher des messages d'erreur spécifiques en fonction du code de statut
      if (response.statusCode == 404) {
        debugPrint('La ressource demandée n\'a pas été trouvée.');
      } else if (response.statusCode == 500) {
        debugPrint('Erreur interne du serveur.');
      } else {
        debugPrint('Erreur inconnue.');
      }
    }
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/image/chat3893.logowik.com.webp'),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 30.0),
                      child: const Text(
                        'Fiadanana Chat',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ChampUtilisateur(
                    controller: _usernameController,
                    onSaved: (value) {
                      _username = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom d\'utilisateur';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20), // Espace de 10 pixels
                  ChampMotDePasse(
                    controller: _passwordController,
                    onSaved: (value) {
                      _password = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20), // Espace de 10 pixels
                  ElevatedButton(
                    onPressed: isButtonEnabled
                    ? () {
                        setState(() {
                          isLoading = true; // Activez le chargement avant l'envoi de la requête
                        });
                        _submitForm();
                        Future.delayed(Duration(seconds: 10), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }
                    : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(450, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: isLoading
                    ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ) // Indicateur de chargement
                    : Text(
                        'SE CONNECTER',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ),
                  const SizedBox(height: 10),

                  if (errorMessage.isNotEmpty)
                    Card(
                      elevation: 4.0,
                      margin: EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red), // Couleur du texte en rouge par exemple
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Vous pouvez utiliser les valeurs _username et _password comme vous le souhaitez.
      setState(() {
        isLoading = true; // Activez le chargement
      });
      final String apiPath = 'seconnecter';
      final Uri apiUrl = Uri.parse('$baseUrl$apiPath');

      final response = await http.post(apiUrl, body: {'email': _username,'password': _password});

      // final response = await http.post(Uri.parse('http://192.168.0.219:8000/api/seconnecter'), body: {'email': _username,'password': _password});


      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final data = json.decode(response.body);

        final token = data['token'];
        final donnee = data['user'];

        await prefs.setString('token', token);
        await prefs.setString('utilisateur', json.encode(donnee));

        debugPrint(token);
        debugPrint(donnee.toString());
        
        Navigator.pushNamed(context, '/accueil');

      } else {
        debugPrint('Erreur de requête. Statut : ${response.statusCode}');

        
        if (response.statusCode == 404) {
          debugPrint('La ressource demandée n\'a pas été trouvée.');
        } else if (response.statusCode == 500) {
          debugPrint('Erreur interne du serveur.');
        } else {
          setState(() {
            errorMessage = 'Vérifier votre nom utilisateur ou mot de passe.';
          });
          isLoading = false;
        }
      }
    }
  }
}