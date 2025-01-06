import 'package:fetprojet/pages/admin/department/departementsview.dart';
import 'package:fetprojet/pages/admin/etudiant/etudiants.dart';
import 'package:fetprojet/pages/admin/home.dart';
import 'package:fetprojet/pages/admin/prof/profs.dart';
import 'package:fetprojet/pages/admin/session/session.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> drawerItems = [
      {"icon": Icons.dashboard, "title": "Overview", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()))},
      {"icon": Icons.school, "title": "Department",  "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) => DepartmentPage()))},
      {"icon": Icons.access_time, "title": "Session", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  Session()))},
      {"icon": Icons.account_circle, "title": "Etudiant", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  EtudiantPage()))},
      {"icon": Icons.person_outline, "title": "Teacher",  "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  TeacherPage()))},
      {"icon": Icons.calendar_today, "title": "Emploi", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()))},
      {"icon": Icons.class_, "title": "Class", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()))},
         {"icon": Icons.settings, "title": "Settings", "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  Dashboard()))},

    ];

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
            child: const Column(
              children: [
                Text(
                  'Welcome, Houssem',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'houssemnaffouti28@gmail.com',
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
                title: Text(item["title"], style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w600)), // Styled text
                trailing: item["trailing"] != null
                    ? ClipOval(
                        child: Container(
                          color: Colors.red,
                          width: 20,
                          height: 20,
                          child: Center(
                            child: Text(
                              item["trailing"],
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      )
                    : null,
                onTap: item["onTap"] as VoidCallback?,
              ),
            );
          }),
        ],
      ),
    );
  }
}
