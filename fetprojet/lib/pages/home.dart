import 'package:fetprojet/pages/admin/session.dart';
import 'package:fetprojet/pages/admin/sessionform.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(
      'Note D\'info',
      Icons.info,
      (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SessionForm()),
        );
      },
    ),
    MenuItem(
      'Messages',
      Icons.mail,
      (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SessionForm()),
        );
      },
    ),
    MenuItem(
      'Suggestions',
      Icons.feedback,
      (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SessionForm()),
        );
      },
    ),
    MenuItem('Absences', Icons.event_busy),
    MenuItem('Résultats', Icons.school),
    MenuItem('Emploi', Icons.schedule),
    MenuItem('Mon Groupe', Icons.group),
    MenuItem('Langues', Icons.language),
    MenuItem('Mon Solde', Icons.attach_money),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Header Image
          Container(
            margin: EdgeInsets.all(16),
            height: 180,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/background.jpeg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Menu Title
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'MENU PRINCIPALE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Menu Grid
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
                item.routerpage
                 !(context); // Call the router function if it exists
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
                          color: Colors.blue,
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

class MenuItem {
  final String title;
  final IconData icon;
  final Function(BuildContext)? routerpage; // Optional router function

  MenuItem(this.title, this.icon, [this.routerpage]); // Optional parameter for router
}
