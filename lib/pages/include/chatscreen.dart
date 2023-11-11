// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:chat_church/pages/include/discussion.dart';

class ChatScreen extends StatelessWidget {
  final User user;

  ChatScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView( // Zone d'affichage des messages
              padding: EdgeInsets.all(16.0), // Ajoutez un espacement
              children: [
                // Liste des messages à afficher ici (boucles sur les messages)
                // MessageBubble(text: 'Bonjour'),
                // MessageBubble(text: 'Comment ça va?'),
                // ... Ajoutez plus de messages ici
              ],
            ),
          ),
          // Zone de saisie de texte et bouton d'envoi
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'Saisissez votre message...'),
              // Gérez le texte du message ici
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Envoyez le message ici
            },
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;

  MessageBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Alignement à gauche pour les messages de l'utilisateur actuel
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
