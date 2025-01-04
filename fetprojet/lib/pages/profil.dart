import 'package:fetprojet/authservice.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String userName = "Houssem Naffouti";
  final String email = "houssem.naffouti@example.com";
  final String phoneNumber = "+216 123 456 789";
  final String role = "Admin";
  final String bio = "Développeur passionné avec une expertise en Flutter et Spring Boot.";
AuthService authservice = AuthService();

  UserProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
       
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
                  // Profile Picture
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile.jpg'), // Replace with your image asset
                  ),
                  const SizedBox(height: 10),
                  // User Name
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Role
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // User Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ProfileDetailTile(
                    icon: Icons.email,
                    title: "Email",
                    value: email,
                  ),
                  ProfileDetailTile(
                    icon: Icons.phone,
                    title: "Téléphone",
                    value: phoneNumber,
                  ),
                  ProfileDetailTile(
                    icon: Icons.info,
                    title: "Bio",
                    value: bio,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Action for editing profile
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Modifier le profil"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      
              authservice.logout(context);


                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Se déconnecter"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileDetailTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
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
        subtitle: Text(value),
      ),
    );
  }
}
