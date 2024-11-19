import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Utilisateurs"),
      ),
      body: Center(
        child: Text(
          "Interface pour gérer les utilisateurs",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
