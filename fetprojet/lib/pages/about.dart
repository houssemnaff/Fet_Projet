import 'package:fetprojet/authservice.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("À Propos"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // App Logo or Image
                  Image.asset(
                    'assets/logo.png', // Replace with your logo or relevant image
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 10),
                  // App Name
                  const Text(
                    'Gestion des Écoles',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Description
                  const Text(
                    'Une application de gestion des écoles, permettant de gérer les emplois du temps, les étudiants, les départements et les professeurs.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                     
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Features Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(title: 'Fonctionnalités'),
                  FeatureTile(
                    icon: Icons.access_time,
                    title: 'Gestion des Emplois du Temps',
                    description: 'Permet aux administrateurs de gérer les emplois du temps des étudiants et des professeurs.',
                  ),
                  FeatureTile(
                    icon: Icons.school,
                    title: 'Gestion des Étudiants',
                    description: 'Ajout, modification et suivi des étudiants dans différentes classes et départements.',
                  ),
                  FeatureTile(
                    icon: Icons.business,
                    title: 'Gestion des Départements',
                    description: 'Organisez et gérez les différents départements de l\'école.',
                  ),
                  FeatureTile(
                    icon: Icons.person,
                    title: 'Gestion des Professeurs',
                    description: 'Ajoutez et gérez les informations des professeurs et attribuez des cours.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }
}
