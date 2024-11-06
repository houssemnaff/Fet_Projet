import 'package:fetprojet/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class home extends StatelessWidget {
  final User user;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  home({super.key, required this.user});

  // Données de démonstration pour chaque carte
  final List<Map<String, dynamic>> dashboardItems = [
    {"title": "Etudiants", "value": "12", "icon": Icons.group},
    {"title": " prof", "value": "00-17-4D-00-00", "icon": Icons.group},
    {
      "title": "Timestamp",
      "value": "Aug 26, 2021\n11:15:54",
      "icon": Icons.access_time
    },
    /*{"title": "Temperature", "value": "23.5 °C", "icon": Icons.thermostat},
    {"title": "Humidity", "value": "95.80%", "icon": Icons.water_drop},
    {"title": "room", "value": "1011.40 Pa", "icon": Icons.cabin},
    {"title": "", "value": "0.00 m/s", "icon": Icons.air},
    {"title": "", "value": "0.00°", "icon": Icons.navigation},
    {"title": "", "value": "0.00", "icon": Icons.water},
    {"title": "", "value": "2.20", "icon": Icons.shower},
    {"title": "", "value": "13.05 m", "icon": Icons.waves},
    {"title": "", "value": "40.90%", "icon": Icons.grass},*/
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Dashboard"),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
          CircleAvatar(
            radius: 15, // Taille de l'avatar
            backgroundImage: user.photoURL != null
                ? NetworkImage(
                    user.photoURL!) // Si l'URL de l'image existe, on l'utilise
                : const AssetImage(
                    'assets/default_avatar.png'), // Sinon, on affiche une image par défaut
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildDashboardGrid(
                context), // Affiche les cartes du tableau de bord
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap:
          true, // Important pour permettre le défilement dans une `Column`
      physics:
          const NeverScrollableScrollPhysics(), // Empêcher le scroll dans la grille
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Nombre de colonnes dans la grille
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: 1, // Ajuster le ratio largeur/hauteur des tuiles
      ),
      itemCount: dashboardItems.length,
      itemBuilder: (context, index) {
        final item = dashboardItems[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item["icon"] as IconData,
                    size: 30, color: Colors.blue), // Adjusted size
                //const SizedBox(height: 10),
                Text(
                  item["title"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //const SizedBox(height: 5),
                Text(
                  item["value"]!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase Auth
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginPage()), // Retourner à la page de connexion
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully logged out')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $error')),
      );
    }
  }
}
