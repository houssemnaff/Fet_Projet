import 'package:fetprojet/pages/admin/class/classs.dart';
import 'package:fetprojet/pages/admin/department/departementsview.dart';
import 'package:fetprojet/pages/admin/emploi/emploi.dart';
import 'package:fetprojet/pages/admin/etudiant/etudiants.dart';
import 'package:fetprojet/pages/admin/home.dart';
import 'package:fetprojet/pages/admin/prof/profs.dart';
import 'package:fetprojet/pages/admin/session/session.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  // This method retrieves the user's email and extracts the name before '@'.
  Future<String> _getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmaill = prefs.getString('userEmail');
        String? userEmail = prefs.getString('userEmail');

    if (userEmail != null && userEmail.contains('@')) {
      return userEmail.split('@')[0];  // Extracts the part before '@'
    }
    return 'No name found';  // Fallback in case email is not available or invalid
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> drawerItems = [
      {"icon": Icons.dashboard, "title": "Overview", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()))},
      {"icon": Icons.school, "title": "Department",  "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) => DepartmentPage()))},
      {"icon": Icons.access_time, "title": "Session", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  Session()))},
      {"icon": Icons.account_circle, "title": "Etudiant", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  EtudiantPage()))},
      {"icon": Icons.person_outline, "title": "Teacher",  "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  TeacherPage()))},
      {"icon": Icons.calendar_today, "title": "Emploi", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) =>ScheduleManagementPage()))},
      {"icon": Icons.class_, "title": "Class", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) => DepartmentClassPage()))},
    ];

    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading name'));
        }

        String userName = snapshot.data ?? 'No name found';

        return Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
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
                    Text(
                      'Welcome, $userName',  // Display the username instead of 'Houssem'
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      snapshot.data ?? 'No email found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30), // Space between header and menu items

              // Menu Items Section
              ...drawerItems.map((item) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent), // Adding border
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: ListTile(
                    leading: Icon(item["icon"], color: Colors.blue), // Styled icon
                    title: Text(
                      item["title"],
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w600,
                      ),
                    ), // Styled text
                    onTap: item["onTap"] as VoidCallback?,
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
