import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Dummy imports for other pages
import 'package:admin_dashbord/screens/orders_page.dart';
import 'package:admin_dashbord/screens/categories_page.dart';
import 'package:admin_dashbord/screens/users_page.dart';
import 'package:admin_dashbord/screens/dashboard_screen.dart'; // Import de DashboardScreen

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();
  final _quantiteController = TextEditingController();
  final _ipController = TextEditingController();
  String? _selectedCategory;
  File? _image;

  List<String> _categories = [];
  int? _categoryId;

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8090/produits/categories'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.map((category) => category['name'] as String).toList();
        });
      } else {
        throw Exception('Erreur lors du chargement des catégories');
      }
    } catch (e) {
      print('Erreur : $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible de charger les catégories')));
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez sélectionner une image')));
        return;
      }

      try {
        String nom = _nomController.text;
        String description = _descriptionController.text;
        double prix = double.parse(_prixController.text);
        int quantite = int.parse(_quantiteController.text);
        String ip = _ipController.text;

        Uint8List imageBytes = await _image!.readAsBytes();

        var request = http.MultipartRequest('POST', Uri.parse('http://localhost:8090/produits/ajouter'));
        request.fields['nom'] = nom;
        request.fields['description'] = description;
        request.fields['prix'] = prix.toString();
        request.fields['quantite'] = quantite.toString();
        request.fields['adresse_ip'] = ip;
        request.fields['categorie_id'] = _categoryId.toString();
        request.files.add(await http.MultipartFile.fromBytes('image_File', imageBytes, filename: _image!.path.split('/').last));

        final response = await request.send();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produit ajouté avec succès')));
          _formKey.currentState?.reset();
          setState(() {
            _image = null;
            _selectedCategory = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout du produit')));
        }
      } catch (e) {
        print('Erreur : $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Une erreur est survenue')));
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildSidebarItem(context, Icons.shopping_cart_outlined, "Produits", true, ProductsPage()),
                  _buildSidebarItem(context, Icons.people_outline, "Utilisateurs", false, UsersPage()),
                  _buildSidebarItem(context, Icons.category_outlined, "Catégories", false, AddCategoryPage()),
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
                      // En-tête "Produits" avec design attrayant
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFF2b307c), // Fond coloré
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
                              'Produits',
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
                      _buildForm(),
                      SizedBox(height: 20),
                      Center(
                        child: _buildSubmitButton(), // Centrer le bouton
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

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(_nomController, 'Nom du produit', Icons.production_quantity_limits),
          SizedBox(height: 16),
          _buildTextField(_descriptionController, 'Description', Icons.description),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField(_prixController, 'Prix', Icons.monetization_on, TextInputType.number)),
              SizedBox(width: 8),
              Expanded(child: _buildTextField(_quantiteController, 'Quantité', Icons.add_box, TextInputType.number)),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField(_ipController, 'Adresse IP', Icons.language),
          SizedBox(height: 16),
          _buildDropdown(),
          SizedBox(height: 16),
          _buildImagePicker(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, [TextInputType inputType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF2b307c)),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Supprimer la bordure 3D
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null || value.isEmpty ? 'Entrez $label' : null,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (newValue) {
        setState(() {
          _selectedCategory = newValue;
          _categoryId = _categories.indexOf(newValue!) + 1;
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.category, color: Color(0xFF2b307c)),
        labelText: 'Catégorie',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Supprimer la bordure 3D
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _categories.map((category) => DropdownMenuItem<String>(value: category, child: Text(category))).toList(),
      validator: (value) => value == null ? 'Sélectionnez une catégorie' : null,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image, color: Colors.white),
          label: Text("Sélectionner une image"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2b307c),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_image != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                _image!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: _submitForm,
      icon: Icon(Icons.add, color: Colors.white),
      label: Text("Ajouter Produit"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2b307c),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
