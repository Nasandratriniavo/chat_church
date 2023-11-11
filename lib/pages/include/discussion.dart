// ignore_for_file: must_be_immutable, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:chat_church/pages/config.dart';
import 'package:chat_church/pages/include/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String respIlite;
  final String type;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.respIlite,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      respIlite: json['resp_ilite'],
      type: json['type'],
    );
  }
}


class Discussion extends StatefulWidget {
  Discussion({super.key});

  @override
  _DiscussionState createState() => _DiscussionState();
  int identite = 0;

}

class _DiscussionState extends State<Discussion> {
  final List<User> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Appeler la récupération des utilisateurs au démarrage
  }

  Future<void> sharedrefutil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? utilisateur = prefs.getString('utilisateur');
    String utilstring = utilisateur.toString();

    Map<String, dynamic> data = jsonDecode(utilstring);

    setState(() {
      widget.identite = (data['id']);
    });

  }

  Future<void> _fetchUsers() async {
    const String apiPath = 'all_disc';
    final Uri apiUrl = Uri.parse('$baseUrl$apiPath');
    final _identite = widget.identite.toString();


    final response = await http.post(apiUrl, body: {'id': _identite});

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<User> userList = jsonData.map((json) => User.fromJson(json)).toList();

      setState(() {
        users.addAll(userList); // Ajouter les utilisateurs à la liste
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.respIlite), // Affiche la responsabilité en tant que sous-titre
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}