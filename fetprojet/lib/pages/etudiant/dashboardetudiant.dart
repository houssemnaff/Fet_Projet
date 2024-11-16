import 'dart:math';

import 'package:fetprojet/class/menuitem.dart';
import 'package:fetprojet/components/drawer.dart';
import 'package:fetprojet/pages/profil.dart';
import 'package:flutter/material.dart';

class DashEtudiant extends StatelessWidget {
  DashEtudiant({super.key});

  final List<MenuItem> menuItems = [
    MenuItem('Absences', Icons.event_busy),
    MenuItem('Résultats', Icons.school),
    MenuItem('Emploi', Icons.schedule),
    MenuItem('Mon Groupe', Icons.group),
    MenuItem('Langues', Icons.language),
    MenuItem('Mon Solde', Icons.attach_money),
    MenuItem('Message', Icons.message),
    MenuItem('homework', Icons.work_history),
     MenuItem('cours', Icons.bookmarks),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(),
      appBar: AppBar(
        title: Text("Houssem naffouti"),
        backgroundColor: Colors.blue,
        actions:  [
          Padding(
            padding: EdgeInsets.only(right: 13.0),
            child: InkWell(
              onTap: (){
                 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(("assets/background.jpeg")),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 7.0),
            child: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(6),
            height: 180,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/background.jpeg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(" Lna talqa kol chy"),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return InkWell(
                  onTap: () {
                    if (item.routerpage != null) {
                      item.routerpage!(
                          context); // Call the router function if it exists
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          menuItems[index].icon,
                          size: 40,
                          color: const Color.fromARGB(255, 191, 25, 25),
                        ),
                        SizedBox(height: 8),
                        Text(
                          menuItems[index].title,
                          textAlign: TextAlign.center,
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
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Contactez-nous',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'A Propos de',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Déconnexion',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Function(BuildContext) route(Widget Function() pageBuilder) {
    return (BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => pageBuilder()),
      );
    };
  }
}
