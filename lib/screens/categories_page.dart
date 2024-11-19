import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Dummy imports for other pages
import 'package:admin_dashbord/screens/dashboard_screen.dart'; // Import de DashboardScreen
import 'package:admin_dashbord/screens/products_page.dart'; // Import de ProductsPage
import 'package:admin_dashbord/screens/users_page.dart'; // Import de UsersPage
import 'package:admin_dashbord/screens/orders_page.dart'; // Import de OrdersPage
import 'package:admin_dashbord/screens/categories_page.dart'; // Import de AddCategoryPage

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final String apiUrl = "http://localhost:8090/produits/categorie/ajouter";
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> addCategory(String categoryName) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nom": categoryName}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Catégorie ajoutée avec succès !")),
        );
        _controller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'ajout de la catégorie.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur réseau : $error")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color customColor = Color(0xFF0056A0); // Bleu France (#0056A0)

    return Scaffold(
      body: Stack(
        children: [
          // Sidebar (fixée lors du défilement)
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              color: Colors.indigo.shade800,
              width: 250,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.dashboard, color: Colors.white, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          "Admin Panel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSidebarItem(context, Icons.home_outlined, "Accueil", false, DashboardScreen()),
                  _buildSidebarItem(context, Icons.shopping_cart_outlined, "Produits", false, ProductsPage()),
                  _buildSidebarItem(context, Icons.people_outline, "Utilisateurs", false, UsersPage()),
                  _buildSidebarItem(context, Icons.category_outlined, "Catégories", true, AddCategoryPage()),
                  _buildSidebarItem(context, Icons.list_alt_outlined, "Commandes", false, OrdersPage()),
                  Spacer(),
                  Divider(color: Colors.white30, indent: 16, endIndent: 16),
                  _buildSidebarItem(context, Icons.settings_outlined, "Paramètres", false, null),
                  _buildSidebarItem(context, Icons.logout_outlined, "Déconnexion", false, null),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Main Content
          Positioned(
            top: 0,
            left: 250,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête "Ajouter une catégorie" avec design attrayant
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: customColor, // Fond coloré
                            borderRadius: BorderRadius.circular(12), // Bords arrondis
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 4), // Position de l'ombre
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Ajouter une Catégorie',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Formulaire avec espacement entre les champs
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: _controller,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Nom de la catégorie',
                                labelStyle: TextStyle(
                                  color: customColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                prefixIcon: Icon(Icons.category_outlined, color: customColor),
                              ),
                            ),
                            SizedBox(height: 24),
                            isLoading
                                ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(customColor),
                              ),
                            )
                                : ElevatedButton(
                              onPressed: () {
                                final categoryName = _controller.text.trim();
                                if (categoryName.isNotEmpty) {
                                  addCategory(categoryName);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Le nom ne peut pas être vide."),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: customColor,
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                              ),
                              child: Text(
                                "Ajouter",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Texte en blanc
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar item builder
  Widget _buildSidebarItem(BuildContext context, IconData icon, String label, bool isSelected, Widget? targetPage) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white60),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white60,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        if (targetPage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
        }
      },
    );
  }
}
