import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Commandes"),
      ),
      body: Center(
        child: Text(
          "Interface pour gérer les commandes",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
