// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:chat_church/pages/include/modifnomutil.dart';
import 'package:flutter/material.dart';
import 'package:chat_church/pages/accueil.dart';
import 'package:chat_church/pages/loading.dart';
import 'package:chat_church/pages/connexion.dart';
import 'package:chat_church/pages/include/modifnomid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/': (context) => Loading(),
        '/login': (context) => Connexion(),
        '/accueil': (context) => AccueilWidget(),
        '/modifiernomid': (context) => ModifierNomIdWidget(),
        '/modifiernomutil': (context) => ModifierNomUtilWidget(),
      },
    );
  }
}

class AccueilWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getAuthToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (isTokenValid(snapshot.data)) {
            return Accueil();
          } else {
            // Redirigez l'utilisateur vers la page de connexion
            return Connexion();
          }
        } else {
          // Pendant le chargement, vous pouvez afficher un indicateur de chargement
          return CircularProgressIndicator();
        }
      },
    );
  }
}


class ModifierNomIdWidget extends StatelessWidget {
  const ModifierNomIdWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getAuthToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (isTokenValid(snapshot.data)) {
            return ModifierNomId(utilisateur: '', identite: 0,);
          } else {
            // Redirigez l'utilisateur vers la page de connexion
            return Connexion();
          }
        } else {
          // Pendant le chargement, vous pouvez afficher un indicateur de chargement
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class ModifierNomUtilWidget extends StatelessWidget {
  const ModifierNomUtilWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getAuthToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (isTokenValid(snapshot.data)) {
            return ModifierNomUtil(utilisateur: '', identite: 0,);
          } else {
            // Redirigez l'utilisateur vers la page de connexion
            return Connexion();
          }
        } else {
          // Pendant le chargement, vous pouvez afficher un indicateur de chargement
          return CircularProgressIndicator();
        }
      },
    );
  }
}

bool isTokenValid(String? token) {
  if (token != null) {
    return true;
  }

  try {
    bool isTokenExpired = JwtDecoder.isExpired(token!);

    if (!isTokenExpired) {
      return true; // Le token est valide
    }
  } catch (e) {
    debugPrint('Erreur lors de la vérification du token : $e');
  }

  return false; // Le token est invalide
}

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  return token;
}
