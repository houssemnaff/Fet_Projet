import 'package:fetprojet/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  final User user;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

   HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(user.photoURL ?? 'https://via.placeholder.com/150'),
      ),
      const SizedBox(height: 20),
      Text(
        'Welcome, ${user.displayName ?? 'User'}!',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Text(
        'Email: ${user.email ?? 'Not provided'}',
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 10),
      Text(
        'Phone: ${user.phoneNumber ?? 'Not provided'}',
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 10),
      Text(
        'Address: ${user.emailVerified }',
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 10),
      Text(
        'meta : ${user.metadata ?? 'Not provided'}',
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 10),
      Text(
        'Occupation: ${user.isAnonymous ?? 'Not provided'}',
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 10),
    
      // Add more fields as necessary
    ],
  ),
)

    );
  }

  // Logout function
  Future<void> _logout(BuildContext context) async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase Auth
Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()), // Ensure HomePage is imported
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
