import 'package:flutter/material.dart';
import 'package:fetprojet/api/sessionapi.dart';
import 'package:fetprojet/authservice.dart';
import 'package:fetprojet/pages/admin/session/sessionform.dart';
import 'package:fetprojet/pages/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';

class Session extends StatefulWidget {
 

  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  final List<Map<String, dynamic>> sessions = [];
  final AuthService _authService = AuthService();
  final ApiService apiService = ApiService();
        

  @override
  void initState() {
    super.initState();
     print('Initializing Sessions...');
    _loadSessions();
  }

  void _loadSessions() async {
    try {
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userid = prefs.getString("userId");
      final userSessions = await apiService.fetchSessions(userid);
      final List<String> sessionList = List<String>.from(userSessions['sessionList']);

      if (sessionList.isNotEmpty) {
        for (String sessionId in sessionList) {
          final sessionDetails = await apiService.fetchSessionDetails(sessionId);
          sessionDetails['sessionId'] = sessionId;
          setState(() {
            sessions.add(sessionDetails);
            print("sesssion desponible $sessions");
          });
        }
      } else {
        print('No sessions found');
      }
    } catch (e) {
      print('Failed to load sessions: $e');
    }
  }

  void _deleteSession(int index) {
    setState(() {
      sessions.removeAt(index);
    });
  }

  Widget _getDayStatusWidget(String day, List<String> activeDays) {
    bool isActive = activeDays.contains(day);
    return CircleAvatar(
      radius: 8,
      backgroundColor: isActive ? Colors.green : Colors.red,
      child: Text(
        day[0], // Affiche la première lettre du jour
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
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
              backgroundImage:  AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
          ),
          const SizedBox(width: 10),
        ],
        title: const Text("Session"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionForm(),
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
                final activeDays = List<String>.from(session['activeDays']);
                return ListTile(
                  title: Text(session["universityName"] ?? 'No University'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Year: ${session["year"] ?? 'No Year'}"),
                      Row(
                        children: [
                          ...['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
                              .map((day) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: _getDayStatusWidget(day, activeDays),
                                  ))
                              .toList(),
                        ],
                      ),
                    ],
                  ),
                  leading: const Icon(Icons.event),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () => _deleteSession(index),
                  ),
                  onTap: () async{
                     final SharedPreferences prefs = await SharedPreferences.getInstance();
                     await prefs.setString("sessionId", session["sessionId"]);
                                       //   await prefs.setString("sessionId", '6767ed5018e2bd7ea42682c8');


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(), // Navigating to Dashboard
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
