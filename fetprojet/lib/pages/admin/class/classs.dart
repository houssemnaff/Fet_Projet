import 'package:fetprojet/pages/admin/prof/telechargerprof.dart';
import 'package:fetprojet/pages/admin/etudiant/uplodfileetudiant.dart';
import 'package:flutter/material.dart';

class DepartmentClassPage extends StatefulWidget {
  const DepartmentClassPage({super.key});

  @override
  _DepartmentClassPageState createState() => _DepartmentClassPageState();
}

class _DepartmentClassPageState extends State<DepartmentClassPage> {
  final List<String> departments = [
    'Computer Science',
    'Mathematics',
    'Physics'
  ];
  String? selectedDepartment;
  TextEditingController classNameController = TextEditingController();
  List<Map<String, String>> addedClasses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                  // App Header
                  Text(
                    'Enregistrement des class',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Sélectionnez un département et enregistrez un class',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                     // textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Department dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: selectedDepartment,
                hint: const Text('Sélectionner un Département'),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                  });
                },
                items: departments.map((department) {
                  return DropdownMenuItem(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Class name input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: classNameController,
                decoration: const InputDecoration(labelText: 'Nom du class'),
              ),
            ),
            const SizedBox(height: 20),

            // Register button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _registerClass,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Enregistrer le class'),
              ),
            ),
            const SizedBox(height: 20),

            // Available Classes Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'class Disponibles:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // List of added classes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: addedClasses.length,
                itemBuilder: (context, index) {
                  final classInfo = addedClasses[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('${classInfo['class']}'),
                      subtitle: Text('Département: ${classInfo['department']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editClass(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteClass(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.people, color: Colors.green),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FileUploadPage()),
                            ),
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
      ),
    );
  }

  void _registerClass() {
    if (selectedDepartment != null && classNameController.text.isNotEmpty) {
      setState(() {
        addedClasses.add({
          'class': classNameController.text,
          'department': selectedDepartment!,
        });
      });
      classNameController.clear();
    }
  }

  void _editClass(int index) {
    classNameController.text = addedClasses[index]['class']!;
    selectedDepartment = addedClasses[index]['department'];
    setState(() {
      addedClasses.removeAt(index);
    });
  }

  void _deleteClass(int index) {
    setState(() {
      addedClasses.removeAt(index);
    });
  }
}
