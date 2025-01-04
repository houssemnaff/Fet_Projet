import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:fetprojet/components/drawer.dart';

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
  const EtudiantPage({super.key});

  @override
  _EtudiantPageState createState() => _EtudiantPageState();
}

class _EtudiantPageState extends State<EtudiantPage> {
  final List<Etudiant> teachers = List.generate(
    20,
    (index) => Etudiant(
      id: index + 1,
      name: 'Etudiant ${index + 1}',
      cin: 'CIN${index + 100}',
      email: 'Etudiant${index + 1}@example.com',
    ),
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _cin = '';
  String _email = '';

  void _addEtudiant() {
    _name = '';
    _cin = '';
    _email = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Etudiant'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) => _name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cinController,
                  decoration: const InputDecoration(labelText: 'CIN'),
                  onChanged: (value) => _cin = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a CIN';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
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
              child: const Text('Cancel'),
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
                    ));
                  });
                  Navigator.of(context).pop();
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: 'Insertion Completed Successfully!',
                  );
                }
              },
              child: const Text('Add'),
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
      drawer: const DrawerPage(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Etudiants'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Blue background
        foregroundColor: Colors.white, // White text color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 20.0,
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('CIN')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: teachers.map((etudiant) {
                    return DataRow(cells: [
                      DataCell(Text(etudiant.id.toString())),
                      DataCell(Text(etudiant.name)),
                      DataCell(Text(etudiant.cin)),
                      DataCell(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green, size: 20),
                            onPressed: () {
                              // Edit functionality here
                            },
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        currentIndex: _btindex,
        selectedItemColor: Colors.blue, // Blue for selected items
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _btindex = index;
          });
          if (index == 2) {
            _addEtudiant();
          }
        },
      ),
    );
  }
}
