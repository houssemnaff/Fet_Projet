import 'package:fetprojet/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Etudiant {
  final int id;
  final String name;
  final String cin;
  final String email;

 

  Etudiant({
    required this.id,
    required this.name,
    required this.cin,
    required this.email,
    
  });
}

class EtudiantPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<EtudiantPage> {
  final List<Etudiant> teachers = List.generate(
    20, // Generate 20 teachers
    (index) => Etudiant(
      id: index + 1,
      name: 'Etudiant ${index + 1}',
      cin: 'CIN${index + 100}', // Example CIN as a string
      email: 'Etudiant${index + 1}@example.com', // Example email

     
    ),
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _cin = '';
   String _clas = '';
  String _email = '';
 

  void _addTeacher() {
    _name = '';
    _cin = '';
    _email = '';


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Etudiant'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) => _name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'CIN'),
                  onChanged: (value) => _cin = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a CIN';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Class'),
                  onChanged: (value) => _clas = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a CIN';
                    }
                    return null;
                  },
                ),
                TextFormField(
                 keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) => _email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(.[a-zA-Z]+)?$",
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                 
                  setState(() {
                    teachers.add(Etudiant(
                      id: teachers.length + 1,
                      name: _name,
                      cin: _cin,
                      email: _email,

                      // Exemple de logique pour le status
                    ));
                  });
                  Navigator.of(context).pop();
                   QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: 'insertion Completed Successfully!',
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  late int _btindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icône de retour
          onPressed: () {
            Navigator.pop(context); // Retourner à la page précédente
          },
        ),
        title: Text('Etudiants'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minWidth: MediaQuery.of(context).size.width),
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing:
                      20.0, // Adjust column spacing for better visibility
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('cin')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: teachers.map((teacher) {
                    return DataRow(cells: [
                      DataCell(Text(teacher.id.toString())),
                      DataCell(Text(teacher.name)),
                       DataCell(Text(teacher.cin)),
                    
                      DataCell(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon:
                                Icon(Icons.edit, color: Colors.green, size: 20),
                            onPressed: () {
                              // Edit functionality here
                            },
                          ),
                          SizedBox(width: 8), // Space between icons
                          IconButton(
                            icon:
                                Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () {
                              // Delete functionality here
                            },
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Teachers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: 40), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        currentIndex: _btindex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _btindex = index; // Update selected index
          });
          if (index == 2) {
            _addTeacher();
          }
        },
      ),
    );
  }
}