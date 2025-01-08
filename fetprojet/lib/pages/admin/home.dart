import 'package:fetprojet/authservice.dart';
import 'package:fetprojet/pages/about.dart';
import 'package:fetprojet/pages/admin/emploi/emploi.dart';
import 'package:fetprojet/pages/admin/program/programs.dart';
import 'package:fetprojet/pages/admin/subjects/subjects.dart';
import 'package:fetprojet/pages/admin/romms/rooms.dart';
import 'package:fetprojet/pages/langagepagr.dart';
import 'package:fetprojet/pages/profil.dart';
import 'package:flutter/material.dart';
import 'package:fetprojet/class/menuitem.dart';
import 'package:fetprojet/components/drawer.dart';
import 'package:fetprojet/pages/admin/department/departementsview.dart';
import 'package:fetprojet/pages/admin/session/sessionform.dart';
import 'package:fetprojet/pages/admin/etudiant/uplodfileetudiant.dart';
import 'package:fetprojet/pages/admin/class/classs.dart';
import 'package:fetprojet/pages/admin/prof/telechargerprof.dart';

class Dashboard extends StatefulWidget {

  AuthService authservice = AuthService();

  Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 final List<MenuItem> menuItems = [
  MenuItem(
    'Class',
    Icons.class_,
    (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DepartmentClassPage()),
      );
    },
  ),
  MenuItem(
    'Subjects',
    Icons.subject,
    (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SubjectsPage()),
      );
    },
  ),
  MenuItem(
    'Etudiants',
    Icons.people,
    (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FileUploadPage()),
      );
    },
  ),
  MenuItem(
    'Departments',
    Icons.apartment,
    (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DepartmentPage()),
      );
    },
  ),
  MenuItem(
    'Program',
    Icons.school,
    (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProgramPage()),
      );
    },
  ),
  MenuItem(
    'Emploi',
    Icons.schedule,
    (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScheduleManagementPage()),
      );
    },
  ),
  MenuItem(
    'Teachers',
    Icons.person,
    (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FileUploadPageprof()),
      );
    },
  ),
  MenuItem(
    'Languages',
    Icons.language,
    (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
      );
    },
  ),
  MenuItem(
    'Rooms',
    Icons.meeting_room,
    (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoomPage()),
      );
    },
  ),
];

late int _btindex = 0;
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Naffouti Houssem",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Image with Shadow
          Container(
            margin: const EdgeInsets.all(16),
            height: 180,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/background.jpeg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          // Menu Title
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'MENU PRINCIPAL',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          // Menu Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return InkWell(
                  onTap: () {
                    if (item.routerpage != null) {
                      item.routerpage!(context);
                    }
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          menuItems[index].icon,
                          size: 40,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          menuItems[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
     bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Overview'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
   
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'À Propos'),
    BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Déconnexion'),
  ],
  currentIndex: _btindex,
  selectedItemColor: Colors.blue,
  unselectedItemColor: Colors.grey,
  onTap: (index) {
    setState(() {
      _btindex = index; // Update selected index
    });
    if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage()),
        );
    }
    if (index == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutPage()),
        );
    }
    if (index == 3) {
      AuthService().logout(context);
    }
  },
),

    );
  }
}
