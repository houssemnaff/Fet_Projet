import 'package:fetprojet/api/sessionapi.dart';
import 'package:fetprojet/authservice.dart';
import 'package:fetprojet/pages/admin/session/sessionform.dart';
import 'package:fetprojet/pages/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class Session extends StatefulWidget {
  final User user; // Utilisation du paramètre "user" non statique

  const Session({super.key, required this.user});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  final List<Map<String, dynamic>> sessions = [];
  final AuthService _authService = AuthService();
  final ApiService apiService = ApiService(); // Création d'une instance d'ApiService

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  /// Charger les sessions depuis l'API
  void _loadSessions() async {
    try {
      final sessionList = await apiService.fetchSessions();
      setState(() {
        sessions.addAll(sessionList);
      });
    } catch (e) {
      print('Failed to load sessions: $e');
    }
  }

  /// Supprimer une session de la liste
  void _deleteSession(int index) {
    setState(() {
      sessions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.logout(context),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage()),
              );
            },
            child: CircleAvatar(
              radius: 15,
              backgroundImage: widget.user.photoURL != null
                  ? NetworkImage(widget.user.photoURL!)
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
            ),
          ),
          const SizedBox(width: 10),
        ],
        title: const Text("Session"),
      ),
      body: Column(
        children: [
          // Bouton Ajouter une Session
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionForm(user: widget.user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
              ),
              child: const Text(
                "Add Session",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Liste des Sessions Disponibles
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Available sessions:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return ListTile(
                  title: Text(session["name"]),
                  subtitle: Text("Time: ${session["time"]}"),
                  leading: const Icon(Icons.event),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () => _deleteSession(index),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
