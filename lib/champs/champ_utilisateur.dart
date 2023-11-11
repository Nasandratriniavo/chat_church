// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

class ChampUtilisateur extends StatelessWidget {
  void Function(String?) onSaved;
  String? Function(String?)? validator;
  TextEditingController controller;

  ChampUtilisateur({
    required this.controller,
    required this.onSaved,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
        onSaved: onSaved,
        validator: validator,
        style: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.normal,
        ),
      )
    );
  }
}
