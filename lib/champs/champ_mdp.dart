// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';

class ChampMotDePasse extends StatelessWidget {
  void Function(String?) onSaved;
  String? Function(String?)? validator;
  TextEditingController controller;

  ChampMotDePasse({
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
        obscureText: true,
        decoration: const InputDecoration(labelText: 'Mot de passe'),
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
