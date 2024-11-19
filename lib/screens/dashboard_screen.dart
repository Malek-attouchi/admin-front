import 'package:flutter/material.dart';
import 'package:admin_dashbord/screens/categories_page.dart';
import 'package:admin_dashbord/screens/orders_page.dart';
import 'package:admin_dashbord/screens/products_page.dart';
import 'package:admin_dashbord/screens/users_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade100,
        fontFamily: 'Roboto',
      ),
      home: DashboardScreen(), // DashboardScreen est la page d'accueil
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar améliorée
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo.shade800,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Logo et nom de l'app
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
                  // Navigation Menu avec effet de survol
                  SidebarItem(
                    icon: Icons.home_outlined,  // Ajout de l'icône Accueil
                    label: "Accueil",  // Label pour Accueil
                    isSelected: true, // C'est la page par défaut, donc sélectionnée
                    onTap: () {
                      // Navigation vers la page d'accueil (DashboardScreen)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardScreen()),
                      );
                    },
                  ),
                  SidebarItem(
                    icon: Icons.shopping_cart_outlined,
                    label: "Produits",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductsPage()),
                      );
                    },
                  ),
                  SidebarItem(
                    icon: Icons.people_outline,
                    label: "Utilisateurs",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UsersPage()),
                      );
                    },
                  ),
                  SidebarItem(
                    icon: Icons.category_outlined,
                    label: "Catégories",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCategoryPage()),
                      );
                    },
                  ),
                  SidebarItem(
                    icon: Icons.list_alt_outlined,
                    label: "Commandes",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrdersPage()),
                      );
                    },
                  ),
                  Spacer(),
                  Divider(color: Colors.white30, indent: 16, endIndent: 16),
                  SidebarItem(
                    icon: Icons.settings_outlined,
                    label: "Paramètres",
                    onTap: () {},
                  ),
                  SidebarItem(
                    icon: Icons.logout_outlined,
                    label: "Déconnexion",
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Contenu principal
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barre supérieure avec champ de recherche stylisé
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.indigo),
                            hintText: "Rechercher...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('images/user_avatar.png'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Cartes statistiques avec ombre plus douce et espacement amélioré
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatCard(
                        title: "Produits",
                        count: 720,
                        icon: Icons.shopping_bag_outlined,
                        color: Colors.orangeAccent,
                      ),
                      StatCard(
                        title: "Utilisateurs",
                        count: 820,
                        icon: Icons.person_outline,
                        color: Colors.purpleAccent,
                      ),
                      StatCard(
                        title: "Commandes",
                        count: 920,
                        icon: Icons.shopping_cart_outlined,
                        color: Colors.greenAccent,
                      ),
                      StatCard(
                        title: "Catégories",
                        count: 120,
                        icon: Icons.category_outlined,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Graphiques améliorés
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rapport des utilisateurs",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Graphique en cours...",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Discussions récentes",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage('images/user_avatar.png'),
                                          ),
                                          title: Text("Utilisateur ${index + 1}"),
                                          subtitle: Text("Dernier message..."),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }
}

// SidebarItem avec effet de survol et animation de sélection
class SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  SidebarItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  _SidebarItemState createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: _isHovered || widget.isSelected ? Colors.indigo.shade700 : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: _isHovered || widget.isSelected ? Colors.white : Colors.white70,
            size: 24,
          ),
          title: Text(
            widget.label,
            style: TextStyle(
              color: _isHovered || widget.isSelected ? Colors.white : Colors.white60,
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: widget.isSelected,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

// Carte statistique avec ombre et couleur douce
class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16.0), // Réduction du padding pour plus de flexibilité
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8), // Réduction de l'espace entre l'icône et le texte
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), // Taille de police réduite
              textAlign: TextAlign.center, // Centrer le texte pour une meilleure lisibilité
            ),
            const SizedBox(height: 4), // Espace réduit entre le titre et le nombre
            Text(
              "$count",
              style: TextStyle(
                fontSize: 20, // Taille de police plus petite pour éviter le débordement
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
