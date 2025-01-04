import 'package:fetprojet/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    
    if (user != null) {
      // Save user information to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', user.email!);
      await prefs.setString('userId', user.uid);
      await prefs.setString('name', user.displayName ?? ''); // Store name if available
    }
    
    return user;
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // User cancelled the sign-in

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      // Save user information to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', user.email!);
      await prefs.setString('userId', user.uid);
      await prefs.setString('name', user.displayName ?? ''); // Store name if available
    }

    return user;
  }

  // Handle logout
  Future<void> logout(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      
      // Clear user data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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

  // Retrieve user information from SharedPreferences
  Future<User?> getUserFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Check if user data exists in SharedPreferences
    String? email = prefs.getString('email');
    String? name = prefs.getString('name');
    String? userId = prefs.getString('userId');

    if (email != null && userId != null) {
      // Create and return a User object with the user's information
      User user = Usershard(name: name ?? 'Unknown', email: email, id: userId) as User;
      return user;
    }
    
    // Return null if data does not exist
    return null;
  }
}
class Usershard {
  String name;
  String email;
  String id;

  // Constructor
  Usershard({required this.name, required this.email, required this.id});

  // Getters and Setters (optional, Dart allows direct property access)
  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }

  String getEmail() {
    return email;
  }

  void setEmail(String email) {
    this.email = email;
  }

  String getId() {
    return id;
  }

  void setId(String id) {
    this.id = id;
  }
}

