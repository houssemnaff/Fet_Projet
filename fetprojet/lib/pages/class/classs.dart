import 'package:fetprojet/pages/admin/telechargerprof.dart';
import 'package:fetprojet/pages/admin/uplodfileetudiant.dart';
import 'package:flutter/material.dart';

class DepartmentClassPage extends StatefulWidget {
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
        title: Text('Class Registration'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Department dropdown
            DropdownButton<String>(
              value: selectedDepartment,
              hint: Text('Select Department'),
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
            SizedBox(height: 20),

            // Class name input
            TextField(
              controller: classNameController,
              decoration: InputDecoration(labelText: 'Class Name'),
            ),
            SizedBox(height: 20),

            // Register button
            ElevatedButton(
              onPressed: _registerClass,
              child: Text('Register Class'),
            ),
            SizedBox(height: 20),

            // Available Classes
            Text('Available Classes:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: addedClasses.length,
                itemBuilder: (context, index) {
                  final classInfo = addedClasses[index];
                  return ListTile(
                    title: Text('${classInfo['class']}'),
                    subtitle: Text('Department: ${classInfo['department']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () => _editClass(index),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteClass(index),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.people,
                            color: Colors.green,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FileUploadPage()),
                          ),
                        ),
                      ],
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
