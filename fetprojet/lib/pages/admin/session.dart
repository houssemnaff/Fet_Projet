import 'package:fetprojet/components/drawer.dart';
import 'package:fetprojet/login.dart';
import 'package:fetprojet/pages/admin/sessionform.dart';
import 'package:fetprojet/pages/home.dart';
import 'package:fetprojet/pages/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Session extends StatefulWidget {
  final User user;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Session({super.key, required this.user});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  final List<Map<String, dynamic>> sessions = [
    {"name": "Session 1", "time": DateTime.now()},
    {"name": "Session 2", "time": DateTime.now().add(Duration(days: 1))},
    {"name": "Session 3", "time": DateTime.now().add(Duration(days: 2))},
  ];

  void _deleteSession(int index) {
    setState(() {
      sessions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // drawer: DrawerPage(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            child: CircleAvatar(
              radius: 15,
              backgroundImage: widget.user.photoURL != null
                  ? NetworkImage(widget.user.photoURL!)
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
            ),
          )
        ],
        title: const Text("Session"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SessionForm()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
          const Row(
            children: [
              Text("Available sessions:"),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return listSession(
                  session["name"],
                  session["time"],
                  () => _deleteSession(index),
                  () {
                    // Navigate to Dashboard and pass session details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(
                         // sessionName: session["name"],
                          //sessionTime: session["time"],
                        ),
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

  Future<void> _logout(BuildContext context) async {
    try {
      await widget._googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
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
}

// Widget to display individual session details
Widget listSession(String name, DateTime time, VoidCallback onDelete, VoidCallback onTap) {
  return ListTile(
    title: Text(name),
    subtitle: Text("Time: ${time.toLocal()}"),
    leading: const Icon(Icons.event),
    trailing: IconButton(
      icon: const Icon(Icons.delete),
      color: Colors.red,
      onPressed: onDelete,
    ),
    onTap: onTap, // Redirect to the dashboard page when tapped
  );
}

// Example Dashboard Page
class DashboardPage extends StatelessWidget {
  final String sessionName;
  final DateTime sessionTime;

  const DashboardPage({
    super.key,
    required this.sessionName,
    required this.sessionTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Session Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Name: $sessionName"),
            Text("Time: ${sessionTime.toLocal()}"),
          ],
        ),
      ),
    );
  }
}
